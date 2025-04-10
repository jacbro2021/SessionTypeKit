import Testing
import Foundation
@testable import SessionTypeKit

// MARK: - Concurrency‑Safe Test State
actor TestBaseExampleState {
    static let shared = TestBaseExampleState()
    var receivedResult: Int?

    func reset() {
        receivedResult = nil
    }
    
    func setResult(_ value: Int) {
        receivedResult = value
    }
    
    func getResult() -> Int? {
        return receivedResult
    }
}

// MARK: - Test Variant for the Interface

/// A test-specific implementation that captures the response in our concurrency‑safe actor.
final class TestBaseExampleInterface: Sendable {
    @Sendable public func startInteraction(
        _ endpoint: consuming TestBaseExampleProtocol.BaseServer.Dual,
        using session: Session.Dual
    ) async {
        // 1. Send the number to the server.
        let clientNumber = 42
        let sendEndpoint = await session.send(clientNumber, on: endpoint)
        
        // 2. Receive the incremented number from the server.
        let responseTuple = await session.recv(from: sendEndpoint)
        let result = responseTuple.getValue()
        
        // 3. Instead of printing, capture the result in our concurrency‑safe state.
        await TestBaseExampleState.shared.setResult(result)
        
        // 4. Close the session.
        session.close(responseTuple.getEndpoint())
    }
}

// MARK: - Test Variant for the Controller

final class TestBaseExampleController: @unchecked Sendable {
    @Sendable public func startInteraction(
        _ endpoint: consuming TestBaseExampleProtocol.BaseServer,
        using session: Session.Type
    ) async {
        // 1. Receive the number from the client.
        let numberTuple = await session.recv(from: endpoint)
        let number = numberTuple.getValue()
        
        // 2. Compute the incremented number.
        let incrementedNumber = number + 1
        
        // 3. Send the incremented value back to the client.
        let responseEndpoint = await session.send(incrementedNumber, on: numberTuple.getEndpoint())
        
        // 4. Close the session.
        session.close(responseEndpoint)
    }
}

enum TestBaseExampleProtocol {
    // The server receives an Int, sends back an Int, then closes the session.
    typealias BaseServer = Recv<Int, Send<Int, Close>>
}

// MARK: - Test Case Using the New Testing Library

@Test func baseExampleInteractionTest() async throws {
    // Reset the shared state in a concurrency‑safe way.
    await TestBaseExampleState.shared.reset()
    
    // Run the session using our production controller and the test interface variant.
    await Session.create(
        TestBaseExampleController().startInteraction,
        TestBaseExampleInterface().startInteraction
    )
    
    // Retrieve the result from our concurrency‑safe state.
    let receivedResult = await TestBaseExampleState.shared.getResult()
    
    // Verify that the interface received the correctly incremented value.
    // Since the interface sends 42, the controller should increment it to 43.
    #expect(receivedResult != nil)
    #expect(receivedResult! == 43)
}

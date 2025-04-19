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
        using session: DualSession.Type
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


// MARK: - Concurrency‑Safe Test State for Basic Branch
actor BasicBranchState {
    static let shared = BasicBranchState()
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

// MARK: - Basic Branch Protocol (Reordered)
// Here the outer Choose is defined with the failure branch on the left,
// and the success branch (an Offer with two inner branches) on the right.
// This matches the dual ordering of the ATM protocol.
enum BasicBranchProtocol {
    // The server receives an Int then chooses one of two outer branches:
    // • Left branch: a failure branch (Close) used if the number is negative.
    // • Right branch: a successful branch (Offer) containing:
    //       - Left inner branch: if number == 5, send (number + 1).
    //       - Right inner branch: otherwise, send (number - 1).
    typealias BranchServer =
        Recv<Int,
             Choose<
                 Offer<
                     Send<Int, Close>, // Left inner branch: addition.
                     Send<Int, Close>  // Right inner branch: subtraction.
                 >,
                Close
             >
        >
}

// MARK: - Basic Branch Interface (Client)
// This code mirrors the ATMInterface style. It sends the test number,
// then calls session.offer on the returned endpoint and switches on the outer choice.
final class BasicBranchInterface: Sendable {
    @Sendable public func startInteraction(
        _ endpoint: consuming BasicBranchProtocol.BranchServer.Dual,
        using session: DualSession.Type
    ) async {
        // Send the test number.
        let testNumber = 5    // With 5 we expect the "addition" outcome.
        let branchEndpoint = await session.send(testNumber, on: endpoint)
        
        // Receive the outer branch decision.
        let outerChoice = await session.offer(branchEndpoint)
        switch consume outerChoice {
        case .right(let failureEndpoint):
            // Failure branch was chosen; simply close the channel.
            session.close(failureEndpoint)
        case .left(let offer):
            // Successful branch: we got an Offer.
            // Since testNumber is 5, we expect the addition branch (left).
            let addEndpoint = await session.left(offer)
            let resultTuple = await session.recv(from: addEndpoint)
            let result = resultTuple.getValue()
            await BasicBranchState.shared.setResult(result)
            session.close(resultTuple.getEndpoint())
        }
    }
}

// MARK: - Basic Branch Controller (Server)
// This implementation is modeled on the ATMController.
// The controller receives the number and then chooses which branch to take.
final class BasicBranchController: @unchecked Sendable {
    @Sendable public func startInteraction(
        _ endpoint: consuming BasicBranchProtocol.BranchServer,
        using session: Session.Type
    ) async {
        // Receive the number from the client.
        let numberTuple = await session.recv(from: endpoint)
        let number = numberTuple.getValue()
        let branchEndpoint = numberTuple.getEndpoint()
        
        if number < 0 {
            // Negative number: choose the failure branch.
            let failureEndpoint = await Session.right(branchEndpoint)
            Session.close(failureEndpoint)
        } else {
            // Non-negative: choose the successful branch (right).
            let offer = await session.left(branchEndpoint)
            if number == 5 {
                // For number == 5, choose the left inner branch (addition).
                let addEndpoint = await session.offer(offer)
                let result = number + 1    // 5 + 1 = 6.
                
                switch consume addEndpoint {
                case .left(let left):
                    let finalEndpoint = await session.send(result, on: left)
                    session.close(finalEndpoint)
                case .right(let right):
                    let finalEndpoint = await session.send(result, on: right)
                    session.close(finalEndpoint)
                }
                //            } else {
                //                // Otherwise, choose the right inner branch (subtraction).
                //                let subtractEndpoint = await session.right(offer)
                //                let result = number - 1
                //                let finalEndpoint = await session.send(result, on: subtractEndpoint)
                //                session.close(finalEndpoint)
                //            }
            }
        }
    }
    
    // MARK: - Test Case for the Basic Branch Interaction
    @Test func basicBranchTest() async throws {
        // Reset shared test state.
        await BasicBranchState.shared.reset()
        
        // Create the session with the controller (server) and interface (client).
        await Session.create(
            BasicBranchController().startInteraction,
            BasicBranchInterface().startInteraction
        )
        
        // Retrieve and verify the result.
        let result = await BasicBranchState.shared.getResult()
        
        // For testNumber 5, we expect the result to be 6.
        #expect(result != nil)
        #expect(result! == 6)
    }
}

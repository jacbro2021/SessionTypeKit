//
//  BaseExampleInterface.swift
//  SessionTypeKit
//
//  Created by Noah Frahm on 4/10/25.
//
import SessionTypeKit

final class BaseExampleInterface: Sendable {
    @Sendable public func startInteraction(
        _ endpoint: consuming BaseExampleProtocol.BaseServer.Dual,
        using session: Session.Dual
    ) async {
        // 1. Send a number to the server.
        let clientNumber = 42  // You can replace 42 with any number or input mechanism.
        let sendEndpoint = await session.send(clientNumber, on: endpoint)
        
        // 2. Receive the incremented number from the server.
        let responseTuple = await session.recv(from: sendEndpoint)
        let result = responseTuple.getValue()
        
        // 3. Print the result.
        print("Incremented number received from server: \(result)")
        
        // 4. Close the session.
        session.close(responseTuple.getEndpoint())
    }
}

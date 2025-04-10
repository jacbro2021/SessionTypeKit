//
//  BaseExampleController.swift
//  SessionTypeKit
//
//  Created by Noah Frahm on 4/10/25.
//
import SessionTypeKit

final class BaseExampleController: @unchecked Sendable {
    @Sendable public func startInteraction(
        _ endpoint: consuming BaseExampleProtocol.BaseServer,
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

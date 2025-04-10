//
//  ATMClient.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SessionTypeKit

final class ATMInterface: Sendable {
    @Sendable public func startATMInteraction(_ endpoint: consuming ATMProtocol.AtmServer.Dual,
                                              using session: DualSession.Type)
    async {
        let offerEndpoint = await session.send(1234, on: endpoint)
        let choice = await session.offer(offerEndpoint)

        switch consume choice {
        case .left(let success):
           
            let interactionChoice = getIntInput(prompt: "Enter 1 to deposit, 2 to withdraw",
                                                errorMessage: "Invalid number selected",
                                                in: 1...3)
            if interactionChoice == 1 {
                let depositEndpoint = await session.left(success)
                let amount = getIntInput(prompt: "Enter the amount to deposit",
                                         errorMessage: "Invalid deposit amount entered",
                                         in: 0...100)
                let balanceEndpoint = await session.send(amount, on: depositEndpoint)
                let balanceTuple = await session.recv(from: balanceEndpoint)
                print(balanceTuple.getValue())
                session.close(balanceTuple.getEndpoint())
            } else {
                let withdrawEndpoint = await session.right(success)
                let amount = getIntInput(prompt: "Enter the amount to withdraw",
                                         errorMessage: "Invalid deposit amount entered",
                                         in: 0...100)
                let closeEndpoint = await session.send(amount, on: withdrawEndpoint)
                session.close(closeEndpoint)
            }
            
        case .right(let failure):
            Session.close(failure)
        }
    }
    
    private func getIntInput(prompt: String, errorMessage: String, in range: ClosedRange<Int>? = nil) -> Int {
        print(prompt)
        if let rawInput = readLine(),
           let input = Int(rawInput)
        {
            guard let range else { return input }
            if range.contains(input) { return input }
        }
            
        fatalError(errorMessage)
    }
}

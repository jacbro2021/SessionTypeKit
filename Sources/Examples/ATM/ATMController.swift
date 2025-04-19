//
//  ATMServer.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SwiftSessionTypes

final class ATMController: @unchecked Sendable {
    var bankAccount: BankAccount!

    @Sendable public func startATMInteraction(_ endpoint: consuming ATMProtocol.AtmServer,
                                              using session: Session.Type
    ) async {
        let pinTuple = await session.recv(from: endpoint)
        let pin = pinTuple.getValue()
        let AuthChoiceEndpoint = pinTuple.getEndpoint()

        if let account = BankAccount.getAccount(pin: pin) {
            bankAccount = account
            
            let interactionEndpoint = await session.left(AuthChoiceEndpoint)
            let interactionChoice = await session.offer(interactionEndpoint)
            
            switch consume interactionChoice {
            case .left(let deposit):
                let amountTuple = await session.recv(from: deposit)
                bankAccount.balance += Double(amountTuple.getValue())
                let closeEndpoint = await session.send(Int(bankAccount.balance.rounded()), on: amountTuple.getEndpoint())
                session.close(closeEndpoint)
            case .right(let withdraw):
                let amountTuple = await session.recv(from: withdraw)
                bankAccount.balance -= Double(amountTuple.getValue())
                session.close(amountTuple.getEndpoint())
            }
            
        } else {
            let closeEndpoint = await Session.right(AuthChoiceEndpoint)
            Session.close(closeEndpoint)
        }
    }
}

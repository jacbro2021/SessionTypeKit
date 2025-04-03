//
//  ATMServer.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SessionTypeKit

final class ATMController: @unchecked Sendable {
    var bankAccount: BankAccount!

    @Sendable public func startATMInteraction(_ endpoint: consuming ATMServerProtocol.Start) async {
        let pinCoupling = await Session.recv(from: endpoint)
        let pin = pinCoupling.getValue()
        
        if let bankAccount = BankAccount.getAccount(pin: pin) {
            self.bankAccount = bankAccount
            let choiceEndpoint = pinCoupling.getEndpoint()
            let successEndpoint = await Session.left(choiceEndpoint)
            await atmServerAuth(successEndpoint)
        } else {
            let choiceEndpoint = pinCoupling.getEndpoint()
            let failureEndpoint = await Session.right(choiceEndpoint)
            await atmServerError(failureEndpoint, error: "Invalid Pin!")
        }
    }
    
    private func atmServerAuth(_ endpoint: consuming ATMServerProtocol.InteractionProtocol) async {
        let msg = "Welcome \(bankAccount.name)!"
        
        let interactionChoice = await Session.send(msg, on: endpoint)
        let choice = await Session.offer(interactionChoice)
        
        switch consume choice {
        case .left(let depositEndpoint):
            await atmServerDeposit(depositEndpoint)
        case .right(let withdrawEndpoint):
            await atmServerWithdraw(withdrawEndpoint)
        }
    }
    
    private func atmServerDeposit(_ endpoint: consuming ATMServerProtocol.DepositProtocol) async {
        let depositCoupling = await Session.recv(from: endpoint)
        let depositAmount = depositCoupling.getValue()
        let nextEndpoint = depositCoupling.getEndpoint()

        if depositAmount > 0 {
            bankAccount.balance += depositAmount
            let succededDepositEndpoint = await Session.left(nextEndpoint)
            await atmServerSuccess(succededDepositEndpoint)
        } else {
            let invalidDepositEndpoint = await Session.right(nextEndpoint)
            await atmServerError(invalidDepositEndpoint, error: "Invalid deposit amount. Terminating Session...")
        }
    }
    
    private func atmServerWithdraw(_ endpoint: consuming ATMServerProtocol.WithdrawProtocol) async {
        let withdrawCoupling = await Session.recv(from: endpoint)
        let withdrawAmount = withdrawCoupling.getValue()
        let nextEndpoint = withdrawCoupling.getEndpoint()
        
        if withdrawAmount > 0, withdrawAmount <= bankAccount.balance {
            bankAccount.balance -= withdrawAmount
            let succededWithdrawEndpoint = await Session.left(nextEndpoint)
            await atmServerSuccess(succededWithdrawEndpoint)
        } else {
            let invalidWithdrawEndpoint = await Session.right(nextEndpoint)
            await atmServerError(invalidWithdrawEndpoint, error: "Invalid withdraw amount. Terminating Session...")
        }
    }
    
    private func atmServerSuccess(_ endpoint: consuming ATMServerProtocol.SuccessProtocol) async {
        let msg = "Transaction successful! \nCurrent balance: $\(bankAccount.balance) \nTerminating Session..."
        let terminatingEndpoint = await Session.send(msg, on: endpoint)
        Session.close(terminatingEndpoint)
    }
    
    private func atmServerError(_ endpoint: consuming ATMServerProtocol.ErrorProtocol, error: String) async {
        let terminationEndpoint = await Session.send(error, on: endpoint)
        Session.close(terminationEndpoint)
    }
}

//
//  ATMClient.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SessionTypeKit

final class ATMInterface: Sendable {
    @Sendable public func startATMInteraction(_ endpoint: consuming ATMServerProtocol.Start.Dual) async {
        let pin = getIntInput(prompt: "Enter your pin:", errorMessage: "Invalid pin. Terminating...")
        let pinVerification = await Session.send(pin, on: endpoint)
        let pinVerificationResult = await Session.offer(pinVerification)
            
        switch consume pinVerificationResult {
        case .left(let interactionEndpoint):
            await atmServerAuth(interactionEndpoint.flip())
        case .right(let errorEndpoint):
            await atmServerError(errorEndpoint.flip())
        }
    }
    
    private func atmServerAuth(_ endpoint: consuming ATMServerProtocol.InteractionProtocol.Dual) async {
        let interactionTuple = await Session.recv(from: endpoint)
        let msg = interactionTuple.getValue()
        let interactionChoiceEndpoint = interactionTuple.getEndpoint()
        
        print(msg)
        let interactionSelection = getIntInput(prompt: "Choose an option: \n1. Deposit \n2. Withdraw",
                                               errorMessage: "Invalid option selected.",
                                               in: 1 ... 3)
        
        if interactionSelection == 1 {
            await atmServerDeposit(await Session.left(interactionChoiceEndpoint).flip())
        } else if interactionSelection == 2 {
            await atmServerWithdraw(await Session.right(interactionChoiceEndpoint).flip())
        }
    }
    
    private func atmServerDeposit(_ endpoint: consuming ATMServerProtocol.DepositProtocol.Dual) async {
        let amount = getDoubleInput(prompt: "Enter the amount to deposit: ",
                                    errorMessage: "Invalid amount entered. Terminating...")
        let statusChoice = await Session.send(amount, on: endpoint)
        let choice = await Session.offer(statusChoice)
        switch consume choice {
        case .left(let successEndpoint):
            await atmServerSuccess(successEndpoint.flip())
        case .right(let errorEndpoint):
            await atmServerError(errorEndpoint.flip())
        }
    }
    
    private func atmServerWithdraw(_ endpoint: consuming ATMServerProtocol.WithdrawProtocol.Dual) async {
        let amount = getDoubleInput(prompt: "Enter the amount to withdraw: ",
                                    errorMessage: "Invalid amount entered. Terminating...")
        let statusChoice = await Session.send(amount, on: endpoint)
        let choice = await Session.offer(statusChoice)
        switch consume choice {
        case .left(let successEndpoint):
            await atmServerSuccess(successEndpoint.flip())
        case .right(let errorEndpoint):
            await atmServerError(errorEndpoint.flip())
        }
    }
    
    private func atmServerSuccess(_ endpoint: consuming ATMServerProtocol.SuccessProtocol.Dual) async {
        let successTuple = await Session.recv(from: endpoint)
        let msg = successTuple.getValue()
        let finalEndpoint = successTuple.getEndpoint()
        print(msg)
        
        Session.close(finalEndpoint)
    }
    
    private func atmServerError(_ endpoint: consuming ATMServerProtocol.ErrorProtocol.Dual) async {
        let errorTuple = await Session.recv(from: endpoint)
        let msg = errorTuple.getValue()
        let finalEndpoint = errorTuple.getEndpoint()
        print(msg)
        
        Session.close(finalEndpoint)
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
    
    private func getDoubleInput(prompt: String, errorMessage: String, in range: ClosedRange<Double>? = nil) -> Double {
        print(prompt)
        if let rawInput = readLine(),
           let input = Double(rawInput)
        {
            guard let range else { return input }
            if range.contains(input) { return input }
        }
        
        fatalError(errorMessage)
    }
}

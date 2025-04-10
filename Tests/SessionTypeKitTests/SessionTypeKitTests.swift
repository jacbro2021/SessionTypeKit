import Testing
import Foundation
@testable import SessionTypeKit


@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//    await Session.create(BaseExampleSender().start, BaseExampleReceiver().start)
}


//class BaseExampleProtocol {
//    typealias proto = Endpoint<Empty, Coupling<Int, Endpoint<Empty, Empty>>>
//}
//
//final class BaseExampleReceiver: Sendable {
//    @Sendable func start(_ endpoint: consuming BaseExampleProtocol.proto) async {
//        let tup = await Session.recv(from: endpoint)
//        print("Recieved value: \(tup.getValue())")
//        let end = tup.getEndpoint()
//        Session.close(end)
//    }
//}
//
//final class BaseExampleSender: Sendable {
//    @Sendable func start(_ endpoint: consuming BaseExampleProtocol.proto.Dual) async {
//        let val = 2
//        let end = await Session.send(val, on: endpoint)
//        /// Uncomment the below line to see an example of the error that appears
//        ///  as a result of violating the linearity constraint of session types.
////        let consumptionError = await Session.send(val, on: endpoint)
//        Session.close(end)
//    }
//}
//


//final class ATMController: @unchecked Sendable {
//    var bankAccount: BankAccount!
//
//    @Sendable public func startATMInteraction(_ endpoint: consuming ATMProtocol.AtmServer,
//                                              using session: Session.Type
//    ) async {
//        let pinTuple = await session.recv(from: endpoint)
//        let pin = pinTuple.getValue()
//        let AuthChoiceEndpoint = pinTuple.getEndpoint()
//
//        if let account = BankAccount.getAccount(pin: pin) {
//            bankAccount = account
//            
//            let interactionEndpoint = await session.left(AuthChoiceEndpoint)
//            let interactionChoice = await session.offer(interactionEndpoint)
//            
//            switch consume interactionChoice {
//            case .left(let deposit):
//                let amountTuple = await session.recv(from: deposit)
//                bankAccount.balance += Double(amountTuple.getValue())
//                let closeEndpoint = await session.send(Int(bankAccount.balance.rounded()), on: amountTuple.getEndpoint())
//                session.close(closeEndpoint)
//            case .right(let withdraw):
//                let amountTuple = await session.recv(from: withdraw)
//                bankAccount.balance -= Double(amountTuple.getValue())
//                session.close(amountTuple.getEndpoint())
//            }
//            
//        } else {
//            let closeEndpoint = await Session.right(AuthChoiceEndpoint)
//            Session.close(closeEndpoint)
//        }
//    }
//}
//
//
//final class ATMInterface: Sendable {
//    
//    @Sendable public func startATMInteraction(_ endpoint: consuming ATMProtocol.AtmServer.Dual,
//                                              using session: Session.Dual)
//    async {
//        let offerEndpoint = await session.send(1234, on: endpoint)
//        let choice = await session.offer(offerEndpoint)
//        
//        switch consume choice {
//        case .left(let success):
//            
//            let interactionChoice = getIntInput(prompt: "Enter 1 to deposit, 2 to withdraw",
//                                                errorMessage: "Invalid number selected",
//                                                in: 1...3)
//            if interactionChoice == 1 {
//                let depositEndpoint = await session.left(success)
//                let amount = getIntInput(prompt: "Enter the amount to deposit",
//                                         errorMessage: "Invalid deposit amount entered",
//                                         in: 0...100)
//                let balanceEndpoint = await session.send(amount, on: depositEndpoint)
//                let balanceTuple = await session.recv(from: balanceEndpoint)
//                print(balanceTuple.getValue())
//                session.close(balanceTuple.getEndpoint())
//            } else {
//                let withdrawEndpoint = await session.right(success)
//                let amount = getIntInput(prompt: "Enter the amount to withdraw",
//                                         errorMessage: "Invalid deposit amount entered",
//                                         in: 0...100)
//                let closeEndpoint = await session.send(amount, on: withdrawEndpoint)
//                session.close(closeEndpoint)
//            }
//            
//        case .right(let failure):
//            Session.close(failure)
//        }
//    }
//    
//    private func getIntInput(prompt: String, errorMessage: String, in range: ClosedRange<Int>? = nil) -> Int {
//        print(prompt)
//        if let rawInput = readLine(),
//           let input = Int(rawInput)
//        {
//            guard let range else { return input }
//            if range.contains(input) { return input }
//        }
//        
//        fatalError(errorMessage)
//    }
//}
//    
//
//enum ATMProtocol {
//    typealias Pin = Int
//    typealias AtmDeposit = Recv<Int, Send<Int, Close>>
//    typealias AtmWithdraw = Recv<Int, Close>
//    typealias AtmServer =
//    Recv<Pin,
//        Choose<
//            Offer<
//                AtmDeposit,
//                AtmWithdraw
//            >,
//            Close
//        >
//    >
//}

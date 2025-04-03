//
//  ATMServerProtocol.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SessionTypeKit

enum ATMServerProtocol {
    typealias Start = Endpoint<Empty, Coupling<Int, Endpoint<Or<InteractionProtocol, ErrorProtocol>, Empty>>>
    typealias InteractionProtocol = Endpoint<Coupling<String, Endpoint<Or<DepositProtocol, WithdrawProtocol>, Empty>>, Empty>
    
    typealias DepositProtocol = Endpoint<Empty, Coupling<Double, Endpoint<Or<SuccessProtocol, ErrorProtocol>, Empty>>>
    typealias WithdrawProtocol = Endpoint<Empty, Coupling<Double, Endpoint<Or<SuccessProtocol, ErrorProtocol>, Empty>>>
    
    typealias SuccessProtocol = Endpoint<Coupling<String, Endpoint<Empty, Empty>>, Empty>
    typealias ErrorProtocol = Endpoint<Coupling<String, Endpoint<Empty, Empty>>, Empty>
}

//
//  ATMServerProtocol.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SwiftSessionTypes

enum ATMProtocol {
    typealias Pin = Int
    typealias AtmDeposit = Recv<Int, Send<Int, Close>>
    typealias AtmWithdraw = Recv<Int, Close>
    typealias AtmServer =
    Recv<Pin,
        Choose<
            Offer<
                AtmDeposit,
                AtmWithdraw
            >,
            Close
        >
    >
}




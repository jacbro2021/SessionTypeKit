//
//  BaseExampleSender.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SessionTypeKit

final class BaseExampleSender: Sendable {
    @Sendable func start(_ endpoint: consuming BaseExampleProtocol.proto.Dual) async {
        let val = 2
        let end = await Session.send(val, on: endpoint)
        /// Uncomment the below line to see an example of the error that appears
        ///  as a result of violating the linearity constraint of session types.
//        let consumptionError = await Session.send(val, on: endpoint)
        Session.close(end)
    }
}

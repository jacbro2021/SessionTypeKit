//
//  BaseExampleReciever.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SessionTypeKit

final class BaseExampleReceiver: Sendable {
    @Sendable func start(_ endpoint: consuming BaseExampleProtocol.proto) async {
        let tup = await Session.recv(from: endpoint)
        print("Recieved value: \(tup.getValue())")
        let end = tup.getEndpoint()
        Session.close(end)
    }
}

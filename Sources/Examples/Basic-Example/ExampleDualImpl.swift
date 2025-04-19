//
//  BaseExampleReciever.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SwiftSessionTypes

@Sendable func exampleImplementationDual(_ endpoint: consuming ExampleProtocol.proto.Dual,
                                         _ session: DualSession.Type) async
{
    let messageCoupling = await session.recv(from: endpoint)
    
    print("Dual implementation received message: \(messageCoupling.getValue())")
    let responseEndpoint = await session.left(messageCoupling.getEndpoint())
    
    let end = await session.send("world", on: responseEndpoint)
    
    session.close(end)
}

//
//  BaseExampleSender.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SwiftSessionTypes

@Sendable func exampleImplementation(_ endpoint: consuming ExampleProtocol.proto,
                                     _ session: Session.Type) async
{
    let offerEndpoint = await session.send("Hello", on: endpoint)
    let choice = await session.offer(offerEndpoint)
    
    switch consume choice {
    case .left(let responseEndpoint):
        let response = await session.recv(from: responseEndpoint)
        print("Primary implementation received: \(response.getValue())")
        session.close(response.getEndpoint())
        
    case .right(let end):
        session.close(end)
    }
}

//
//  Session+Communication.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/2/25.
//

import Foundation
import AsyncAlgorithms

extension Session {
    
    /// Sends a message to the endpoint and returns the continuation endpoint
    /// - Parameters:
    ///   - payload: The payload to be sent to the endpoint.
    ///   - endpoint: The endpoint to which the payload is sent. This endpoint is consumed by this operation.
    /// - Returns: The continuation endpoint
    public static func send<A: Sendable, B: ~Copyable, C: ~Copyable>(_ payload: A,
                                     on endpoint: consuming Endpoint<Coupling<A, Endpoint<B, C>>, Empty>)
        async -> Endpoint<C, B>
    {
        await endpoint.send(payload)
        return Endpoint<C, B>(from: endpoint)
    }

    /// Receives a message from the endpoint and returns it along with the continuation endpoint.
    /// - Parameter endpoint: The endpoint from which the message is received. This endpoint is consumed.
    /// - Returns: A tuple containing the received message and the continuation endpoint.
    public static func recv<A, B: ~Copyable, C: ~Copyable>(from endpoint: consuming Endpoint<Empty, Coupling<A, Endpoint<B, C>>>)
        async -> Coupling<A, Endpoint<B, C>>
    {
        let msg = await endpoint.recv()
        return Coupling(msg as! A, Endpoint<B, C>(from: endpoint))
    }
}

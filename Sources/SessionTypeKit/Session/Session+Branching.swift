//
//  Session+Branching.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/2/25.
//

import Foundation
import AsyncAlgorithms

/// Extension for the Session class that provides methods using endpoint passing for branching operations
/// between endpoints.
extension Session {
    
    /// Offers a choice between two branches on the given endpoint, and returns the selected branch.
    /// - Parameter endpoint: The endpoint to which the choice is offered. This endpoint expects a value indicating the selected branch (`true` for the first branch, `false` for the second branch). These option can be selected from the receiving endpoints using the .left or .right methods. This method consumes the endpoint that is passed into it.
    ///
    /// - Returns: An `Or` enum value containing either the first branch endpoint of type `Endpoint<A, B>` or the second branch endpoint of type `Endpoint<C, D>`.
    public static func offer<A: ~Copyable, B: ~Copyable, C: ~Copyable, D: ~Copyable>(_ endpoint: consuming Endpoint<Empty, Or<Endpoint<A, B>, Endpoint<C, D>>>)
        async -> Or<Endpoint<A, B>, Endpoint<C, D>>
    {
        let bool = await endpoint.recv() as! Bool
        if bool {
            return .left(Endpoint<A, B>(from: endpoint))
        } else {
            return .right(Endpoint<C, D>(from: endpoint))
        }
    }
    
    /// Selects the left branch on the given endpoint and returns the continuation endpoint.
    /// - Parameter endpoint: The endpoint on which the left branch is selected. This endpoint is consumed by this method.
    /// - Returns: The continuation endpoint of type `Endpoint<B, A>`.
    public static func left<A: ~Copyable, B: ~Copyable, C: ~Copyable, D: ~Copyable>(_ endpoint: consuming Endpoint<Or<Endpoint<A, B>, Endpoint<C, D>>, Empty>) async -> Endpoint<A, B> {
        await endpoint.send(true)
        return Endpoint<A, B>(from: endpoint)
    }
    
    /// Selects the left branch on the given endpoint and returns the continuation endpoint.
    /// - Parameter endpoint: The endpoint on which the left branch is selected. This endpoint is consumed by this method.
    /// - Returns: The continuation endpoint of type `Endpoint<B, A>`.
    public static func right<A: ~Copyable, B: ~Copyable, C: ~Copyable, D: ~Copyable>(_ endpoint: consuming Endpoint<Or<Endpoint<A, B>, Endpoint<C, D>>, Empty>) async -> Endpoint<C, D> {
        await endpoint.send(false)
        return Endpoint<C, D>(from: endpoint)
    }
}

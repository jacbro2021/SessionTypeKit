//
//  Session.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/2/25.
//

import Foundation
import AsyncAlgorithms

/// A utility class for implementing session-based communications using channels
public class Session {
    
    /// Creates a new session with two dual endpoints and executes the provided closures on each endpoint
    ///
    /// This method initializes a pair of dual endpoints and concurrently executes the provided closures.
    /// The first closure operates on the secondary endpoint of type `Endpoint<B, A>`, while the second closure
    /// operates on the primary endpoint of type `Endpoint<A, B>`.
    ///
    /// - Parameters:
    ///   - sideOne: The closure to be executed on the secondary endpoint of type `Channel<B, A>`.
    ///   - sideTwo: The closure to be executed on the primary endpoint of type `Endpoint<A, B>`.
    public static func create <A: ~Copyable, B: ~Copyable> (_ sideOne: @Sendable @escaping (_: consuming Endpoint<B, A>) async -> Void,
                                                              _ sideTwo: @Sendable @escaping (_: consuming Endpoint<A, B>) async -> Void)
        async
    {
        let channel: AsyncChannel<Sendable> = AsyncChannel()

        async let task1: Void = {
            let endpoint2 = Endpoint<B, A>(with: channel)
            await sideOne(consume endpoint2)
        }()

        async let task2: Void = {
            let endpoint1 = Endpoint<A, B>(with: channel)
            await sideTwo(consume endpoint1)
        }()

        _ = await (task1, task2)
    }

    /// Closes the endpoint, indicating the end of communication.
    /// - Parameter endpoint: The endpoint to close the communication. The endpoint is consumed after being passed to this method
    public static func close(_ endpoint: consuming Endpoint<Empty, Empty>) {
        endpoint.close()
    }
}





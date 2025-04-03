//
//  File.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/2/25.
//

import AsyncAlgorithms
import Foundation

/// Represents a communication endpoint that enforces session types.
///
/// This class provides a safe and linear way to communicate between different parts of your program using session types.
/// It guarantees that the endpoint is consumed only once, enforcing the expected communication pattern.
///
/// - Parameters:
///   - A: The type of messages that can be sent to the endpoint.
///   - B: The type of messages that can be received from the endpoint.
public struct Endpoint<A: ~Copyable, B: ~Copyable>: ~Copyable {
    
    /// Typealias for the reverse of this endpoint which can be useful when defining and using sessions.
    public typealias Dual = Endpoint<B, A>
   
    /// Underlying asynchronous channel for communication.
    private let channel: AsyncChannel<Sendable>

    /// Initializes a new endpoint with the given asynchronous channel.
    /// - Parameter channel: The underlying asynchronous channel for communication.
    init(with channel: AsyncChannel<Sendable>) {
        self.channel = channel
    }

    /// Initializes a new channel from an existing channel
    /// - Parameter endpoint: The existing endpoint from which to create the new endpoint.
    /// The original endpoint is consumed by this initializer.
    init<C: ~Copyable, D: ~Copyable>(from endpoint: consuming Endpoint<C, D>) {
        self.channel = endpoint.channel
    }

    public var description: String {
        "Endpoint<\(A.self), \(B.self)>"
    }
    
    /// creates a new endpoint from the current instance, consuming the current instance in the process.
    ///
    /// The new endpoint is the dual of the current instance.
    public consuming func flip() -> Dual {
        .init(with: channel)
    }
}

public extension Endpoint where A == Empty, B: ~Copyable {
    
    /// Receives an element from the async channel. Consumes the current instance.
    ///
    /// This method attempts to receive a message from the channel and consumes it.
    ///
    /// - Returns: the element received
    func recv() async -> Sendable {
        return await channel.first(where: { _ in true })!
    }
}

public extension Endpoint where A: ~Copyable, B == Empty {
    
    /// Sends the given element on the async channel. Consumes the current instance.
    ///
    /// This method sends a message to the channel and consumes it.
    ///
    /// - Parameter element: the element to be sent
    func send(_ element: Sendable) async {
        await channel.send(element)
    }
}

extension Endpoint where A == Empty, B == Empty {
    
    /// Resumes all the operations on the underlying asynchronous channel
    /// and terminates the communication. Consumes the current instance.
    ///
    /// This method closes the channel, signaling the end of communication.
    consuming func close() {
        channel.finish()
    }
}

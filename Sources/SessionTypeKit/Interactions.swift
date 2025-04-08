//
//  Interactions.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

/// The typealiases in this file can be daisy chained together to form a valid session type
/// that accurately portrays an interaction, without losing the readability that comes from specify an
/// interaction purely with endpoints. This form of specifying session types makes them appear more
/// similar to a 'protocol' and may be easier to use for many users.
///
/// The word protocol will be used interchangably with type here, describing an interaction between
/// two pieces of code.

/// Interaction used to create the type for sending a value to another endpoint.
///
/// T: The type being sent to the other endpoint.
/// E: The next step in the protocol.
public typealias Send<T, E: ~Copyable> = Endpoint<Coupling<T, E>, Empty>

/// Interaction used to create the type for recieving a value from another endpoint.
///
/// T: The type that will be received on this endpoint.
/// E: The next step in the protocol.
public typealias Recv<T, E: ~Copyable> = Endpoint<Empty, Coupling<T, E>>

/// Interaction used to create the type for offering a choice between two sub protocols to another endpoint.
///
/// A: the 'left' choice being offered as the next step.
/// B: the 'right' choice being offered as the next step.
public typealias Offer<A: ~Copyable, B: ~Copyable> = Endpoint<Empty, Or<A, B>>

/// Interaction used to create the type for choosing between two sub protocols sent from another endpoint.
///
/// A: the 'left' choice that can be chosen as the next step.
/// B: the 'right' choice that can be chosen as the next step.
public typealias Choose<A: ~Copyable, B: ~Copyable> = Endpoint<Or<A, B>, Empty>


/// Interaction used to create the type for ending a protocol.
public typealias Close = Endpoint<Empty, Empty>


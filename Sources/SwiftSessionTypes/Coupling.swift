//
//  Coupling.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/2/25.
//

import Foundation

/// Represents a pairing of an element as well as an Endpoint
/// that can be sent and recieved.
///
/// This struct functions as a workaround for the current lack of
/// support for non-copyable tuples.
public struct Coupling<A, B: ~Copyable>: ~Copyable {
    let value: A
    let endpoint: B
   
    /// Initializes a coupling with the given value as well as the
    /// provided non-copyable endpoint. Consumes the provided
    /// endpoint.
    init(_ value: consuming A, _ endpoint: consuming B) {
        self.value = value
        self.endpoint = endpoint
    }
  
    /// Getter for the value the coupling holds. Safe to call multiple times
    ///
    /// - Returns  A: The value held by the coupling.
    public func getValue() -> A {
        return value
    }

    /// Getter for the endpoint the coupling holds. Consumes the coupling
    ///  instance.
    ///
    ///  - Returns B: The endpoint held by the coupling.
    public consuming func getEndpoint() -> B {
        return self.endpoint
    }
}

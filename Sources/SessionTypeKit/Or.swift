//
//  Or.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/2/25.
//
import Foundation

/// Represents a binary branching point with two possible protocol choices
public enum Or <A: ~Copyable, B: ~Copyable>: ~Copyable {
    case left(A)
    case right(B)
}

//
//  BaseExampleProtocol.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import Foundation
import SessionTypeKit

class BaseExampleProtocol {
    typealias proto = Endpoint<Empty, Coupling<Int, Endpoint<Empty, Empty>>>
}

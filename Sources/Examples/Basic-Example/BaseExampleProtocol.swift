//
//  BaseExampleProtocol.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import Foundation
import SessionTypeKit

enum BaseExampleProtocol {
    // The server receives an Int, sends back an Int, then closes the session.
    typealias BaseServer = Recv<Int, Send<Int, Close>>
}

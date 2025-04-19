//
//  BaseExampleProtocol.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import Foundation
import SessionTypeKit

enum ExampleProtocol {
    typealias proto =
    Send<String,
         Offer<
            Recv<String, Close>,
            Close
         >
    >
}

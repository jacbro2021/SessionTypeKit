//
//  Lazy.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import Foundation

@propertyWrapper
struct Lazy<A> {
    var _value: A?
    
    var wrappedValue: A {
        get {
            if let _value {
                return _value
            } else {
                fatalError("Lazy value has not been initialized")
            }
        }
        
        set {
           _value = newValue
        }
    }
}

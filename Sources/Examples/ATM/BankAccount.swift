//
//  BankAccount.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import Foundation

struct BankAccount {
    let name: String
    let pin: Int
    var balance: Double

    mutating func withdraw(_ amount: Double) throws -> Double {
        if amount <= 0 {
            fatalError("Invalid withdraw amount")
        }
        
        if amount <= balance {
            balance -= amount
            return balance
        }
        
        fatalError("Insufficient funds.")
    }

    mutating func deposit(_ amount: Double) throws -> Double {
        if amount <= 0 {
            fatalError("Invalid withdraw amount")
        }
        
        balance += amount
        return balance
    }
}

extension BankAccount {
    private static let examples = [
        BankAccount(name: "John Doe", pin: 1234, balance: 100.0),
        BankAccount(name: "Jane Smith", pin: 5678, balance: 200.0),
    ]

    static func getAccount(pin: Int) -> BankAccount? {
        guard let account = examples.first(where: { $0.pin == pin }) else { return nil }
        return account
    }
}

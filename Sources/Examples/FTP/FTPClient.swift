//
//  FTPClient.swift
//  SwiftSessionTypes
//
//  Created by AlecNipp on 4/17/25.
//

import SwiftSessionTypes

enum FTPCommand: CustomStringConvertible {
    case put(String, String)
    case get(String)
    
    var description: String {
        switch self {
        case .put(let filename, let contents):
            return "put \(filename) \(contents)"
        case .get(let filename):
            return "get \(filename)"
        }
    }
}

final class FTPClient: Sendable {
    @Sendable public func startFTPInteraction(
        _ endpoint: consuming FTPProtocol.FtpServer.Dual,
        using session: DualSession.Type
    ) async {
        let command = getInputCommand(
            prompt: "Enter command ('put <filename> <contents>' or 'get <filename>'):",
            errorMessage: "Failed to get a valid command"
        )
        
        switch command {
        case .put(let filename, let contents):
            print("Uploading \(filename) with contents: \(contents)")
            
            let putBranch = await session.left(endpoint)
            let recvEndpoint = await session.send("\(filename) \(contents)", on: putBranch)
            let replyCoupling = await session.recv(from: recvEndpoint)
            
            print(replyCoupling.getValue())
            session.close(replyCoupling.getEndpoint())
            
        case .get(let filename):
            print("Downloading \(filename)...")
            
            let getBranch = await session.right(endpoint)
            let recvEndpoint = await session.send(filename, on: getBranch)
            let fileCoupling = await session.recv(from: recvEndpoint)
            
            print("Received contents: \(fileCoupling.getValue())")
            session.close(fileCoupling.getEndpoint())
        }
    }
    
    private func getInputCommand(prompt: String, errorMessage: String) -> FTPCommand {
        print(prompt)
        
        while let rawInput = readLine() {
            let tokens = rawInput
                .split(separator: " ")
                .map(String.init)
            
            guard tokens.count > 0 else {
                print("No input provided. Try again.")
                continue
            }
            
            switch tokens[0].lowercased() {
            case "put":
                guard tokens.count >= 3 else {
                    print("Usage: put <filename> <contents>")
                    continue
                }
                let filename = tokens[1]
                let contents = tokens.dropFirst(2).joined(separator: " ")
                return .put(filename, contents)
                
            case "get":
                guard tokens.count == 2 else {
                    print("Usage: get <filename>")
                    continue
                }
                return .get(tokens[1])
                
            default:
                print("Invalid command. Please enter 'put' or 'get'.")
            }
        }
        
        fatalError(errorMessage)
    }
}

//
//  FTPServer.swift
//  SwiftSessionTypes
//
//  Created by Alec Nipp on 4/17/25.
//

import SwiftSessionTypes

final class FTPServer: @unchecked Sendable {
    let fs = FileSystem(initialFiles: [
        File(name: "readme.txt", contents: "This is the readme."),
        File(name: "log.txt",    contents: "Initial logs.")
    ])

    @Sendable public func startFTPInteraction(
      _ endpoint: consuming FTPProtocol.FtpServer,
      using session: Session.Type
    ) async {

        
        let chooseEndpoint = await session.offer(endpoint)
        print("Current file system state")
        fs.dump()

        switch consume chooseEndpoint {
        case .left(let putEndpoint):
            let putCoupling = await session.recv(from: putEndpoint)
            let rawText = putCoupling.getValue()
            let replyEndpoint = putCoupling.getEndpoint()

            let tokens = rawText.split(separator: " ")
            guard tokens.count >= 2 else {
                fatalError("Invalid PUT format")
            }
            let filename = String(tokens[0])
            let contents = tokens.dropFirst().joined(separator: " ")

            _ = fs.put(filename: filename, contents: contents)
            let nextEndpoint = await session.send("ok", on: replyEndpoint)
            print("File system state after PUT:")
            fs.dump()
            session.close(nextEndpoint)

        case .right(let getEndpoint):
            let getCoupling = await session.recv(from: getEndpoint)
            let filename = getCoupling.getValue()
            let replyEndpoint = getCoupling.getEndpoint()

            let result = fs.get(filename: filename) ?? "File not found"
            let nextEndpoint = await session.send(result, on: replyEndpoint)
            session.close(nextEndpoint)
        }
    }
}

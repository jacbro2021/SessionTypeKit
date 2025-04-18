//
//  FTPProtocol.swift
//  SwiftSessionTypes
//
//  Created by AlecNipp on 4/17/25.
//

import SwiftSessionTypes

enum FTPProtocol {
    typealias FtpPut = Recv<String, Send<String, Close>>
    typealias FtpGet = Recv<String, Send<String, Close>>
    typealias FtpServer = Offer<
        FtpPut,
        FtpGet>
}

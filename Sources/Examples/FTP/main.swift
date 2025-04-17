//
//  File.swift
//  SessionTypeKit
//
//  Created by AlecNipp on 4/17/25.
//

import SessionTypeKit

await Session.create(FTPServer().startFTPInteraction, FTPClient().startFTPInteraction)

//
//  main.swift
//  SwiftSessionTypes
//
//  Created by Alec Nipp on 4/17/25.
//

import SwiftSessionTypes

await Session.create(FTPServer().startFTPInteraction, FTPClient().startFTPInteraction)

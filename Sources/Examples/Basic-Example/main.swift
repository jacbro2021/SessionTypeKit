//
//  main.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SessionTypeKit

await Session.create(BaseExampleSender().start, BaseExampleReceiver().start)

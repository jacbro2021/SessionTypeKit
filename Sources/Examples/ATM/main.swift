//
//  atm.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SessionTypeKit

await Session.create(ATMInterface().startATMInteraction, ATMController().startATMInteraction)

//
//  atm.swift
//  SessionTypeKit
//
//  Created by jacob brown on 4/3/25.
//

import SwiftSessionTypes

await Session.create(ATMController().startATMInteraction, ATMInterface().startATMInteraction)

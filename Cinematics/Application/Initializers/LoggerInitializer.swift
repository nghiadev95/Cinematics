//
//  LoggerInitializer.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/10/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation
import SwiftyBeaver

let log = SwiftyBeaver.self

class LoggerInitializer: Initializable {
    func performInitialization() {
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss $d $X $L $M"
        log.addDestination(console)
    }
}

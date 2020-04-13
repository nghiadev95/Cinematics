//
//  CrashReporterInitializer.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

protocol ErrorReportable {
    func report(error: Error)
}

class CrashReporterInitializer: Initializable {
    func performInitialization() {}
    
    func reportError(error: Error) {
        
    }
}

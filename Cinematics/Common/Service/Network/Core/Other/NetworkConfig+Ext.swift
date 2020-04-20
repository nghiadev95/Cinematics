//
//  NetworkConfig+Ext.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/14/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

extension NetworkConfig {
    static func `default`() -> NetworkConfig {
        let decoder = JSONDecoder()
        let errorReporter: ErrorReportable? = nil
        let adapters: [RequestAdapter]? = []
        let retriers: [RequestRetrier]? = nil
        let eventMotinors: [EventMonitor]? = [NetworkLogger(level: .info)]
        return NetworkConfig(decoder: decoder, errorReporter: errorReporter, adapters: adapters, retriers: retriers, monitors: eventMotinors)
    }
}

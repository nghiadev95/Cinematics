//
//  NetworkConfig+Ext.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/14/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

extension NetworkConfig {
    static func defaultInstance() -> NetworkConfig {
        let decoder = JSONDecoder()
        let errorReporter: ErrorReportable? = nil
        let adapters: [RequestAdapter]? = [AuthenticationAdapter(auth: .bearer(token: Constants.API.TheMoviedbKey))]
        let retriers: [RequestRetrier]? = nil
        let eventMotinors: [EventMonitor]? = [NetworkLogger(level: .verbose)]
        return NetworkConfig(decoder: decoder, errorReporter: errorReporter, adapters: adapters, retriers: retriers, monitors: eventMotinors)
    }
}

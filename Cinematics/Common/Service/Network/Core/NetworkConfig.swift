//
//  NetworkConfig.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/14/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkConfig {
    var decoder: JSONDecoder = JSONDecoder()
    var errorReporter: ErrorReportable?
    var adapters: [RequestAdapter]?
    var retriers: [RequestRetrier]?
    var monitors: [EventMonitor]?

    var interceptor: Interceptor? {
        guard adapters != nil || retriers != nil else { return nil }
        return Interceptor(adapters: adapters ?? [], retriers: retriers ?? [])
    }

    var eventMonitors: [EventMonitor] {
        guard monitors != nil else { return [] }
        return monitors!
    }
}

//
//  Environment.swift
//  Moviek
//
//  Created by Nghia Nguyen on 3/1/19.
//  Copyright © 2019 Nghia Nguyen. All rights reserved.
//

import Foundation

enum Environment: String {
    case debug
    case staging
    case production
    
    var baseURL: String {
        switch self {
        case .debug:      return "http://pipster-dev-02-1765356151.ap-southeast-1.elb.amazonaws.com/"
        case .staging:    return ""
        case .production: return "https://api.pipsapi.com/"
        }
    }
}

extension Environment {
    static func resolve() -> Environment {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "ConfigurationMode") as? String {
            if configuration == "debug" {
                return Environment.debug
            } else if configuration == "staging" {
                return Environment.staging
            }
        }
        return Environment.production
    }
}

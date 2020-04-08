//
//  DemoEndpoint.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

enum DemoEndpoint {
    case getPlain
    case getJSON
    case post
}

extension DemoEndpoint: APIConfiguration {
    var baseURL: URL {
        return Constants.API.BaseURL
    }

    var path: String {
        switch self {
        case .getPlain:
            return "get"
        case .getJSON:
            return "json"
        case .post:
            return "post"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPlain, .getJSON:
            return .get
        case .post:
            return .post
        }
    }
    
    func createTask(request: URLRequest) throws -> URLRequest {
        var request = request
        switch self {
        case .getPlain:
            break
        case .getJSON:
            request = try defaultURLEncodedFormParameterEncoder().encode(["key": "value"], into: request)
        case .post:
            request = try defaultJSONParameterEncoder().encode(["key": "value"], into: request)
        }
        return request
    }
}

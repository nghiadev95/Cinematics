//
//  MoviesEndpoint.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

enum MoviesEndpoint {
    case trending
}

extension MoviesEndpoint: APIConfiguration {
    var baseURL: URL {
        return Constants.API.BaseURL
    }

    var path: String {
        switch self {
        case .trending:
            return "trending/movie/week"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .trending:
            return .get
        }
    }
    
    func createTask(request: URLRequest) throws -> URLRequest {
        var request = request
        switch self {
        case .trending:
            break
        }
        return request
    }
}

//
//  MoviesTarget.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

enum MoviesTarget {
    case trending
}

extension MoviesTarget: TargetType {
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
    
    var task: Task {
        switch self {
        case .trending:
            return .requestPlain
        }
    }
}

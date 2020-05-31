//
//  MoviesTarget.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation
import TEQNetwork

enum MoviesTarget {
    case trending
}

extension MoviesTarget: TargetType {
    var baseURL: URL {
        switch self {
        default:
            return Constants.API.TheMovieDB.baseURL
        }
    }

    var path: String {
        switch self {
        case .trending:
            return "trending/movie/week"
        }
    }

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
}

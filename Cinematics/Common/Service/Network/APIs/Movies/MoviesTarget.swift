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
    case download
}

extension MoviesTarget: TargetType {
    var baseURL: URL {
        switch self {
        case .download:
            return URL(string: "https://upload.wikimedia.org")!
        default:
            return Constants.API.BaseURL
        }
    }

    var path: String {
        switch self {
        case .trending:
            return "trending/movie/week"
        case .download:
            return "wikipedia/commons/f/ff/Pizigani_1367_Chart_10MB.jpg"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .trending:
            return .get
        case .download:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .trending:
            return .requestPlain
        case .download:
            return .downloadDestination
        }
    }
}

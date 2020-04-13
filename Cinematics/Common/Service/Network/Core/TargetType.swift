//
//  TargetType.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

public typealias HTTPMethod = Alamofire.HTTPMethod

protocol TargetType {
    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: HTTPMethod { get }

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    /// The type of HTTP task to be performed.
    var task: Task { get }
}

extension TargetType {
    var validationType: ValidationType {
        return .none
    }

    var headers: [String: String]? {
        return nil
    }
}

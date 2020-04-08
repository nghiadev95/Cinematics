//
//  APIConfiguration.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

protocol APIConfiguration: URLRequestConvertible {
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
    
    func createTask(request: URLRequest) throws -> URLRequest
}

extension APIConfiguration {
    var validationType: ValidationType {
        return .none
    }

    var headers: [String: String]? {
        return nil
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request = try createTask(request: request)
        return request
    }
    
    func defaultURLEncodedFormParameterEncoder() -> URLEncodedFormParameterEncoder {
        return URLEncodedFormParameterEncoder.default
    }
    
    func defaultJSONParameterEncoder() -> JSONParameterEncoder {
        return JSONParameterEncoder.default
    }
}

//
//  Endpoint.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/13/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

class Endpoint: URLRequestConvertible {
    
    /// A string representation of the URL for the request.
    public let targetType: TargetType

    var url: URL {
        return targetType.baseURL.appendingPathComponent(targetType.path)
    }
    
    public init(targetType: TargetType) {
        self.targetType = targetType
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.method = targetType.method
        request.allHTTPHeaderFields = targetType.headers?.dictionary

        switch targetType.task {
        case .requestPlain, .uploadMultipart, .downloadDestination:
            return request
        case let .requestJSONEncodable(encodable):
            return try request.encoded(encodable: encodable)
        case let .requestCustomJSONEncodable(encodable, encoder: encoder):
            return try request.encoded(encodable: encodable, encoder: encoder)
        case let .requestParameters(parameters, parameterEncoding):
            return try request.encoded(parameters: parameters, parameterEncoding: parameterEncoding)
        case let .uploadCompositeMultipart(_, urlParameters):
            let parameterEncoding = URLEncoding(destination: .queryString)
            return try request.encoded(parameters: urlParameters, parameterEncoding: parameterEncoding)
        case let .downloadParameters(parameters, parameterEncoding, _):
            return try request.encoded(parameters: parameters, parameterEncoding: parameterEncoding)
        case let .requestCompositeParameters(bodyParameters: bodyParameters, bodyEncoding: bodyParameterEncoding, urlParameters: urlParameters):
            if let bodyParameterEncoding = bodyParameterEncoding as? URLEncoding, bodyParameterEncoding.destination != .httpBody {
                fatalError("Only URLEncoding that `bodyEncoding` accepts is URLEncoding.httpBody. Others like `default`, `queryString` or `methodDependent` are prohibited - if you want to use them, add your parameters to `urlParameters` instead.")
            }
            let bodyfulRequest = try request.encoded(parameters: bodyParameters, parameterEncoding: bodyParameterEncoding)
            let urlEncoding = URLEncoding(destination: .queryString)
            return try bodyfulRequest.encoded(parameters: urlParameters, parameterEncoding: urlEncoding)
        }
    }
}

/// Required for using `Endpoint` as a key type in a `Dictionary`.
extension Endpoint: Equatable, Hashable {
    public func hash(into hasher: inout Hasher) {
        guard let request = urlRequest else {
            hasher.combine(url)
            return
        }
        hasher.combine(request)
    }

    /// Note: If both Endpoints fail to produce a URLRequest the comparison will
    /// fall back to comparing each Endpoint's hashValue.
    public static func == (lhs: Endpoint, rhs: Endpoint) -> Bool {
        let lhsRequest = lhs.urlRequest
        let rhsRequest = rhs.urlRequest
        if lhsRequest != nil, rhsRequest == nil { return false }
        if lhsRequest == nil, rhsRequest != nil { return false }
        if lhsRequest == nil, rhsRequest == nil { return lhs.hashValue == rhs.hashValue }
        return (lhsRequest == rhsRequest)
    }
}

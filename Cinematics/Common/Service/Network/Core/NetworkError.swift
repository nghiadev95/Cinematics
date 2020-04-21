//
//  NetworkError.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/13/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

/// A type representing possible errors Moya can throw.
public enum NetworkError: Swift.Error {
    case `default`

    /// Indicates a response failed to map to a Decodable object.
    case objectMapping(Swift.Error, Response?)

    /// Indicates that Encodable couldn't be encoded into Data
    case encodableMapping(Swift.Error)

    /// Indicates a response failed due to an underlying `Error`.
    case underlying(Swift.Error, Response?)

    /// Indicates that an `Endpoint` failed to encode the parameters for the `URLRequest`.
    case parameterEncoding(Swift.Error)
}

public extension NetworkError {
    /// Depending on error type, returns a `Response` object.
    var response: Response? {
        switch self {
        case .default: return nil
        case .objectMapping(_, let response): return response
        case .encodableMapping: return nil
        case .underlying(_, let response): return response
        case .parameterEncoding: return nil
        }
    }

    /// Depending on error type, returns an underlying `Error`.
    internal var underlyingError: Swift.Error? {
        switch self {
        case .default: return nil
        case .objectMapping(let error, _): return error
        case .encodableMapping(let error): return error
        case .underlying(let error, _): return error
        case .parameterEncoding(let error): return error
        }
    }
}

// MARK: - Error Descriptions

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .default:
            return "Something went wrong"
        case .objectMapping:
            return "Failed to map data to a Decodable object."
        case .encodableMapping:
            return "Failed to encode Encodable object into data."
        case .underlying(let error, _):
            return error.localizedDescription
        case .parameterEncoding(let error):
            return "Failed to encode parameters for URLRequest. \(error.localizedDescription)"
        }
    }
}

// MARK: - Error User Info

extension NetworkError: CustomNSError {
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        userInfo[NSUnderlyingErrorKey] = underlyingError
        return userInfo
    }
}

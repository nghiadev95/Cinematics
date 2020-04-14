//
//  Helper.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/14/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

public typealias Session = Alamofire.Session
public typealias HTTPMethod = Alamofire.HTTPMethod

public typealias DataRequest = Alamofire.DataRequest
public typealias DataResponse = Alamofire.DataResponse
public typealias AFError = Alamofire.AFError

public typealias AdaptHandler = Alamofire.AdaptHandler
public typealias Adapter = Alamofire.Adapter
public typealias RetryHandler = Alamofire.RetryHandler
public typealias Retrier = Alamofire.Retrier
public typealias RequestAdapter = Alamofire.RequestAdapter
public typealias RequestRetrier = Alamofire.RequestRetrier
public typealias RetryResult = Alamofire.RetryResult

public typealias ClosureEventMonitor = Alamofire.ClosureEventMonitor
public typealias EventMonitor = Alamofire.EventMonitor

struct AnyEncodable: Encodable {
    private let encodable: Encodable

    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

internal extension URLRequest {
    mutating func encoded(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        do {
            let encodable = AnyEncodable(encodable)
            httpBody = try encoder.encode(encodable)

            let contentTypeHeaderName = "Content-Type"
            if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
            }

            return self
        } catch {
            throw NetworkError.encodableMapping(error)
        }
    }

    func encoded(parameters: [String: Any], parameterEncoding: ParameterEncoding) throws -> URLRequest {
        do {
            return try parameterEncoding.encode(self, with: parameters)
        } catch {
            throw NetworkError.parameterEncoding(error)
        }
    }
}

extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }
        return prettyPrintedString
    }
}

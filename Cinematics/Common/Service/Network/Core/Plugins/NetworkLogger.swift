//
//  NetworkLogger.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/14/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

final class NetworkLogger: EventMonitor {
    public enum Level {
        case verbose
        case debug
        case info
    }

    let level: Level
    let queue = DispatchQueue(label: "me.network.eventmonitor.logger", qos: .utility, attributes: .concurrent)

    init(level: Level = .info) {
        self.level = level
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        var message: String = ""
        if let urlRequest = request.request, let urlResponse = request.response {
            message.append("------------- \(String(describing: request)) -------------")
            switch level {
            case .info:
                break
            case .debug, .verbose:
                message.append("\n---- Request Info ----")
                if let allHTTPHeaderFields = urlRequest.allHTTPHeaderFields {
                    message.append("\n- Header Fields:\n\(String(describing: allHTTPHeaderFields))")
                }
                if let httpBodyData = urlRequest.httpBody {
                    var bodyString: String = ""
                    if let jsonString = httpBodyData.prettyPrintedJSONString {
                        bodyString = jsonString
                    } else if let formString = String(data: httpBodyData, encoding: .utf8) {
                        bodyString = formString
                    }
                    message.append("\n- HTTP Body:\n\(bodyString)")
                }

                message.append("\n---- Response Info ----")
                message.append("\n- Header Fields:\n\(String(describing: urlResponse.headers))")
                message.append("\n- Status Code: \(urlResponse.statusCode)")
                if let responseData = response.data, let jsonString = responseData.prettyPrintedJSONString {
                    message.append("\n- Response JSON Data:\n\(jsonString)")
                }
                message.append("\n-----------------------------------------------------------------")
            }
        }
        queue.async {
            print(message)
        }
    }
}

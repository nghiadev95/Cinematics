//
//  NetworkLogger.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/14/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

final class NetworkLogger: EventMonitor {
    public enum Level: String {
        case verbose
        case debug
        case info
    }

    let level: Level
    let queue = DispatchQueue(label: "me.network.eventmonitor.logger", qos: .utility, attributes: .concurrent)

    init(level: Level = .info) {
        self.level = level
    }

    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        var message: String = ""

        let requestDescription = response.request.map { "\($0.httpMethod!) \($0)" } ?? "nil"
        let requestBody = response.request?.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "None"
        let responseDescription = response.response.map { response in
            let sortedHeaders = response.headers.sorted()
            var result = """
            [Status Code]: \(response.statusCode)
            """
            if level != .info {
                result += "\n[Headers]:\n\(sortedHeaders)"
            }
            return result
        } ?? "nil"
        let responseBody = response.data.map { getPrettyPrintedJSON(data: $0) } ?? "None"
        let metricsDescription = response.metrics.map { "\($0.taskInterval.duration)s" } ?? "None"

        let logLevelString = "[NetworkLogger] - [Level: \(level.rawValue.capitalized)]"
        let requestString = "[Request]: \(requestDescription)"
        let requestBodyString = "[Request Body]: \n\(requestBody)"
        let responseString = "[Response]: \n\(responseDescription)"
        let responseBodyString = "[Response Body]: \n\(responseBody)"
        let dataString = "[Data]: \(response.data?.description ?? "None")"
        let networkDurationString = "[Network Duration]: \(metricsDescription)"
        let serializationDurationString = "[Serialization Duration]: \(response.serializationDuration)s"
        let resultString = "[Result]: \(response.result)"
        
        switch level {
            case .info:
                message = [logLevelString, requestString, responseString].joined(separator: "\n")
            case .debug:
                message = [logLevelString, requestString, requestBodyString, responseString, responseBodyString].joined(separator: "\n")
            case .verbose:
                message = [logLevelString, requestString, requestBodyString, responseString, responseBodyString, dataString, networkDurationString, serializationDurationString, resultString].joined(separator: "\n")
        }
        queue.async {
            print(message)
        }
    }

    private func getPrettyPrintedJSON(data: Data) -> String {
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = String(data: data, encoding: .utf8) else { return "None" }
        return prettyPrintedString
    }
}

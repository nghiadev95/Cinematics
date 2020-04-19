//
//  Response.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/13/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation
import UIKit

public final class Response: CustomDebugStringConvertible, Equatable {
    /// The status code of the response.
    public let statusCode: Int?

    /// The response data.
    public let data: Data?

    /// The file downloaded URL
    public let fileURL: URL?

    /// The original URLRequest for the response.
    public let request: URLRequest?

    /// The HTTPURLResponse object.
    public let response: HTTPURLResponse?

    public init(_ response: AFDataResponse<Data?>) {
        self.statusCode = response.response?.statusCode
        self.data = response.data
        self.fileURL = nil
        self.request = response.request
        self.response = response.response
    }

    public init(_ response: AFDownloadResponse<URL?>) {
        self.statusCode = response.response?.statusCode
        self.data = nil
        self.fileURL = response.fileURL
        self.request = response.request
        self.response = response.response
    }

    /// A text description of the `Response`.
    public var description: String {
        return "Status Code: \(String(describing: statusCode)), Data Length: \(String(describing: data?.count))"
    }

    /// A text description of the `Response`. Suitable for debugging.
    public var debugDescription: String {
        return description
    }

    public static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.statusCode == rhs.statusCode
            && lhs.data == rhs.data
            && lhs.response == rhs.response
    }
}

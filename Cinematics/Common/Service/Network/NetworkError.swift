//
//  NetworkError.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/10/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

struct NetworkError: Error {
    var code: String?
    var message: String?
    var underlyingError: Error?
    
    init(code: String, message: String) {
        self.code = code
        self.message = message
    }
    
    init(error: Error) {
        self.underlyingError = error
    }
    
    init(error: ErrorType) {
        code = error.code
        message = error.message
    }
    
    static func defaultInstance() -> NetworkError {
        return NetworkError(error: .default)
    }
}

enum ErrorType {
    case `default`
    
    var code: String {
        switch self {
        default:
            return "-99"
        }
    }
    
    var message: String {
        switch self {
        default:
            return "Oops! Something went wrong!"
        }
    }
}

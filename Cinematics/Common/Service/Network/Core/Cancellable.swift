//
//  Cancellable.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/16/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

protocol Cancellable {
    func cancel()
}

class RequestCancellable: Cancellable {
    let requestID: String
    let operationID: String
    let operation: Operation?

    init(requestID: String, operationID: String, operation: Operation?) {
        self.requestID = requestID
        self.operationID = operationID
        self.operation = operation
    }

    func cancel() {
        if let operation = operation, !operation.isCancelled {
            operation.cancel()
        }
        RequestManager.instance.removeRequest(requestID: requestID, operationID: operationID)
    }
}

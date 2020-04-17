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

    init(requestID: String, operationID: String) {
        self.requestID = requestID
        self.operationID = operationID
    }

    func cancel() {
        RequestManager.instance.removeRequest(requestID: requestID, operationID: operationID)
    }
}

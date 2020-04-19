//
//  RequestOperation.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/19/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

class RequestOperation: AsynchronousOperation {
    let operationID: String

    init(operationID: String) {
        self.operationID = operationID
    }

    deinit {
        log.debug("\(self.className) - operationID: \(operationID) - deinit got called")
    }
}

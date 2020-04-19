//
//  RequestCancellable.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/19/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

class RequestCancellable: Cancellable {
    let requestID: String
    let operationID: String

    init(requestID: String, operationID: String) {
        self.requestID = requestID
        self.operationID = operationID
    }

    func cancel() {
        RequestManager.instance.remove(requestID: requestID, operationID: operationID)
    }
}

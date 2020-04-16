//
//  RequestManager.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/16/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

class RequestManager: NetworkManager {
    private override init() {}

    static let instance = RequestManager()

    var responseHandlerList: [String: [DataResponseHandler]] = [:]

    open override func addRequest(cancellable: Cancellable, responseHandler: @escaping DataResponseHandler) {
        let id = cancellable.requestId
        if let handlers = responseHandlerList[id], !handlers.isEmpty {
            responseHandlerList[id]?.append(responseHandler)
        } else {
            responseHandlerList[id] = [responseHandler]
            let operation = NetworkOperation(cancelable: cancellable)
            operation.completionHandler = { [weak self] completedRequestId, response in
                self?.responseHandlerList[completedRequestId]?.forEach { handler in
                    handler(response)
                }
                self?.responseHandlerList.removeValue(forKey: completedRequestId)
                self?.operationList.removeValue(forKey: completedRequestId)
            }
            operationQueue.addOperation(operation)
            operationList[id] = operation
        }
    }

    override func cancelAllRequest() {
        super.cancelAllRequest()
        responseHandlerList.removeAll()
    }
}

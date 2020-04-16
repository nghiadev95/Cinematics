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

    open func addRequest(requestId: String, request: DataRequest, responseHandler: @escaping DataResponseHandler) -> Cancellable {
        if let handlers = responseHandlerList[requestId], !handlers.isEmpty {
            responseHandlerList[requestId]?.append(responseHandler)
        } else {
            responseHandlerList[requestId] = [responseHandler]
            let operation = RequestOperation(requestId: requestId, request: request)
            operation.completionHandler = { [weak self] completedRequestId, response in
                self?.responseHandlerList[completedRequestId]?.forEach { handler in
                    handler(response)
                }
                self?.responseHandlerList.removeValue(forKey: completedRequestId)
                self?.operationList.removeValue(forKey: completedRequestId)
            }
            operationQueue.addOperation(operation)
            operationList[requestId] = operation
        }
        return Cancellable(requestId: requestId, request: request)
    }

    override func cancelAllRequest() {
        super.cancelAllRequest()
        responseHandlerList.removeAll()
    }
    
    override func removeRequest(id: String) {
        super.removeRequest(id: id)
        responseHandlerList.removeValue(forKey: id)
    }
}

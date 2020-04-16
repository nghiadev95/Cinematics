//
//  RequestManager.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/16/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

class RequestManager: BaseOperationManager {
    private override init() {}

    static let instance = RequestManager()

    var responseHandlerList: [String: [DataResponseHandler]] = [:]

    open func addRequest(requestId: String, request: DataRequest, responseHandler: @escaping DataResponseHandler) -> Cancellable {
        var operation: ConcurrentOperation?
        if let handlers = responseHandlerList[requestId], !handlers.isEmpty {
            responseHandlerList[requestId]?.append(responseHandler)
        } else {
            responseHandlerList[requestId] = [responseHandler]
            let requestOperation = RequestOperation(requestId: requestId, request: request)
            requestOperation.completionHandler = { [weak self] completedRequestId, response in
                self?.responseHandlerList[completedRequestId]?.forEach { handler in
                    handler(response)
                }
                self?.responseHandlerList.removeValue(forKey: completedRequestId)
                self?.operationList.removeValue(forKey: completedRequestId)
            }
            operationQueue.addOperation(requestOperation)
            operationList[requestId] = requestOperation
            operation = requestOperation
        }
        return Cancellable(operation: operation)
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

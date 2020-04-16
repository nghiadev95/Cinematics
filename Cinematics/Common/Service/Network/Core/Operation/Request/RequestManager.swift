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

    var operationRequestMapping: [String: [String]] = [:]                // [OperationID: RequestID]
    var requestCallbackMapping: [String: DataResponseHandler] = [:]      // [RequestID: Callback]

    open func addOperation(operationID: String, request: DataRequest, responseHandler: @escaping DataResponseHandler) -> Cancellable {
        let newRequestID = UUID().uuidString
        var operation: ConcurrentOperation?
        if let requestIDs = operationRequestMapping[operationID], !requestIDs.isEmpty {
            operationRequestMapping[operationID]?.append(newRequestID)
            requestCallbackMapping[newRequestID] = responseHandler
        } else {
            operationRequestMapping[operationID] = [newRequestID]
            let requestOperation = RequestOperation(operationID: operationID, request: request)
            requestOperation.completionHandler = { [weak self] completedOperationID, response in
                self?.operationRequestMapping[completedOperationID]?.forEach({ (requestId) in
                    self?.requestCallbackMapping[requestId]?(response)
                })
                self?.removeOperation(id: completedOperationID)
            }
            operationQueue.addOperation(requestOperation)
            operationList[operationID] = requestOperation
            operation = requestOperation
        }
        return RequestCancellable(requestID: newRequestID, operationID: operationID, operation: operation)
    }

    override func cancelAllRequest() {
        super.cancelAllRequest()
        operationRequestMapping.removeAll()
        requestCallbackMapping.removeAll()
    }
    
    func removeRequest(requestID: String, operationID: String) {
        var requests = operationRequestMapping[operationID]
        requests?.removeAll(where: { (id) -> Bool in
            return id == requestID
        })
        if requests?.isEmpty ?? false {
            operationRequestMapping.removeValue(forKey: operationID)
            operationList.removeValue(forKey: operationID)
        } else {
            operationRequestMapping[operationID] = requests
        }
        requestCallbackMapping.removeValue(forKey: requestID)
    }
    
    func removeOperation(id: String) {
        operationList.removeValue(forKey: id)
        let requestIDs = operationRequestMapping[id]
        operationRequestMapping.removeValue(forKey: id)
        requestIDs?.forEach({ (requestID) in
            requestCallbackMapping.removeValue(forKey: requestID)
        })
    }
}

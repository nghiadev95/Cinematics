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

    var operationRequestMapping: [String: [String]] = [:]                // [OperationID: RequestIDs]
    var requestCallbackMapping: [String: DataResponseHandler] = [:]      // [RequestID: Callbacks]

    open func addOperation(operationID: String, request: DataRequest, responseHandler: @escaping DataResponseHandler) -> Cancellable {
        // Create UUID for each request
        let newRequestID = UUID().uuidString
        if let requestIDs = operationRequestMapping[operationID], !requestIDs.isEmpty {
            // If exist RequestIDs mapping with OperationID
            // 1. append newRequestID into operationRequestMapping
            operationRequestMapping[operationID]?.append(newRequestID)
            // 2. save callback to requestCallbackMapping
            requestCallbackMapping[newRequestID] = responseHandler
        } else {
            // If OperationID don't have any RequestIDs
            // 1. Create mapping between OperationID and RequestID
            operationRequestMapping[operationID] = [newRequestID]
            // 2. Create RequestOperation
            let requestOperation = RequestOperation(operationID: operationID, request: request)
            // 3. When Operation completed
            //      - Execute all callbacks
            //      - Remove completed RequestOperation
            requestOperation.completionHandler = { [weak self] completedOperationID, response in
                self?.operationRequestMapping[completedOperationID]?.forEach({ (requestId) in
                    self?.requestCallbackMapping[requestId]?(response)
                })
                self?.removeCompletedOperation(id: completedOperationID)
            }
            // 4. Add RequestOperation into operationQueue
            operationQueue.addOperation(requestOperation)
            // 5. Save RequestOperation into operationList, using for cancel
            operationList[operationID] = requestOperation
        }
        return RequestCancellable(requestID: newRequestID, operationID: operationID)
    }

    override func cancelAllRequest() {
        super.cancelAllRequest()
        operationRequestMapping.removeAll()
        requestCallbackMapping.removeAll()
    }
    
    func removeRequest(requestID: String, operationID: String) {
        // Remove RequestID
        var requests = operationRequestMapping[operationID]
        requests?.removeAll(where: { (id) -> Bool in
            return id == requestID
        })
        if requests?.isEmpty ?? false {
            // If no request mapping with OperationID, remove OperationID and operation
            operationRequestMapping.removeValue(forKey: operationID)
            let operation = operationList.removeValue(forKey: operationID)
            // Cancel unuse operation
            operation?.cancel()
        } else {
            // Assign remaining RequestID
            operationRequestMapping[operationID] = requests
        }
        // Remove all callback mapping with RequestID
        requestCallbackMapping.removeValue(forKey: requestID)
    }
    
    private func removeCompletedOperation(id: String) {
        // Remove operation
        operationList.removeValue(forKey: id)
        // remove all RequestIDs mapping with this OperationID
        let requestIDs = operationRequestMapping[id]
        operationRequestMapping.removeValue(forKey: id)
        // Remove all callback mapping with just removed RequestIDs
        requestIDs?.forEach({ (requestID) in
            requestCallbackMapping.removeValue(forKey: requestID)
        })
    }
}

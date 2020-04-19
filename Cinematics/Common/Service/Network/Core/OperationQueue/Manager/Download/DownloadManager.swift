//
//  DownloadManager.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/15/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

class DownloadManager: OperationQueueManager {
    private override init() {}

    static let instance = DownloadManager()

    open func addOperation(request: DownloadRequest, responseHandler: @escaping (AFDownloadResponse<URL?>) -> Void) -> Cancellable {
        // 1. Create UUID for each Operation
        let operationID = UUID().uuidString
        // 2. Create DownloadOperator
        let operation = DownloadRequestOperation(operationID: operationID, request: request)
        // 3. When Operation completed
        //      - Execute callback
        //      - Remove completed Operation
        operation.completionHandler = { [weak self] completedOperationID, response in
            responseHandler(response)
            self?.operationList.removeValue(forKey: completedOperationID)
        }
        // 4. Add Operation into operationQueue
        operationQueue.addOperation(operation)
        // 5. Save Operation into operationList, using for cancel
        operationList[operationID] = operation
        return DownloadCancellable(operationID: operationID)
    }

    func remove(operationID: String) {
        operationList.removeValue(forKey: operationID)?.cancel()
    }
}

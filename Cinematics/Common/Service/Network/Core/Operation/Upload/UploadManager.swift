//
//  UploadManager.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/16/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

class UploadManager: OperationQueueManager {
    private override init() {}

    static let instance = UploadManager()

    open func addOperation(request: UploadRequest, responseHandler: @escaping (AFDataResponse<Data?>) -> Void) -> Cancellable {
        // 1. Create UUID for each Operation
        let operationID = UUID().uuidString
        // 2. Create DownloadOperator
        let operation = UploadOperator(operationID: operationID, request: request)
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

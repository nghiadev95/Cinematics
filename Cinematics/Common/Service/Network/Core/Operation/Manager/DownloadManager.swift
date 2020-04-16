//
//  DownloadManager.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/15/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

class DownloadManager: NetworkManager {
    private override init() {}

    static let instance = DownloadManager()

    override func addRequest(cancellable: Cancellable, responseHandler: @escaping DataResponseHandler) {
//        let operation = NetworkOperation(cancelable: Cancellable(requestId: id, dataRequest: request))
//        operation.completionHandler = { [weak self] completedRequestId, response in
//            responseHandler(response)
//            self?.operationList.removeValue(forKey: completedRequestId)
//        }
//        operationQueue.addOperation(operation)
//        operationList[id] = operation
    }
}

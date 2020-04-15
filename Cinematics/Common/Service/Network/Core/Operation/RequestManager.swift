//
//  RequestManager.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/15/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

typealias DataResponseHandler = (AFDataResponse<Data?>) -> Void

class NetworkManager {
    let operationQueue = OperationQueue()
    var operationList: [Int: NetworkOperation] = [:]
    var responseHandlerList: [Int: [DataResponseHandler]] = [:]
    
    var maxConcurrentRequest: Int = 5 {
        didSet {
            guard maxConcurrentRequest > 0 else { return }
            operationQueue.maxConcurrentOperationCount = maxConcurrentRequest
        }
    }
    
    var qualityOfService: QualityOfService = .background {
        didSet {
            operationQueue.qualityOfService = qualityOfService
        }
    }
    
    var isSuspended: Bool = false {
        didSet {
            operationQueue.isSuspended = isSuspended
        }
    }
    
    func cancelRequest(id: Int) {
        operationList[id]?.cancel()
        operationList.removeValue(forKey: id)
    }
    
    func cancelAllRequest() {
        operationQueue.cancelAllOperations()
        responseHandlerList.removeAll()
        operationList.removeAll()
    }
}

class RequestManager: NetworkManager {
    private override init() {}

    static let instance = RequestManager()

    open func addRequest(id: Int, request: DataRequest, responseHandler: @escaping DataResponseHandler) {
        if let handlers = responseHandlerList[id], !handlers.isEmpty {
            responseHandlerList[id]?.append(responseHandler)
        } else {
            responseHandlerList[id] = [responseHandler]
            let operation = NetworkOperation(requestId: id, dataRequest: request)
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
}

class UploadManager: NetworkManager {
    private override init() {}

    static let instance = UploadManager()

    open func addRequest(id: Int, request: DataRequest, responseHandler: @escaping DataResponseHandler) {
        
    }
}

class DownloadManager: NetworkManager {
    private override init() {}

    static let instance = DownloadManager()

    open func addRequest(id: Int, request: DataRequest, responseHandler: @escaping DataResponseHandler) {
        
    }
}

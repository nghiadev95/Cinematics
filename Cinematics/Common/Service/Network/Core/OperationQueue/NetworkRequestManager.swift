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

class RequestManager {
    private init() {}

    static let instance = RequestManager()
    
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

    private var requestList: [Int: [DataResponseHandler]] = [:]
    private var operationList: [Int: NetworkOperation] = [:]
    private let operationQueue = OperationQueue()

    open func addRequest(id: Int, request: DataRequest, responseHandler: @escaping DataResponseHandler) {
        if let handlers = requestList[id], !handlers.isEmpty {
            requestList[id]?.append(responseHandler)
        } else {
            requestList[id] = [responseHandler]
            let operation = NetworkOperation(requestId: id, dataRequest: request)
            operation.completionHandler = { [weak self] completedRequestId, response in
                self?.requestList[completedRequestId]?.forEach { handler in
                    handler(response)
                }
                self?.requestList.removeValue(forKey: completedRequestId)
                self?.operationList.removeValue(forKey: completedRequestId)
            }
            operationQueue.addOperation(operation)
            operationList[id] = operation
        }
    }

    func cancelRequest(id: Int) {
        operationList[id]?.cancel()
        operationList.removeValue(forKey: id)
    }
}

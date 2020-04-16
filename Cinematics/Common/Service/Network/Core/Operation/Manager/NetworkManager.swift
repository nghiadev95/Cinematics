//
//  NetworkManager.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/16/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

typealias DataResponseHandler = (AFDataResponse<Data?>) -> Void

class NetworkManager {
    let operationQueue = OperationQueue()
    var operationList: [String: NetworkOperation] = [:]

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

    func cancelRequest(id: String) {
        operationList[id]?.cancel()
        operationList.removeValue(forKey: id)
    }
    
    func removeRequest(id: String) {
        operationList.removeValue(forKey: id)
    }

    func cancelAllRequest() {
        operationQueue.cancelAllOperations()
        operationList.removeAll()
    }

    open func addRequest(cancellable: Cancellable, responseHandler: @escaping DataResponseHandler) {
        fatalError("Implement not found!")
    }
}

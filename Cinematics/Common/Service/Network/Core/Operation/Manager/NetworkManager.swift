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
    var operationList: [String: RequestOperation] = [:]

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
        removeRequest(id: id)
    }
    
    func removeRequest(id: String) {
        operationList.removeValue(forKey: id)
    }

    func cancelAllRequest() {
        operationQueue.cancelAllOperations()
        operationList.removeAll()
    }
}

//
//  BaseOperationManager.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/16/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

typealias DataResponseHandler = (AFDataResponse<Data?>) -> Void

class BaseOperationManager {
    let operationQueue = OperationQueue()
    var operationList: [String: ConcurrentOperation] = [:]

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

    func cancelAllRequest() {
        operationQueue.cancelAllOperations()
        operationList.removeAll()
    }
}

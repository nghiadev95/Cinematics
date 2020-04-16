//
//  NetworkRequestOperation.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/15/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation
import Alamofire

class RequestOperation: ConcurrentOperation {
    let operationID: String
    let request: DataRequest

    init(operationID: String, request: DataRequest) {
        self.operationID = operationID
        self.request = request
    }

    deinit {
        log.debug("\(self.className) - operationID: \(operationID) - deinit got called")
    }

    override func main() {
        request.response { [weak self] dataResponse in
            guard let self = self else { return }
            self.completionHandler?(self.operationID, dataResponse)
            self.finish()
        }
    }

    var completionHandler: ((String, AFDataResponse<Data?>) -> Void)?

    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    override func finish() {
        super.finish()
        RequestManager.instance.removeOperation(id: operationID)
    }
}

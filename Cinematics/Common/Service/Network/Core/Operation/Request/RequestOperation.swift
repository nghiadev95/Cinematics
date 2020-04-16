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
    let request: DataRequest
    let requestId: String

    init(requestId: String, request: DataRequest) {
        self.request = request
        self.requestId = requestId
    }

    deinit {
        log.debug("\(self.className) - requestId: \(requestId) - deinit got called")
    }

    override func main() {
        request.response { [weak self] dataResponse in
            guard let self = self else { return }
            self.completionHandler?(self.requestId, dataResponse)
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
        RequestManager.instance.removeRequest(id: requestId)
    }
}

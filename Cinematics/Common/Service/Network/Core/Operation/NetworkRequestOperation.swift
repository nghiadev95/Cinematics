//
//  NetworkRequestOperation.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/15/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation
import Alamofire

class NetworkOperation: ConcurrentOperation {
    let requestId: Int
    let dataRequest: DataRequest

    init(requestId: Int, dataRequest: DataRequest) {
        self.requestId = requestId
        self.dataRequest = dataRequest
    }

    deinit {
        log.debug("\(self.className) - requestId: \(requestId) - deinit got called")
    }

    override func main() {
        dataRequest.response { [weak self] dataResponse in
            guard let self = self else { return }
            self.completionHandler?(self.requestId, dataResponse)
            self.finish()
        }
    }

    var completionHandler: ((Int, AFDataResponse<Data?>) -> Void)?

    override func cancel() {
        if !dataRequest.isCancelled {
            dataRequest.cancel()
        }
        super.cancel()
    }
}

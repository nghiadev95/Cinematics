//
//  DownloadOperator.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/16/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation
import Alamofire

class DownloadOperator: ConcurrentOperation {
    let operationID: String
    let request: DownloadRequest

    init(operationID: String, request: DownloadRequest) {
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

    var completionHandler: ((String, AFDownloadResponse<URL?>) -> Void)?

    override func cancel() {
        request.cancel()
        super.cancel()
    }
}


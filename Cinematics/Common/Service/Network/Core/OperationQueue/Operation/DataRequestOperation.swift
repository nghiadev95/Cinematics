//
//  DataRequestOperation.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/19/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

class DataRequestOperation: RequestOperation {
    var request: DataRequest?

    init(operationID: String, request: DataRequest?) {
        super.init(operationID: operationID)
        self.request = request
    }

    override func main() {
        request?.response { [weak self] dataResponse in
            guard let self = self else { return }
            self.completionHandler?(self.operationID, dataResponse)
            self.finish()
        }
    }

    var completionHandler: ((String, AFDataResponse<Data?>) -> Void)?

    override func cancel() {
        request?.cancel()
        super.cancel()
    }
}

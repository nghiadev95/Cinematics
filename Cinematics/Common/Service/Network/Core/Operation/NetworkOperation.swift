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
    let cancelable: Cancellable

    init(cancelable: Cancellable) {
        self.cancelable = cancelable
    }

    deinit {
        log.debug("\(self.className) - requestId: \(cancelable.requestId) - deinit got called")
    }

    override func main() {
        cancelable.dataRequest.response { [weak self] dataResponse in
            guard let self = self else { return }
            self.completionHandler?(self.cancelable.requestId, dataResponse)
            self.finish()
        }
    }

    var completionHandler: ((String, AFDataResponse<Data?>) -> Void)?

    override func finish() {
        super.finish()
        cancelable.removeFromManager()
    }
    
    override func cancel() {
        cancelable.cancel()
        super.cancel()
    }
}

//
//  DownloadOperator.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/16/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

//import Foundation
//import Alamofire
//
//class DownloadOperator: ConcurrentOperation {
//    let cancelable: Cancellable
//    let downloadRequest: DownloadRequest
//
//    init(requestId: String, request: DownloadRequest) {
//        self.cancelable = Cancellable(requestId: requestId, request: request)
//        self.downloadRequest = request
//    }
//
//    deinit {
//        log.debug("\(self.className) - requestId: \(cancelable.requestId) - deinit got called")
//    }
//
//    override func main() {
//        downloadRequest.response { [weak self] dataResponse in
//            guard let self = self else { return }
//            self.completionHandler?(self.cancelable.requestId, dataResponse)
//            self.finish()
//        }
//    }
//
//    var completionHandler: ((String, AFDownloadResponse<URL?>) -> Void)?
//
//    override func finish() {
//        super.finish()
//        cancelable.removeFromManager()
//    }
//    
//    override func cancel() {
//        cancelable.cancel()
//        super.cancel()
//    }
//}

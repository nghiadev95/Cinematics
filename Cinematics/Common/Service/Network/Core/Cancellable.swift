//
//  Cancellable.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/16/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation
import Alamofire

class Cancellable {
    let requestId: String
    let request: Request
    
    init(requestId: String, request: Request) {
        self.requestId = requestId
        self.request = request
    }
    
    var isCancelled: Bool {
        return request.isCancelled
    }
    
    func cancel() {
        if !isCancelled {
            request.cancel()
        }
        removeFromManager()
    }
    
    func removeFromManager() {
//        switch request {
//        case is DataRequest:
//            
//        case is UploadRequest:
//            UploadManager.instance.removeRequest(id: requestId)
//        case is DownloadRequest:
//            DownloadManager.instance.removeRequest(id: requestId)
//        default:
//            break
//        }
    }
}


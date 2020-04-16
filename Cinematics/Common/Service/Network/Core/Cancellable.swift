//
//  Cancellable.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/16/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation

class Cancellable {
    let operation: Operation?

    init(operation: Operation?) {
        self.operation = operation
    }

    func cancel() {
        if !(operation?.isCancelled ?? false) {
            operation?.cancel()
        }
        switch operation {
        case is RequestOperation:
            RequestManager.instance.removeRequest(id: (operation as! RequestOperation).requestId)
//        case is :
//            UploadManager.instance.removeRequest(id: requestId)
//        case is DownloadRequest:
//            DownloadManager.instance.removeRequest(id: requestId)
        default:
            break
        }
    }
}

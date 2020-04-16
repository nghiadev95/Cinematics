//
//  Cancellable.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/16/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

class Cancellable {
    enum RequestType {
        case json
        case upload
        case download
    }
    
    let requestId: String
    let dataRequest: DataRequest
    let requestType: RequestType
    
    init(requestId: String, dataRequest: DataRequest, requestType: RequestType) {
        self.requestId = requestId
        self.dataRequest = dataRequest
        self.requestType = requestType
    }
    
    var isCancelled: Bool {
        return dataRequest.isCancelled
    }
    
    func cancel() {
        if !isCancelled {
            dataRequest.cancel()
        }
        removeFromManager()
    }
    
    func removeFromManager() {
        switch requestType {
        case .json:
            RequestManager.instance.removeRequest(id: requestId)
        case .upload:
            UploadManager.instance.removeRequest(id: requestId)
        case .download:
            DownloadManager.instance.removeRequest(id: requestId)
        }
    }
}

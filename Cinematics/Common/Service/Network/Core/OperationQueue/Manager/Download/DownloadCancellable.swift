//
//  DownloadCancellable.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/19/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

class DownloadCancellable: Cancellable {
    let operationID: String

    init(operationID: String) {
        self.operationID = operationID
    }
    
    func cancel() {
        DownloadManager.instance.remove(operationID: operationID)
    }
}

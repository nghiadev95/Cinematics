//
//  UploadCancellable.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/19/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

class UploadCancellable: Cancellable {
    let operationID: String

    init(operationID: String) {
        self.operationID = operationID
    }
    
    func cancel() {
        UploadManager.instance.remove(operationID: operationID)
    }
}

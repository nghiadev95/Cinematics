//
//  UploadManager.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/16/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

class UploadManager: NetworkManager {
    private override init() {}

    static let instance = UploadManager()

    open override func addRequest(cancellable: Cancellable, responseHandler: @escaping DataResponseHandler) {}
}

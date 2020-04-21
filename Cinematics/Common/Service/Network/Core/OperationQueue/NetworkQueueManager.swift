//
//  NetworkQueueManager.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/20/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

struct NetworkQueueConfig {
    struct QueueConfig {
        var maxConcurrentCount: Int = 5
        var qualityOfService: QualityOfService = .background
    }
    var request: QueueConfig = QueueConfig()
    var download: QueueConfig = QueueConfig()
    var upload: QueueConfig = QueueConfig()
    
    static let `default` = NetworkQueueConfig()
}

enum NetworkQueueType {
    case request
    case download
    case upload
}

final class NetworkQueueManager {
    
    private init() { }
    
    private static let instance = NetworkQueueManager()
    
    static func global() -> NetworkQueueManager {
        return NetworkQueueManager.instance
    }
    
    private var requestQueueManager: RequestManager {
        return RequestManager.instance
    }
    
    private var downloadQueueManager: DownloadManager {
        return DownloadManager.instance
    }
    
    private var uploadQueueManager: UploadManager {
        return UploadManager.instance
    }
    
    func config(_ config: NetworkQueueConfig) {
        update(with: config.request, on: requestQueueManager)
        update(with: config.download, on: downloadQueueManager)
        update(with: config.upload, on: uploadQueueManager)
    }
    
    private func update(with config: NetworkQueueConfig.QueueConfig, on queue: OperationQueueManager) {
        if config.maxConcurrentCount > 0 {
            queue.maxConcurrentRequest = config.maxConcurrentCount
        } else {
            print("maxConcurrentCount must great than 0. Fallback to default value")
        }
        queue.qualityOfService = config.qualityOfService
    }
    
    func updateQueueState(isSuspended: Bool, queueType: NetworkQueueType) {
        switch queueType {
        case .request:
            requestQueueManager.isSuspended = isSuspended
        case .download:
            downloadQueueManager.isSuspended = isSuspended
        case .upload:
            uploadQueueManager.isSuspended = isSuspended
        }
    }
}

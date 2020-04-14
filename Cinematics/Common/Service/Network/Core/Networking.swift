//
//  Networking.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

class ConcurrentOperation: Operation {
    enum State: String {
        case ready, executing, finished

        fileprivate var keyPath: String {
            return "is\(rawValue.capitalized)"
        }
    }

    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    override var isReady: Bool {
        return super.isReady && state == .ready
    }

    override var isExecuting: Bool {
        return state == .executing
    }

    override var isFinished: Bool {
        return state == .finished
    }

    override var isAsynchronous: Bool {
        return true
    }

    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        if !isExecuting {
            state = .executing
        }
        main()
    }

    func finish() {
        if isExecuting {
            state = .finished
        }
    }

    override func cancel() {
        super.cancel()
        finish()
    }
}

class NetworkRequestOperation: ConcurrentOperation {
    let id: Int
    let request: DataRequest

    init(id: Int, request: DataRequest) {
        self.id = id
        self.request = request
    }

    deinit {
        log.debug("\(self.className) - id: \(id) deinit got called")
    }

    override func main() {
        request.response { [weak self] dataResponse in
            guard let self = self else { return }
            self.completionHandler?(self.id, dataResponse)
            self.finish()
        }
    }

    var completionHandler: OperationCompletionHandler?

    override func cancel() {
        if !request.isCancelled {
            request.cancel()
        }
        super.cancel()
    }
}

typealias OperationCompletionHandler = (Int, AFDataResponse<Data?>) -> Void
typealias DataResponseHandler = (AFDataResponse<Data?>) -> Void

class NetworkRequestManager {
    var requestList: [Int: [DataResponseHandler]] = [:]
    var operations: [Int: NetworkRequestOperation] = [:]
    let operationQueue = OperationQueue()

    open func addRequest(id: Int, request: DataRequest, responseHandler: @escaping DataResponseHandler) {
        if let handlers = self.requestList[id], !handlers.isEmpty {
            self.requestList[id]?.append(responseHandler)
        } else {
            self.requestList[id] = [responseHandler]
            let operation = NetworkRequestOperation(id: id, request: request)
            operation.completionHandler = { [weak self] completedRequestId, response in
                self?.requestList[completedRequestId]?.forEach { handler in
                    handler(response)
                }
                self?.requestList.removeValue(forKey: completedRequestId)
                self?.operations.removeValue(forKey: completedRequestId)
            }
            operationQueue.addOperation(operation)
            operations[id] = operation
        }
    }

    func cancelRequest(id: Int) {
        operations[id]?.cancel()
        operations.removeValue(forKey: id)
    }

    static let instance = NetworkRequestManager()
}

protocol Networking {
    func request<T: TargetType, H: Codable>(targetType: T) -> Observable<H>
}

struct Network: Networking {
    private let errorReporter: ErrorReportable?
    private let section: Session
    private let decoder: JSONDecoder

    init(config: NetworkConfig) {
        self.decoder = config.decoder
        self.errorReporter = config.errorReporter
        self.section = Session(interceptor: config.interceptor, eventMonitors: config.eventMonitors)
    }

    func request<T, H>(targetType: T) -> Observable<H> where T: TargetType, H: Codable {
        return Observable<H>.create { (observer) -> Disposable in
            let endPoint = Endpoint(targetType: targetType)
            let validationStatusCodes = endPoint.targetType.validationType.statusCodes
            let request = self.section.request(endPoint)
                .validate(statusCode: validationStatusCodes)
            let requestid = endPoint.hashValue
            log.debug("endPoint.hashValue \(endPoint.hashValue)")
            var dataResponseHandler: DataResponseHandler
            dataResponseHandler = { response in
                switch response.result {
                case .success(let resultObject):
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(self.errorResolver(targetType: targetType, error: error))
                }
            }
            NetworkRequestManager.instance.addRequest(id: requestid, request: request, responseHandler: dataResponseHandler)
            return Disposables.create {
                NetworkRequestManager.instance.cancelRequest(id: requestid)
            }
        }
    }

    func errorResolver(targetType: TargetType, error: Error) -> NetworkError {
        log.debug(error)
        errorReporter?.report(error: error)
        if let afError = error as? AFError {
            log.debug(afError) // remove
            return NetworkError.default
        } else {
            return NetworkError.default
        }
    }
}

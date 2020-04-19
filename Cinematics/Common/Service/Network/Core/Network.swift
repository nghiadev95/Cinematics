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
import UIKit

struct Network {
    private let errorReporter: ErrorReportable?
    private let session: Session
    private let decoder: JSONDecoder

    init(config: NetworkConfig) {
        self.decoder = config.decoder
        self.errorReporter = config.errorReporter
        self.session = Session(interceptor: config.interceptor, eventMonitors: config.eventMonitors)
    }

    // MARK: Pure Request

    // Data Request
    @discardableResult
    private func request(_ convertible: URLRequestConvertible, statusCodes: [Int], completion: @escaping (Data?, Error?) -> Void) -> Cancellable {
        let operationID = String(convertible.urlRequest.hashValue)
        log.debug("add new Request with operationID: \(operationID)")

        var request: DataRequest = session.request(convertible)
        if !statusCodes.isEmpty {
            request = request.validate(statusCode: statusCodes)
        }

        return RequestManager.instance.addOperation(operationID: operationID, request: request) { response in
            switch response.result {
            case let .success(data):
                completion(data, nil)
            case let .failure(error):
                self.errorReporter?.report(error: error)
                completion(nil, NetworkError.underlying(error, Response(response)))
            }
        }
    }

    // Data Download
    @discardableResult
    private func download(_ convertible: URLRequestConvertible, progress: @escaping ProgressHandler, destination: Destination, completion: @escaping (URL?, Error?) -> Void) -> Cancellable {
        let request = session.download(convertible).downloadProgress(closure: progress)
        return DownloadManager.instance.addOperation(request: request) { response in
            switch response.result {
            case let .success(fileURL):
                completion(fileURL, nil)
            case let .failure(error):
                self.errorReporter?.report(error: error)
                completion(nil, NetworkError.underlying(error, Response(response)))
            }
        }
    }

    // Data Upload
    @discardableResult
    private func upload(_ convertible: URLRequestConvertible, multipartFormData: MultipartFormData, progress: @escaping Request.ProgressHandler, completion: @escaping (Data?, Error?) -> Void) -> Cancellable {
        let request = session.upload(multipartFormData: multipartFormData, with: convertible).uploadProgress(closure: progress)
        return UploadManager.instance.addOperation(request: request) { response in
            switch response.result {
            case let .success(data):
                completion(data, nil)
            case let .failure(error):
                self.errorReporter?.report(error: error)
                completion(nil, NetworkError.underlying(error, Response(response)))
            }
        }
    }
}

extension Network {
    // MARK: Request with TargetType

    @discardableResult
    func request<T: TargetType>(targetType: T, completion: @escaping (Data?, Error?) -> Void) -> Cancellable {
        let endpoint = Endpoint(targetType: targetType)
        let validationStatusCodes = endpoint.targetType.validationType.statusCodes
        return request(endpoint, statusCodes: validationStatusCodes, completion: completion)
    }

    @discardableResult
    func download<T: TargetType>(targetType: T, progress: @escaping ProgressHandler, destination: Destination, completion: @escaping (URL?, Error?) -> Void) -> Cancellable {
        let endpoint = Endpoint(targetType: targetType)
        return download(endpoint, progress: progress, destination: destination, completion: completion)
    }

    @discardableResult
    func upload<T: TargetType>(targetType: T, multipartFormData: MultipartFormData, progress: @escaping ProgressHandler, completion: @escaping (Data?, Error?) -> Void) -> Cancellable {
        let endpoint = Endpoint(targetType: targetType)
        return upload(endpoint, multipartFormData: multipartFormData, progress: progress, completion: completion)
    }
}

extension Network {
    // MARK: Support Codable

    @discardableResult
    func request<T, H>(targetType: T, atKeyPath keyPath: String? = nil, completion: @escaping (Result<H, Error>) -> Void) -> Cancellable where T: TargetType, H: Decodable {
        let cancellable = request(targetType: targetType) { data, error in
            completion(self.decodeResponse(response: (data, error), atKeyPath: keyPath))
        }
        return cancellable
    }
    
    @discardableResult
    func upload<T, H>(targetType: T, atKeyPath keyPath: String? = nil, multipartFormData: MultipartFormData, progress: @escaping ProgressHandler, completion: @escaping (Result<H, Error>) -> Void) -> Cancellable where T: TargetType, H: Decodable {
        let cancellable = upload(targetType: targetType, multipartFormData: multipartFormData, progress: progress) { data, error in
            completion(self.decodeResponse(response: (data, error), atKeyPath: keyPath))
        }
        return cancellable
    }
}

extension Network {
    // MARK: Support Reactive Programming
    
    func rxRequest<T, H>(targetType: T, atKeyPath keyPath: String? = nil) -> Observable<H> where T: TargetType, H: Decodable {
        return Observable<H>.create { (observer) -> Disposable in
            let cancelable = self.request(targetType: targetType, atKeyPath: keyPath) { (result: Result<H, Error>) in
                switch result {
                case let .success(object):
                    observer.onNext(object)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                cancelable.cancel()
            }
        }
    }
    
    func rxDownload<T>(targetType: T, progress: @escaping ProgressHandler, destination: @escaping Destination) -> Observable<URL> where T: TargetType {
        return Observable<URL>.create { (observer) -> Disposable in
            let cancelable = self.download(targetType: targetType, progress: progress, destination: destination) { (url, error) in
                if let err = error {
                    observer.onError(err)
                } else {
                    observer.onNext(url!)
                    observer.onCompleted()
                }
            }
            return Disposables.create {
                cancelable.cancel()
            }
        }
    }
    
    func rxUpload<T, H>(targetType: T, atKeyPath keyPath: String? = nil, multipartFormData: MultipartFormData, progress: @escaping ProgressHandler) -> Observable<H> where T: TargetType, H: Decodable {
        return Observable<H>.create { (observer) -> Disposable in
            let cancelable = self.upload(targetType: targetType, atKeyPath: keyPath, multipartFormData: multipartFormData, progress: progress) { (result: Result<H, Error>) in
                switch result {
                case let .success(object):
                    observer.onNext(object)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                cancelable.cancel()
            }
        }
    }
}


extension Network {
    // MARK: Helper
    
    private func decodeResponse<H: Decodable>(response: (data: Data?, error: Error?), atKeyPath keyPath: String? = nil) -> Result<H, Error> {
        if let err = response.error {
            return .failure(err)
        } else {
            do {
                let resultObject: H
                if let keyPath = keyPath {
                    resultObject = try self.decoder.decode(H.self, from: response.data!, keyPath: keyPath)
                } else {
                    resultObject = try self.decoder.decode(H.self, from: response.data!)
                }
                return .success(resultObject)
            } catch let mapError {
                return .failure(mapError)
            }
        }
    }
}

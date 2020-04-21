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
    func request(_ convertible: URLRequestConvertible, statusCodes: [Int], completion: @escaping (Data?, Error?) -> Void) -> Cancellable {
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
    func download(_ convertible: URLRequestConvertible, progress: ProgressHandler?, destination: Destination, completion: @escaping (URL?, Error?) -> Void) -> Cancellable {
        var request: DownloadRequest = session.download(convertible)
        if let progress = progress {
            request = request.downloadProgress(closure: progress)
        }

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
    func upload(_ convertible: URLRequestConvertible, multipartFormData: MultipartFormData, progress: ProgressHandler?, completion: @escaping (Data?, Error?) -> Void) -> Cancellable {
        var request = session.upload(multipartFormData: multipartFormData, with: convertible)
        if let progress = progress {
            request = request.uploadProgress(closure: progress)
        }

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
        return sendRequest(targetType: targetType, progress: nil) { data, _, error in
            completion(data, error)
        }
    }

    @discardableResult
    func download<T: TargetType>(targetType: T, progress: ProgressHandler?, completion: @escaping (URL?, Error?) -> Void) -> Cancellable {
        return sendRequest(targetType: targetType, progress: progress) { _, url, error in
            completion(url, error)
        }
    }

    @discardableResult
    func upload<T: TargetType>(targetType: T, progress: ProgressHandler?, completion: @escaping (Data?, Error?) -> Void) -> Cancellable {
        return sendRequest(targetType: targetType, progress: progress) { data, _, error in
            completion(data, error)
        }
    }

    @discardableResult
    private func sendRequest<T: TargetType>(targetType: T, progress: ProgressHandler?, completion: @escaping (Data?, URL?, Error?) -> Void) -> Cancellable {
        switch targetType.task {
        case let .downloadDestination(destination), let .downloadParameters(_, _, destination):
            let endpoint = Endpoint(targetType: targetType)
            return download(endpoint, progress: progress, destination: destination) { url, error in
                completion(nil, url, error)
            }
        case let .uploadMultipart(multipartBody), let .uploadCompositeMultipart(multipartBody, _):
            let endpoint = Endpoint(targetType: targetType)
            return upload(endpoint, multipartFormData: multipartBody, progress: progress) { data, error in
                completion(data, nil, error)
            }
        case .requestPlain, .requestJSONEncodable, .requestCustomJSONEncodable, .requestParameters, .requestCompositeParameters:
            let endpoint = Endpoint(targetType: targetType)
            let validationStatusCodes = endpoint.targetType.validationType.statusCodes
            return request(endpoint, statusCodes: validationStatusCodes) { data, error in
                completion(data, nil, error)
            }
        }
    }
}

extension Network {
    // MARK: Support Codable Response

    @discardableResult
    func request<T, H>(targetType: T, atKeyPath keyPath: String? = nil, completion: @escaping (Result<H, Error>) -> Void) -> Cancellable where T: TargetType, H: Decodable {
        return request(targetType: targetType) { data, error in
            if let err = error {
                completion(.failure(err))
            } else {
                completion(self.decodeResponse(data: data, atKeyPath: keyPath))
            }
        }
    }

    @discardableResult
    func upload<T, H>(targetType: T, atKeyPath keyPath: String? = nil, progress: ProgressHandler?, completion: @escaping (Result<H, Error>) -> Void) -> Cancellable where T: TargetType, H: Decodable {
        return upload(targetType: targetType, progress: progress) { data, error in
            if let err = error {
                completion(.failure(err))
            } else {
                completion(self.decodeResponse(data: data, atKeyPath: keyPath))
            }
        }
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

    func rxDownload<T>(targetType: T, progress: ProgressHandler?) -> Observable<URL> where T: TargetType {
        return Observable<URL>.create { (observer) -> Disposable in
            let cancelable = self.download(targetType: targetType, progress: progress) { url, error in
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

    func rxUpload<T, H>(targetType: T, atKeyPath keyPath: String? = nil, progress: ProgressHandler?) -> Observable<H> where T: TargetType, H: Decodable {
        return Observable<H>.create { (observer) -> Disposable in
            let cancelable = self.upload(targetType: targetType, atKeyPath: keyPath, progress: progress) { (result: Result<H, Error>) in
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

    private func decodeResponse<H: Decodable>(data: Data?, atKeyPath keyPath: String? = nil) -> Result<H, Error> {
        do {
            let resultObject: H
            if let keyPath = keyPath {
                resultObject = try decoder.decode(H.self, from: data ?? Data(), keyPath: keyPath)
            } else {
                resultObject = try decoder.decode(H.self, from: data ?? Data())
            }
            return .success(resultObject)
        } catch {
            return .failure(NetworkError.objectMapping(error, nil))
        }
    }
}

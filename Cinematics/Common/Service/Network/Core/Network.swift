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

protocol Networking {
    func requestCodeable<T: TargetType, H: Codable>(targetType: T, atKeyPath keyPath: String?, completion: @escaping (Result<H, NetworkError>) -> Void) -> Cancellable
    func rxRequest<T: TargetType, H: Codable>(targetType: T) -> Observable<H>
    func rxRequest<T: TargetType, H: Codable>(targetType: T, atKeyPath keyPath: String?) -> Observable<H>
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

    // Request with Codable
    func requestCodeable<T, H>(targetType: T, atKeyPath keyPath: String? = nil, completion: @escaping (Result<H, NetworkError>) -> Void) -> Cancellable where T: TargetType, H: Decodable, H: Encodable {
        let cancellable = request(targetType: targetType, atKeyPath: keyPath) { result in
            switch result {
            case let .success(response):
                do {
                    let resultObject = try response.map(H.self, atKeyPath: keyPath, using: self.decoder)
                    completion(.success(resultObject))
                } catch let mapError {
                    completion(.failure(mapError as! NetworkError))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
        return cancellable
    }

    // Main request function
    @discardableResult
    private func request<T: TargetType>(targetType: T, atKeyPath keyPath: String? = nil, completion: @escaping (Result<Response, NetworkError>) -> Void) -> Cancellable {
        let endpoint = Endpoint(targetType: targetType)
        let requestId = String(endpoint.hashValue)
        log.debug("add new Request with id: \(requestId)")
        let validationStatusCodes = endpoint.targetType.validationType.statusCodes
        let request = section.request(endpoint).validate(statusCode: validationStatusCodes)
        
        return RequestManager.instance.addRequest(requestId: requestId, request: request) { dataResponse in
            let result = self.convertResponseToResult(dataResponse.response, request: dataResponse.request, data: dataResponse.data, error: dataResponse.error)
            switch result {
            case let .success(response):
                completion(.success(response))
            case let .failure(error):
                self.errorReporter?.report(error: error)
                completion(.failure(error))
            }
        }
    }

    func downloadImage(url: URL) {
        
    }
}

extension Network {
    // MARK: RxSwift Implementation

    func rxRequest<T, H>(targetType: T) -> Observable<H> where T: TargetType, H: Decodable, H: Encodable {
        return rxRequest(targetType: targetType, atKeyPath: nil)
    }

    func rxRequest<T, H>(targetType: T, atKeyPath keyPath: String? = nil) -> Observable<H> where T: TargetType, H: Decodable, H: Encodable {
        return Observable<H>.create { (observer) -> Disposable in
            let cancelable = self.requestCodeable(targetType: targetType, atKeyPath: keyPath) { (result: Result<H, NetworkError>) in
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
    private func convertResponseToResult(_ response: HTTPURLResponse?, request: URLRequest?, data: Data?, error: Swift.Error?) -> Result<Response, NetworkError> {
        switch (response, data, error) {
        case let (.some(response), data, .none):
            let response = Response(statusCode: response.statusCode, data: data ?? Data(), request: request, response: response)
            return .success(response)
        case let (.some(response), _, .some(error)):
            let response = Response(statusCode: response.statusCode, data: data ?? Data(), request: request, response: response)
            let error = NetworkError.underlying(error, response)
            errorReporter?.report(error: error)
            return .failure(error)
        case let (_, _, .some(error)):
            let error = NetworkError.underlying(error, nil)
            errorReporter?.report(error: error)
            return .failure(error)
        default:
            let error = NetworkError.underlying(NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil), nil)
            errorReporter?.report(error: error)
            return .failure(error)
        }
    }
}

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

protocol Networking {
    func request<T: TargetType, H: Codable>(targetType: T, atKeyPath keyPath: String?) -> Observable<H>
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

    func request<T, H>(targetType: T, atKeyPath keyPath: String? = nil) -> Observable<H> where T: TargetType, H: Codable {
        return Observable<H>.create { (observer) -> Disposable in
            let endpoint = Endpoint(targetType: targetType)
            let requestId = endpoint.hashValue

            self.request(requestId: requestId, endpoint: endpoint) { result in
                switch result {
                case let .success(response):
                    do {
                        let resultObject = try response.map(H.self, atKeyPath: keyPath, using: self.decoder)
                        observer.onNext(resultObject)
                        observer.onCompleted()
                    } catch let mapError {
                        self.errorReporter?.report(error: mapError)
                        observer.onError(mapError)
                    }
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                RequestManager.instance.cancelRequest(id: requestId)
            }
        }
    }

    private func request(requestId: Int, endpoint: Endpoint, completion: @escaping (Result<Response, NetworkError>) -> Void) {
        log.debug("add new Request with id: \(requestId)")
        let validationStatusCodes = endpoint.targetType.validationType.statusCodes
        let request = section.request(endpoint).validate(statusCode: validationStatusCodes)
        RequestManager.instance.addRequest(id: requestId, request: request) { dataResponse in
            let result = self.convertResponseToResult(dataResponse.response, request: dataResponse.request, data: dataResponse.data, error: dataResponse.error)
            completion(result)
        }
    }

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

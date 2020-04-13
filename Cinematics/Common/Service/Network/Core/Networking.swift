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
    func request<T: TargetType, H: Codable>(targetType: T, model: H.Type) -> Observable<H>
}

struct Network: Networking {
    private let errorReporter: ErrorReportable?
    private var section: Session
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder(), reporter: ErrorReportable? = nil) {
        self.decoder = decoder
        self.errorReporter = reporter
        section = Session(interceptor: Interceptor(adapters: [APIKeyAdapter()], retriers: []))
    }

    func request<T, H>(targetType: T, model: H.Type) -> Observable<H> where T: TargetType, H: Codable {
        return Observable<H>.create { (observer) -> Disposable in
            let endPoint = Endpoint(targetType: targetType)
            let validationStatusCodes = endPoint.targetType.validationType.statusCodes
            let request = self.section.request(endPoint)
                .validate(statusCode: validationStatusCodes)
                .responseDecodable(of: H.self, decoder: self.decoder) { response in
                switch response.result {
                case .success(let resultObject):
                    observer.onNext(resultObject)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(self.errorResolver(targetType: targetType, error: error))
                }
            }
            return Disposables.create {
                if !request.isCancelled {
                    request.cancel()
                }
            }
        }
    }

    func errorResolver(targetType: TargetType, error: Error) -> NetworkError {
        log.debug(error)
        errorReporter?.report(error: error)
        if let afError = error as? AFError {
            log.debug(afError)//remove
            return NetworkError.default
        } else {
            return NetworkError.default
        }
        
    }
}

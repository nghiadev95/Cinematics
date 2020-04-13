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
    var defaultDecoder: JSONDecoder { get }
    func request<H: Codable, T: APIConfiguration>(endpoint: T, model: H.Type) -> Observable<H>
}

struct Network: Networking {
    private let errorReporter: ErrorReportable
    private var section: Session
    
    init(reporter: ErrorReportable) {
        self.errorReporter = reporter
        section = Session(interceptor: Interceptor(adapters: [APIKeyAdapter()], retriers: []))
    }
    
    var defaultDecoder: JSONDecoder {
        return JSONDecoder()
    }

    func request<H, T>(endpoint: T, model: H.Type) -> Observable<H> where H: Codable, T: APIConfiguration {
        return Observable<H>.create { (observer) -> Disposable in
            let request = self.section.request(endpoint).validate(statusCode: endpoint.validationType.statusCodes).responseDecodable(of: H.self, decoder: self.defaultDecoder) { response in
                switch response.result {
                case .success(let resultObject):
                    observer.onNext(resultObject)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(self.errorResolver(endpoint: endpoint, error: error))
                }
            }
            return Disposables.create {
                if !request.isCancelled {
                    request.cancel()
                }
            }
        }
    }

    func errorResolver(endpoint: APIConfiguration, error: Error) -> NetworkError {
        log.debug(error)
        errorReporter.report(error: error)
        if let afError = error as? AFError {
            log.debug(afError)//remove
            return NetworkError.defaultInstance()
        } else {
            return NetworkError.defaultInstance()
        }
        
    }
}

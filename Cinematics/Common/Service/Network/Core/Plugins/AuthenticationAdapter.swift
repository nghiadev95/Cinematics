//
//  Authentication.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/13/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

final class AuthenticationAdapter: RequestAdapter {
    enum Authentication {
        case bearer(token: String)
        case basic(token: String)
        case credential(username: String, password: String)
    }

    let auth: Authentication

    init(auth: Authentication) {
        self.auth = auth
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        switch auth {
        case .basic(let token):
            urlRequest.headers.add(.authorization(token))
        case .bearer(let token):
            urlRequest.headers.add(.authorization(bearerToken: token))
        case .credential(let username, let password):
            urlRequest.headers.add(.authorization(username: username, password: password))
        }
        completion(.success(urlRequest))
    }
}

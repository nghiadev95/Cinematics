//
//  APIErrorResponse.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 5/31/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

struct APIErrorResponse: Codable {
    var code: String?
    var message: String?
}

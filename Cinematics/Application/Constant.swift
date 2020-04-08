//
//  Constant.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit

struct Constants {
    struct API {
        #if DEBUG
        static let BaseURL = URL(string: "https://httpbin.org")!
        #endif
    }
}

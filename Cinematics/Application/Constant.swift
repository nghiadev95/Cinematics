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
        static let BaseURL = URL(string: "https://api.themoviedb.org/3")!
        static let TheMoviedbKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NjJhZWNiZjhmOGQ0YWJjNDQ1MWUwNzIwYzE5ZmY2MiIsInN1YiI6IjVlNGMwOTA2MWU5MjI1MDAxOGM2YmRiZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._mr6wFQ5eprUm38N5eHPz3tPtbo6y-xr2PdfER4LUuE"
        #endif
    }
}

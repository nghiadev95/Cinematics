//
//  MoviesService.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/14/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift

protocol MoviesServicing {
    func getTrendingMovie() -> Observable<TrendingResponse>
}

struct MoviesService: MoviesServicing {
    let network: Networking
    
    init() {
        let config = NetworkConfig.defaultInstance()
        network = Network(config: config)
    }
    
    func getTrendingMovie() -> Observable<TrendingResponse> {
        return network.request(targetType: MoviesTarget.trending)
    }
}

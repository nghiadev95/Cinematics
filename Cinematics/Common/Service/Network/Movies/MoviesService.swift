//
//  MoviesService.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/14/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import TEQNetwork

protocol MoviesServicing {
    func getTrendingMovie() -> Observable<TrendingResponse>
}

struct MoviesService: MoviesServicing {
    let network: TEQNetwork = TEQNetwork(config: NetworkConfig.default())
    
    func getTrendingMovie() -> Observable<TrendingResponse> {
        return network.rxRequest(targetType: MoviesTarget.trending)
    }
}

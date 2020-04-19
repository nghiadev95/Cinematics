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
    func getImage(progress: ProgressHandler?, destination: @escaping Destination) -> Observable<URL>
}

struct MoviesService: MoviesServicing {
    let network: Network
    
    init() {
        network = Network(config: NetworkConfig.defaultInstance())
    }
    
    func getTrendingMovie() -> Observable<TrendingResponse> {
        return network.rxRequest(targetType: MoviesTarget.trending)
    }
    
    func getImage(progress: ProgressHandler?, destination: @escaping Destination) -> Observable<URL> {
        return network.rxDownload(targetType: MoviesTarget.download, progress: progress, destination: destination)
    }
}

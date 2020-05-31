//
//  NetworkInitializer.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 5/31/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import TEQNetwork

class NetworkInitializer: Initializable {
    func performInitialization() {
        TEQNetworkQueueManager.instance.config(.default)
    }
}

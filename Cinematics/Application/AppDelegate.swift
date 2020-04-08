//
//  AppDelegate.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: PluggableApplicationDelegate {
    private let coreDataManager = CoreDataManager()
    
    override var services: [ApplicationService] {
        return [
            BootApplicationManager(),
            coreDataManager
        ]
    }
}

extension AppDelegate {
    public class var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    var coreDataService: CoreDataService {
        return coreDataManager
    }
}

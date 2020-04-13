//
//  BootApplicationService.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Alamofire
import SwiftyBeaver
import UIKit

protocol BootApplicationService: ApplicationService {}

final class BootApplicationManager: NSObject, BootApplicationService {
    var window: UIWindow?
    
    lazy var initializers: [Initializable] = [
        AlamofireInitializer(),
        CrashReporterInitializer(),
        LoggerInitializer()
    ]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // MARK: Initializable
        
        initializers.forEach { $0.performInitialization() }
        
        // MARK: Run app
        
        let initialController = UINavigationController()
        initialController.setRootWireframe(MainTabBarWireframe())

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

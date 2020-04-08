//
//  BootApplicationService.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit
import SwiftyBeaver
let log = SwiftyBeaver.self
import Alamofire

protocol BootApplicationService: ApplicationService {
}

final class BootApplicationManager: NSObject, BootApplicationService {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // MARK: SwiftyBeaver
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss$d $L $M"
        log.addDestination(console)
        
        // MARK: Run app
        
        AF.request(DemoEndpoint.getJSON).response { (data) in
            print(data)
        }
        AF.request(DemoEndpoint.getPlain).response { (data) in
            print(data)
        }
        AF.request(DemoEndpoint.post).response { (data) in
            print(data)
        }
        
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

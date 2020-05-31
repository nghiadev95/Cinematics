//
//  BaseViewController.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/10/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    deinit {
        log.verbose("\(self.className) deinit got called!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let vc = self as? NavigationBarVisible {
            vc.updateNavigationBarVisible()
        }
    }
}

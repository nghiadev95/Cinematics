//
//  NavigationBarVisible.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/10/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit

protocol NavigationBarVisible {
    var isHideNavigationBar: Bool { get set }
    func updateNavigationBarVisible()
}

extension NavigationBarVisible where Self: UIViewController {
    func updateNavigationBarVisible() {
        navigationController?.setNavigationBarHidden(isHideNavigationBar, animated: true)
    }
}

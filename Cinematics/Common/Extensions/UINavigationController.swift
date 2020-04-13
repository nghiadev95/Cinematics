//
//  UINavigationController.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/10/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit

extension UINavigationController {
    func containsViewController(ofKind kind: AnyClass) -> Bool {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
    
    func popToViewController(ofKind kind: AnyClass) {
        if containsViewController(ofKind: kind) {
            for controller in self.viewControllers {
                if controller.isKind(of: kind) {
                    popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    func hideTabBarAndPush(vc: UIViewController) {
        vc.hidesBottomBarWhenPushed = true
        pushViewController(vc, animated: true)
    }
}

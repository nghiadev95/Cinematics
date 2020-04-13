//
//  UIViewController.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/10/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit
import SnapKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.view.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        child.didMove(toParent: self)
    }
    
    func add(_ child: UIViewController, to desView: UIView) {
        addChild(child)
        desView.addSubview(child.view)
        child.view.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

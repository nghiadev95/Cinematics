//
//  UIButton.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/10/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit

extension UIButton {
    func updateState(isEnable: Bool) {
        if isEnable {
            isEnabled = true
            isUserInteractionEnabled = true
        } else {
            isEnabled = false
            isUserInteractionEnabled = false
        }
    }

    func updateState(state: UIControl.State) {
        if state == .normal {
            isEnabled = true
            isUserInteractionEnabled = true
        } else if state == .disabled {
            isEnabled = false
            isUserInteractionEnabled = false
        }
    }
}

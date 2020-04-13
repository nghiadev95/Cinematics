//
//  HasLoadingIndicator.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/10/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit

protocol HasLoadingIndicator {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    var view: UIView! { get }
}

extension HasLoadingIndicator {
    func showLoadingIndicator() {
        view.endEditing(true)
    }

    func hideLoadingIndicator() {}
}

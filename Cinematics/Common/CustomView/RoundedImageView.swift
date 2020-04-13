//
//  RoundedImageView.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/13/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit
import SnapKit

class RoundedImageView: UIImageView {
    @IBInspectable
    var mCornerRadius: CGFloat = 5.0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = mCornerRadius
        layer.masksToBounds = true
    }
}

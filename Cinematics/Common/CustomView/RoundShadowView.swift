//
//  RoundShadowView.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/13/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import QuartzCore
import UIKit
import SnapKit

class RoundShadowView: UIView {
    private var shadowLayer: CAShapeLayer!

    @IBInspectable
    var mCornerRadius: CGFloat = 5.0

    @IBInspectable
    var mShadowColor: UIColor = .blue

    @IBInspectable
    var mShadowOffset: CGSize = CGSize(width: 0.0, height: 2.0)

    @IBInspectable
    var mShadowOpacity: Float = 0.2

    @IBInspectable
    var mBlur: CGFloat = 3

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let roundView = UIView()
        roundView.backgroundColor = backgroundColor
        backgroundColor = .clear
        roundView.layer.cornerRadius = mCornerRadius
        insertSubview(roundView, at: 0)
        roundView.snp.makeConstraints { m in
            m.center.equalToSuperview()
            m.width.height.equalToSuperview()
        }
        layer.applySketchShadow(color: mShadowColor, alpha: mShadowOpacity, x: mShadowOffset.width, y: mShadowOffset.height, blur: mBlur, spread: 0)
    }
}

private extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

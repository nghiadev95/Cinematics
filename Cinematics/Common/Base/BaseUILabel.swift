//
//  BaseUILabel.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/10/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit

class BaseUILabel: UILabel {
    @IBInspectable var mFontSize: CGFloat = 13
    @IBInspectable var mTextColor: UIColor = .black

    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = mTextColor
    }
}

//class RegularLabel: BaseUILabel {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        font = AppFont.regular(size: mFontSize)
//    }
//}
//
//class RegularItalicLabel: BaseUILabel {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        font = AppFont.regularItalic(size: mFontSize)
//    }
//}
//
//class SemiBoldLabel: BaseUILabel {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        font = AppFont.semiBold(size: mFontSize)
//    }
//}
//
//class BoldLabel: BaseUILabel {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        font = AppFont.bold(size: mFontSize)
//    }
//}
//
//class ExtraBoldLabel: BaseUILabel {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        font = AppFont.extraBold(size: mFontSize)
//    }
//}
//
//class ExtraBoldItalicLabel: BaseUILabel {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        font = AppFont.regular(size: mFontSize)
//    }
//}

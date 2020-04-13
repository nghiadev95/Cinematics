//
//  Utilities.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/10/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit

struct Utilities {
    static func createAttributeText(texts: [String], colors: [UIColor], fonts: [UIFont]) -> NSMutableAttributedString? {
        guard (texts.count == colors.count) && (colors.count == fonts.count) else { return nil }
        let attributeText = NSMutableAttributedString()
        texts.enumerated().forEach { (index, text) in
            attributeText.append(NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: fonts[index], NSAttributedString.Key.foregroundColor: colors[index]]))
        }
        return attributeText
    }
}

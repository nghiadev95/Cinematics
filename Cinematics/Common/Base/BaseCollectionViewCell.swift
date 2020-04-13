//
//  BaseCollectionViewCell.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/10/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override var reuseIdentifier: String? {
        return self.className
    }
}

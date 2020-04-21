//
//  LoadingView.swift
//  MovieApp
//
//  Created by Nghia Nguyen on 1/16/20.
//  Copyright © 2020 Teqnological Asia. All rights reserved.
//

import UIKit
import SnapKit

class LoadingView: UIView {
    let activityIndicatorView: UIActivityIndicatorView = {
        if #available(iOS 13, *) {
            return UIActivityIndicatorView(style: .medium)
        } else {
            return UIActivityIndicatorView(style: .gray)
        }
    }()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewSettings()
    }
    
    func viewSettings() {
        addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
            m.width.height.equalTo(50)
        }
        activityIndicatorView.startAnimating()
    }
}

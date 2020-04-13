//
//  MovieListView.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/13/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import Then

class MovieListView<C: UICollectionViewCell>: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let flowLayout = UICollectionViewFlowLayout()
    let titleLabel: UILabel = UILabel()
    
    struct Configuration {
        var cellNib: UINib
        var title: NSAttributedString?
        var minimumInteritemSpacing: CGFloat
        var minimumLineSpacing: CGFloat
        var scrollDirection: UICollectionView.ScrollDirection
        var itemSize: CGSize
        var contentInset: UIEdgeInsets
        var numOfItems: Int
        var cellForItemAt: (C, IndexPath) -> C
    }
    
    var configuration: Configuration!
    
    init(config: Configuration) {
        super.init(frame: CGRect())
        self.configuration = config
        self.viewSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewSetup() {
        backgroundColor = .clear
        
        let stackView = UIStackView().then {
            $0.spacing = 20
            $0.axis = .vertical
        }
        addSubview(stackView)
        stackView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        
        let titleView = UIView()
        titleView.backgroundColor = .clear
        titleView.addSubview(titleLabel)
        titleView.snp.makeConstraints { (m) in
            m.height.equalTo(21)
        }
        titleLabel.snp.makeConstraints { (m) in
            m.top.bottom.trailing.equalToSuperview()
            m.leading.equalToSuperview().offset(configuration.contentInset.left)
        }
        titleLabel.attributedText = configuration.title
        if configuration.title != nil {
            titleView.isHidden = false
        } else {
            titleView.isHidden = true
        }
        
        stackView.do {
            $0.addArrangedSubview(titleView)
            $0.addArrangedSubview(collectionView)
        }
        
        flowLayout.do {
            $0.minimumInteritemSpacing = configuration.minimumInteritemSpacing
            $0.minimumLineSpacing = configuration.minimumLineSpacing
            $0.scrollDirection = configuration.scrollDirection
            $0.itemSize = configuration.itemSize
        }
        
        collectionView.do {
            $0.register(configuration.cellNib, forCellWithReuseIdentifier: C.className)
            $0.collectionViewLayout = flowLayout
            $0.delegate = self
            $0.dataSource = self
            $0.contentInset = configuration.contentInset
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = configuration.scrollDirection == .vertical ? true : false
            $0.showsHorizontalScrollIndicator = !$0.showsVerticalScrollIndicator
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configuration.numOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.className, for: indexPath) as? C {
            return configuration.cellForItemAt(cell, indexPath)
        }
        return UICollectionViewCell()
    }
}

//
//  MoviesViewController.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/13/20.
//  Copyright (c) 2020 Nghia Nguyen. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import RxCocoa
import RxSwift
import UIKit

final class MoviesViewController: BaseViewController, NavigationBarVisible {
    @IBOutlet var stackContentView: UIStackView!

    // MARK: - Public properties -

    var presenter: MoviesPresenterInterface!
    var isHideNavigationBar: Bool = true

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    // MARK: - Private properties -

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Extensions -

extension MoviesViewController: MoviesViewInterface {}

private extension MoviesViewController {
    func setupView() {
        createTrendingView()
        createPopularView()
        createTopRatedView()
    }

    private func createTrendingView() {
        let config = MovieListView<TrendingCell>.Configuration(cellNib: UINib(resource: R.nib.trendingCell),
                                                               title: nil,
                                                               minimumInteritemSpacing: 0,
                                                               minimumLineSpacing: 20,
                                                               scrollDirection: .horizontal,
                                                               itemSize: CGSize(width: 320, height: 180),
                                                               contentInset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20),
                                                               numOfItems: 20,
                                                               cellForItemAt: { (cell, _) -> TrendingCell in
                                                                   cell
        })
        let trendingView = MovieListView<TrendingCell>(config: config)
        trendingView.snp.makeConstraints { m in
            m.height.equalTo(180)
        }
        stackContentView.addArrangedSubview(trendingView)
    }

    private func createPopularView() {
        let config = MovieListView<TitleSplitedCell>.Configuration(cellNib: UINib(resource: R.nib.titleSplitedCell),
                                                                   title: Utilities.createAttributeText(texts: ["Popular"], colors: [R.color.c666666()!], fonts: [AppFont.bold(size: 18)]),
                                                                   minimumInteritemSpacing: 0,
                                                                   minimumLineSpacing: 20,
                                                                   scrollDirection: .horizontal,
                                                                   itemSize: CGSize(width: 140, height: 256),
                                                                   contentInset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20),
                                                                   numOfItems: 20,
                                                                   cellForItemAt: { (cell, _) -> TitleSplitedCell in
                                                                       cell
        })
        let popularView = MovieListView<TitleSplitedCell>(config: config)
        popularView.snp.makeConstraints { m in
            m.height.equalTo(297)
        }
        stackContentView.addArrangedSubview(popularView)
    }
    
    private func createTopRatedView() {
        let config = MovieListView<RatedCell>.Configuration(cellNib: UINib(resource: R.nib.ratedCell),
                                                                   title: Utilities.createAttributeText(texts: ["Top Rated"], colors: [R.color.c666666()!], fonts: [AppFont.bold(size: 18)]),
                                                                   minimumInteritemSpacing: 10,
                                                                   minimumLineSpacing: 20,
                                                                   scrollDirection: .horizontal,
                                                                   itemSize: CGSize(width: 140, height: 220),
                                                                   contentInset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20),
                                                                   numOfItems: 20,
                                                                   cellForItemAt: { (cell, _) -> RatedCell in
                                                                       cell
        })
        let topRatedView = MovieListView<RatedCell>(config: config)
        topRatedView.snp.makeConstraints { m in
            m.height.equalTo(491)
        }
        stackContentView.addArrangedSubview(topRatedView)
    }
}

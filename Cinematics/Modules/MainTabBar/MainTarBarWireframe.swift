//
//  MainTarBarWireframe.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 5/31/20.
//  Copyright (c) 2020 Nghia Nguyen. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class MainTarBarWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let moviesWireFrame = MoviesWireframe()
    private let tvSeriesWireFrame = TVSeriesWireframe()
    private let profileWireFrame = ProfileWireframe()

    // MARK: - Module setup -

    init() {
        let moduleViewController = MainTarBarViewController()
        super.init(viewController: moduleViewController)

        let presenter = MainTarBarPresenter(view: moduleViewController, wireframe: self)
        moduleViewController.presenter = presenter

        let moviesNavigation = UINavigationController(rootViewController: moviesWireFrame.viewController)
        let tvSeriesNavigation = UINavigationController(rootViewController: tvSeriesWireFrame.viewController)
        let profileNavigation = UINavigationController(rootViewController: profileWireFrame.viewController)

        moviesNavigation.tabBarItem = UITabBarItem(title: "Movies", image: R.image.tab_icon_movies_inactive()!, selectedImage: R.image.tab_icon_movies_active()!)
        tvSeriesNavigation.tabBarItem = UITabBarItem(title: "TV", image: R.image.tab_icon_tv_inactive()!, selectedImage: R.image.tab_icon_tv_active()!)
        profileNavigation.tabBarItem = UITabBarItem(title: "Profile", image: R.image.tab_icon_profile_inactive()!, selectedImage: R.image.tab_icon_profile_active()!)

        moduleViewController.setViewControllers([moviesNavigation, tvSeriesNavigation, profileNavigation], animated: false)
    }

}

// MARK: - Extensions -

extension MainTarBarWireframe: MainTarBarWireframeInterface {
}

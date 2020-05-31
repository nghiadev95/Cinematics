//
//  ProfileWireframe.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 5/31/20.
//  Copyright (c) 2020 Nghia Nguyen. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class ProfileWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "Profile", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: ProfileViewController.self)
        super.init(viewController: moduleViewController)

        let formatter = ProfileFormatter()
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter(view: moduleViewController, formatter: formatter, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension ProfileWireframe: ProfileWireframeInterface {
}

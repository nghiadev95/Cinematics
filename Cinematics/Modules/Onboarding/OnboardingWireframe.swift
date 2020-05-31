//
//  OnboardingWireframe.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 5/31/20.
//  Copyright (c) 2020 Nghia Nguyen. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: OnboardingViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = OnboardingInteractor()
        let presenter = OnboardingPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension OnboardingWireframe: OnboardingWireframeInterface {
    func navigate(to option: OnboardingNavigationOption) {
        switch option {
        case .home:
            navigationController?.setRootWireframe(MainTarBarWireframe())
        }
    }
}
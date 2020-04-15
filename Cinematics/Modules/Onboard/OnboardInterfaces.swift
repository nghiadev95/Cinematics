//
//  OnboardInterfaces.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/10/20.
//  Copyright (c) 2020 Nghia Nguyen. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import RxSwift
import RxCocoa

enum OnboardNavigationOption {
    case home
}

enum Onboard {

    struct ViewOutput {
        var index: Int
        var nextButtonImage: UIImage
    }

    struct ViewInput {
    }
}

protocol OnboardWireframeInterface: WireframeInterface {
    func navigate(to option: OnboardNavigationOption)
}

protocol OnboardViewInterface: ViewInterface {
    func moveToNextPage(info: Onboard.ViewOutput)
}

protocol OnboardPresenterInterface: PresenterInterface {
    func didNextButtonTapped()
}

protocol OnboardInteractorInterface: InteractorInterface {
}
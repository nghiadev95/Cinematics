//
//  MainTarBarPresenter.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 5/31/20.
//  Copyright (c) 2020 Nghia Nguyen. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

final class MainTarBarPresenter {

    // MARK: - Private properties -

    private unowned let view: MainTarBarViewInterface
    private let wireframe: MainTarBarWireframeInterface

    // MARK: - Lifecycle -

    init(view: MainTarBarViewInterface, wireframe: MainTarBarWireframeInterface) {
        self.view = view
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension MainTarBarPresenter: MainTarBarPresenterInterface {
}

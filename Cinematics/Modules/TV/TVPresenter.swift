//
//  TVPresenter.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/13/20.
//  Copyright (c) 2020 Nghia Nguyen. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation
import RxSwift
import RxCocoa

final class TVPresenter {

    // MARK: - Private properties -

    private unowned let view: TVViewInterface
    private let interactor: TVInteractorInterface
    private let wireframe: TVWireframeInterface

    // MARK: - Lifecycle -

    init(view: TVViewInterface, interactor: TVInteractorInterface, wireframe: TVWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension TVPresenter: TVPresenterInterface {

    func configure(with output: TV.ViewOutput) -> TV.ViewInput {
        return TV.ViewInput()
    }

}

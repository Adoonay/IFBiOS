//
//  CodeView.swift
//  Movies
//
//  Created by Adonay on 15/05/24.
//

import UIKit

protocol BindableView {
    func bindViewModel()
}

protocol CodeView {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupView()
}

extension CodeView {
    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }

    func setupAdditionalConfiguration() {

    }
}

extension CodeView where Self : BindableView {
    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
        bindViewModel()
    }
}

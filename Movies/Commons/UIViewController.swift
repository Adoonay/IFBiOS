//
//  UIViewController.swift
//  Movies
//
//  Created by Adonay on 15/05/24.
//

import UIKit

extension UIViewController {
    func setupNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.largeTitleDisplayMode = .always

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.shadowColor = nil
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        let itemAppearence = UIBarButtonItemAppearance(style: .plain)
        itemAppearence.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

        appearance.buttonAppearance = itemAppearence
        appearance.backButtonAppearance = itemAppearence
        appearance.doneButtonAppearance = itemAppearence

        navigationItem.compactAppearance = appearance
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
}

extension UIView {
    static func stack(views: [UIView],
                      axis: NSLayoutConstraint.Axis,
                      spacing: CGFloat,
                      alignment: UIStackView.Alignment = .fill,
                      distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = axis
        stack.spacing = spacing
        stack.alignment = alignment
        stack.distribution = distribution
        return stack
    }
}

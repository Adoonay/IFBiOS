//
//  ItemAnnotation.swift
//  Map
//
//  Created by Adonay on 21/05/24.
//

import UIKit
import MapKit

class ItemAnnotation: NSObject, MKAnnotation {
    var item: Item
    var coordinate: CLLocationCoordinate2D

    init(item: Item) {
        self.item = item
        self.coordinate = item.coordinate
    }
}

class ItemAnnotationView: MKMarkerAnnotationView {
    func configure(annotation: ItemAnnotation) {
        let item = annotation.item
        markerTintColor = item.type.color
        glyphImage = item.type.image

        canShowCallout = true
        
        if item.type != .returned {
            let accessoryLabel = UIButton(frame: .init(x: 0, y: 0, width: 100, height: 40))
            accessoryLabel.setTitle(item.type == .lost ? "Marcar como\nencontrado" : "Marcar como\ndevolvido", for: .normal)
            accessoryLabel.setTitleColor(.black, for: .normal)
            accessoryLabel.titleLabel?.font = .systemFont(ofSize: 10, weight: .bold)
            accessoryLabel.titleLabel?.numberOfLines = 0
            accessoryLabel.titleLabel?.textAlignment = .center
            accessoryLabel.backgroundColor = item.type.color
            accessoryLabel.layer.cornerRadius = 8
            accessoryLabel.clipsToBounds = true
            rightCalloutAccessoryView = accessoryLabel
        } else {
            rightCalloutAccessoryView = nil
        }

        detailCalloutAccessoryView = AccessoryView(item: item)
    }

    class AccessoryView: UIView, CodeView {
        var item: Item

        lazy var contentStack: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()

        lazy var itemLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()

        init(item: Item) {
            self.item = item
            super.init(frame: .zero)
            setupView()
        }

        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func buildViewHierarchy() {
            addSubview(contentStack)

            contentStack.addArrangedSubview(titleLabel)
            contentStack.addArrangedSubview(itemLabel)
        }

        func setupConstraints() {
            NSLayoutConstraint.activate([
                contentStack.topAnchor.constraint(equalTo: topAnchor),
                contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
                contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }

        func setupAdditionalConfiguration() {
            translatesAutoresizingMaskIntoConstraints = false

            titleLabel.text = item.type.title + ":"
            itemLabel.text = item.description
        }
    }
}

//
//  GenreCell.swift
//  Movies
//
//  Created by Adonay on 15/05/24.
//

import UIKit

struct Genre: Codable, Equatable {
    var id: Int
    var name: String
}

class GenreCell: UICollectionViewCell, CodeView {
    var genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    func updateSelection() {
        if isSelected {
            backgroundColor = .white
        } else {
            backgroundColor = .white.withAlphaComponent(0.2)
        }
    }

    func configure(genre: Genre) {
        genreLabel.text = genre.name
        updateSelection()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    func buildViewHierarchy() {
        addSubview(genreLabel)
        layer.cornerRadius = 8.0
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            genreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            genreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            genreLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

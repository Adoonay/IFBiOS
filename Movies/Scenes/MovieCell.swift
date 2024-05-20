//
//  MovieCell.swift
//  Movies
//
//  Created by Adonay on 15/05/24.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell, CodeView {
    var contentStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    var yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    var coverImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()

    func configure(movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = [String(movie.releaseDate.prefix(4)), movie.genres ?? ""].filter({ !$0.isEmpty }).joined(separator: " • ")
        coverImageView.kf.setImage(with: movie.posterURL)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    func buildViewHierarchy() {
        addSubview(contentStack)

        contentStack.addArrangedSubview(coverImageView)
        contentStack.addArrangedSubview(.stack(views: [titleLabel, yearLabel], axis: .vertical, spacing: .zero))
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor,
                                                   multiplier: 1.5)
        ])
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .black

        coverImageView.layer.cornerRadius = 8
        coverImageView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    let view = MovieCell(frame: .init(x: 0, y: 0, width: 300, height: 400))
    view.configure(movie: .init(id: 10, title: "Teste", posterPath: "", releaseDate: "", genreIds: []))
    return view
}

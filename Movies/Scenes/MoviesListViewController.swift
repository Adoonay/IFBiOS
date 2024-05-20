//
//  ViewController.swift
//  Movies
//
//  Created by Adonay on 15/05/24.
//

import UIKit

class MoviesListViewController: UIViewController, CodeView, BindableView {
    lazy var collectionView: MoviesCollectionView = {
        let view = MoviesCollectionView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var viewModel: MoviesListViewModel

    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        navigationItem.title = "Filmes"
        setupView()
        setupNavigation()
        bindViewModel()

        viewModel.viewDidLoad()
    }

    func bindViewModel() {
        viewModel.state.bind { state in
            switch state {
            case .loading:
                break
            case .ready:
                self.collectionView.reloadData()
            }
        }
    }

    func buildViewHierarchy() {
        view.addSubview(collectionView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupAdditionalConfiguration() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GenreCell.self, forCellWithReuseIdentifier: "\(GenreCell.self)")
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "\(MovieCell.self)")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 0 else {
            return
        }

        viewModel.toggleCategory(at: indexPath.row)
        collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? viewModel.genres.count : viewModel.movies.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let genre = viewModel.genres[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GenreCell.self)", for: indexPath)
            cell.isSelected = viewModel.isSelected(genre: genre)
            if let cell = cell as? GenreCell {
                cell.configure(genre: genre)
            }
            return cell
        default:
            let movie = viewModel.movies[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieCell.self)", for: indexPath)
            if let cell = cell as? MovieCell {
                cell.configure(movie: movie)
            }
            return cell
        }
    }
}

#Preview {
    let viewModel = MoviesListViewModel()
    let viewController = MoviesListViewController(viewModel: viewModel)
    let root = UINavigationController(rootViewController: viewController)
    return root
}

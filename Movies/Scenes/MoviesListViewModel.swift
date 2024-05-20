//
//  MoviesListViewModel.swift
//  Movies
//
//  Created by Adonay on 15/05/24.
//

import Combine
import UIKit

enum MoviesListViewModelState {
    case loading
    case ready
}

class MoviesListViewModel {
    var movies: [Movie] = []
    var genres: [Genre] = []
    var selectedGenres: [Genre] = []

    var state: Bindable<MoviesListViewModelState> = .init(.ready)
    var service: MovieServiceProtocol = MovieService()

    private var cancellables = Set<AnyCancellable>()
    var selectionDebounce : PassthroughSubject<Void, Never>

    init() {
        selectionDebounce = PassthroughSubject<Void, Never>()
        selectionDebounce
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { _ in
                Task { self.refreshMovies() }
            }.store(in: &cancellables)
    }

    func viewDidLoad() {
        Task {
            await fetchGenres()
            await fetchMovies()
        }
    }

    func fetchGenres() async {
        do {
            state.value = .loading
            genres = try await service.fetchGenres()
            state.value = .ready
        } catch {
            print(error.localizedDescription)
        }
    }

    func refreshMovies() {
        Task {
            await fetchMovies()
        }
    }

    func fetchMovies() async {
        do {
            state.value = .loading
            movies = try await service.fetchMovies(genres: selectedGenres)
            updateGenres()
            state.value = .ready
        } catch {
            print(error.localizedDescription)
        }
    }

    func updateGenres() {
        for (index, movie) in movies.enumerated() {
            movies[index].genres = genreMap(ids: movie.genreIds)
        }
    }

    func genreMap(ids: [Int]) -> String {
        return genres.filter({ genre in
            ids.contains(genre.id)
        }).map({ $0.name }).joined(separator: ", ")
    }

    func isSelected(genre: Genre) -> Bool {
        return selectedGenres.contains(genre)
    }

    func toggleCategory(at index: Int) {
        let genre = genres[index]
        if let index = selectedGenres.firstIndex(of: genre) {
            selectedGenres.remove(at: index)
        } else {
            selectedGenres.append(genre)
        }
        selectionDebounce.send()
    }
}

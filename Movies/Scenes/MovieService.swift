//
//  MovieService.swift
//  Movies
//
//  Created by Adonay on 15/05/24.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchGenres() async throws -> [Genre]
    func fetchMovies(genres: [Genre]) async throws -> [Movie]
}

enum ServiceError: Error {
    case badRequest
}

class MovieService: MovieServiceProtocol {
    func makeRequest<T: Decodable>(endpoint: String, queryItems: [URLQueryItem] = []) async throws -> T {
        guard let url = URL(string: "https://api.themoviedb.org/3/\(endpoint)") else {
            throw ServiceError.badRequest
        }

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw ServiceError.badRequest
        }

        let initialQueryItems: [URLQueryItem] = [URLQueryItem(name: "language", value: "pt-BR")] + queryItems
        components.queryItems = components.queryItems.map { $0 + initialQueryItems } ?? initialQueryItems

        guard let urlRequest = components.url else {
            throw ServiceError.badRequest
        }

        var request = URLRequest(url: urlRequest)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkMzg2YzMyNDE0Y2YxYzFjNmVmMjQzMjRiODMxMDg2NiIsInN1YiI6IjVjZjcyYTg0MGUwYTI2Nzk5M2NiYWMyOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.b84ia_PS-xTtb5XN4z21NesyQfQ4EQ03MJF-TgQ0Kvc"
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(token)"
        ]

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let object = try decoder.decode(T.self, from: data)
        return object
    }

    func fetchGenres() async throws -> [Genre] {
        struct GenreList: Codable {
            var genres: [Genre]
        }
        
        let object: GenreList = try await makeRequest(endpoint: "genre/movie/list", queryItems: [])
        return object.genres
    }
    
    func fetchMovies(genres: [Genre]) async throws -> [Movie] {
        struct Pagination: Codable {
            var page: Int
            var results: [Movie]
        }

        let genreIds = genres.map({ String($0.id) }).joined(separator: "|")
        let genreFilter = URLQueryItem(name: "with_genres", value: genreIds)
        let pagination: Pagination = try await makeRequest(endpoint: "discover/movie", queryItems: [genreFilter])
        return pagination.results
    }
}

//
//  Movie.swift
//  Movies
//
//  Created by Adonay on 20/05/24.
//

import UIKit

struct Movie: Codable {
    var id: Int
    var title: String
    var posterPath: String
    var releaseDate: String
    var genreIds: [Int]
    var genres: String?

    var posterURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)
    }
}

//
//  Movie.swift
//  TheReel
//
//  Created by ashley canty on 4/25/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

struct JSONData: Codable {
    var page: Int?
    var total_results: Int?
    var total_pages: Int?
    var results: [Results]?
}

struct Results: Codable {
    var vote_count: Int?
    var id: Int?
    var video: Bool?
    var vote_average: Double?
    var title: String?
    var popularity: Double?
    var poster_path: String?
    var original_language: String?
    var original_title: String?
    var genre_ids: [Int]?
    var backdrop_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
    var runtime: Int?
    var mainGenre: String?
    var trailerKey: String?
}

struct Movie: Codable {
    var title: String?
    var releaseDate: String?
    var voteAverage: Double?
    var overview: String?
    var posterImage: String?
    var posterPath: String?
    var backdropPath: String?
    var genreIDs: [Int]?
    var genres: String?
    var runtime: String?
    var id: String?
    var imdbID: String?
    var homepage: String?
    var voteCount: String?
    var saved: Bool?
    var index: Int?
}

struct DummyData {
    var posters = ["poster1": "Spiderman: Far from Home", "poster2": "Battle Angle: Alita", "poster3": "The Lion King"]
    var backdrops = ["backdrop1": "John Wick 3", "backdrop2": "Toy Story 4", "backdrop3": "The Lion King"]
}

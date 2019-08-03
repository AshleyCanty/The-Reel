//
//  MovieDetails.swift
//  TheReel
//
//  Created by ashley canty on 7/18/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

// MARK: -- MovieDetails

struct MovieDetails: Codable {
    var adult: Bool?
    var backdrop_path: String?
    var belongs_to_collection: Collection?
    var budget: Int?
    var genres: [Genres]?
    var homepage: String?
    var id: Int?
    var imdb_id: String?
    var original_language: String?
    var original_title: String?
    var overview: String?
    var popularity: Double?
    var poster_path: String?
    var production_companies: [ProductionCompanies]?
    var production_countries: [ProductionCountries]?
    var release_date: String?
    var revenue: Int?
    var runtime: Int?
    var spoken_languages: [SpokenLanguages]?
    var status: String?
    var tagline: String?
    var title: String?
    var video: Bool?
    var vote_average: Double?
    var vote_count: Int?
}

struct SpokenLanguages: Codable {
    var iso_639_1: String?
    var name: String?
}

struct Collection: Codable {
    var id: Int?
    var name: String?
    var poster_path: String?
    var backdrop_path: String?
}

struct ProductionCompanies: Codable {
    var id: Int?
    var logo_path: String?
    var name: String?
    var origin_country: String?
}

struct Genres: Codable {
    var id: Int?
    var name: String?
}

struct ProductionCountries: Codable {
    var iso_3166_1: String?
    var name: String?
}

// MARK: -- MovieTrailer

struct MovieTrailer: Codable {
    var id: Int?
    var results: [TrailerResults]?
}

struct TrailerResults: Codable {
    var id: String?
    var iso_639_1: String?
    var iso_3166_1: String?
    var key: String?
    var name: String?
    var site: String?
    var size: Int?
    var type: String?
}

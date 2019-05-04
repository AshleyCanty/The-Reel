//
//  Movie.swift
//  TheReel
//
//  Created by ashley canty on 4/25/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit


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

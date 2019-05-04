//
//  MovieDBQueries.swift
//  TheReel
//
//  Created by ashley canty on 4/28/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

class MovieDBQueries {
    static var baseURL = "https://api.themoviedb.org/3/"
    static var apiKey = "ed2bb86ac3aa37b6f0ff2828ec216d10"
    static var discoverMoviesByKeyword = "https://api.themoviedb.org/3/search/movie?api_key=ed2bb86ac3aa37b6f0ff2828ec216d10&query="
    static var getMovieDetailsBaseURL = "https://api.themoviedb.org/3/movie/"
    static var getEnglishVersionTailURL = "?api_key=ed2bb86ac3aa37b6f0ff2828ec216d10&&language=en-US"
    static var getMovieCreditsTailURL = "/credits?api_key=ed2bb86ac3aa37b6f0ff2828ec216d10"
    static var movieImageBaseURL = "https://image.tmdb.org/t/p/original"
    static var movieTrailerTailURL = "/videos?api_key=ed2bb86ac3aa37b6f0ff2828ec216d10&language=en-US"
    static var movieGenresURL = "https://api.themoviedb.org/3/genre/movie/list?api_key=ed2bb86ac3aa37b6f0ff2828ec216d10&language=en-US"
}



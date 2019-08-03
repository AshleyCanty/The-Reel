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
    static var getPopularMovies = "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=ed2bb86ac3aa37b6f0ff2828ec216d10"
    static var getReleasedMovies = "https://api.themoviedb.org/3/discover/movie?primary_release_date.gte=2014-09-15&primary_release_date.lte=2014-10-22&api_key=ed2bb86ac3aa37b6f0ff2828ec216d10"
    static var getUpcomingMovies = "https://api.themoviedb.org/3/movie/upcoming?api_key=ed2bb86ac3aa37b6f0ff2828ec216d10&language=en-US&page=1"
    static var getMovieDetailsBaseURL = "https://api.themoviedb.org/3/movie/"
    static var getEnglishVersionTailURL = "?api_key=ed2bb86ac3aa37b6f0ff2828ec216d10&&language=en-US"
    static var getMovieCreditsTailURL = "/credits?api_key=ed2bb86ac3aa37b6f0ff2828ec216d10"
    static var movieImageBaseURL = "https://image.tmdb.org/t/p/original"
    static var movieTrailerTailURL = "/videos?api_key=ed2bb86ac3aa37b6f0ff2828ec216d10&language=en-US"
    static var movieGenresURL = "https://api.themoviedb.org/3/genre/movie/list?api_key=ed2bb86ac3aa37b6f0ff2828ec216d10&language=en-US"
}



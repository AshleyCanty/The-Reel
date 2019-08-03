//
//  ImageNames.swift
//  TheReel
//
//  Created by ashley canty on 5/4/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation

enum NotificationKeys: String {
    case loadHomescreenTable = "loadHomescreenTable"
}

enum ImageNames: String {
    case noImage = "noImage"
    case emptyHeart = "emptyHeart"
    case filledHeart = "heart"
}

enum MovieDBKeys: String {
    case ID = "id"
    case Title = "title"
    case ReleaseDate = "release_date"
    case VoteCount = "vote_count"
    case VoteAverage = "vote_average"
    case Runtime = "runtime"
    case TotalResults = "total_results"
    case Overview = "overview"
    case Genres = "genres"
    case GenreIDs = "genre_ids"
    case PosterURL = "poster_path"
    case Backdrop = "backdrop_path"
    case Name = "name"
    case Results = "results"
    case Trailer = "Trailer"
    case TypeKey = "type"
    case Key = "key"
}

enum AlertMessages: String {
    case EmptyMessageTitle = "Empty Field"
    case EmptyFieldMessage = "Please enter a movie title"
    case Okay = "Okay"
    case GoBack = "Go Back"
    case NoResults = "No Results"
    case NoResultsMessage = "No results were located."
}

enum CellIdentifiers: String {
    case TopViewCell = "TopViewCell"
    case SaveAndShareCell = "SaveAndShareCell"
    case ExtraDetailsCell = "ExtraDetailsCell"
    case Overview = "OverviewCell"
    case TrailerCell = "TrailerCell"
    case MovieCell = "MovieCell"
    case SearchResultCell = "MovieSearchResultCell"
}

enum TrailerButton: String {
    case PlayTrailer = "Watch Trailer"
    case NoTrailer = "No Trailer Available"
}

enum VCIdentifiers: String {
    case MovieTrailerVC = "MovieTrailerViewController"
}

enum ShareMessage: String {
    case Message = "Hey, you should check out this movie!"
}

enum LabelTexts: String {
    case noPlot = "There is no plot available for this film at this time."
}



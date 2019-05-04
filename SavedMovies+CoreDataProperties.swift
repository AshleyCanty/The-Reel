//
//  SavedMovies+CoreDataProperties.swift
//  
//
//  Created by ashley canty on 5/2/19.
//
//

import Foundation
import CoreData


extension SavedMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedMovies> {
        return NSFetchRequest<SavedMovies>(entityName: "SavedMovies")
    }

    @NSManaged public var id: String?
    @NSManaged public var posterImage: NSData?
    @NSManaged public var title: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var overview: String?
    @NSManaged public var backdropPath: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var genres: String?
    @NSManaged public var voteCount: String?
    @NSManaged public var saved: Bool

}

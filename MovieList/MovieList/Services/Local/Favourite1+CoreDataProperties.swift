//
//  Favourite1+CoreDataProperties.swift
//  MovieList
//
//  Created by Khoa Mai on 9/19/21.
//
//

import Foundation
import CoreData


extension Favourite1 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourite1> {
        return NSFetchRequest<Favourite1>(entityName: "Favourite1")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var rating: Float
    @NSManaged public var releasedate: String?
    @NSManaged public var poster: String?

}

extension Favourite1 : Identifiable {

}

//
//  LocalServiceType.swift
//  MovieList
//
//  Created by Khoa Mai on 9/20/21.
//

import Foundation
import CoreData
import Combine

protocol LocalServiceType {
    
    func checkItemExist<Entity: NSManagedObject>(_ managedObjectId: NSManagedObjectID) -> AnyPublisher<Entity, Error>
    func addMovie<Entity: NSManagedObject>(movieId: Int, title: String, releaseDate: String, poster: String, rating: Float) -> AnyPublisher<Entity, Error>
    func removeMovie<Entity: NSManagedObject>(_ managedObjectId: NSManagedObjectID) -> AnyPublisher<Entity, Error>
    func fetchMovies<Entity: NSManagedObject>() -> AnyPublisher<[Entity], Error>
}

enum LocalError: Error {
    case itemNotExist
    case itemExist
    case entityNotFound
    case unknown
}

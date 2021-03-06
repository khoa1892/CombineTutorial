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
    
    associatedtype Entity
    
    func checkItemExist(_ movieId: Int) -> AnyPublisher<Bool, Error>
    func addMovie(movieId: Int, title: String, releaseDate: String, poster: String, rating: Float) -> AnyPublisher<Entity?, Error>
    func removeMovie(_ movieId: Int) -> AnyPublisher<Entity?, Error>
    func fetchMovies() -> AnyPublisher<[Entity], Error>
}

enum LocalError: Error {
    case itemNotExist
    case itemExist
    case entityNotFound
    case unknown
}

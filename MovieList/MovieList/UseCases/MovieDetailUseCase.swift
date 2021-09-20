//
//  MovieDetailUseCase.swift
//  MovieList
//
//  Created by Khoa Mai on 9/20/21.
//

import Foundation
import Combine
import CoreData

protocol MovieDetailUseCaseType: AnyObject {
    
    func loadMovieDetail(_ movieId: Int) -> AnyPublisher<Result<Movie, Error>, Never>
    func checkItemExist(_ objectID: NSManagedObjectID) -> AnyPublisher<Result<NSManagedObject, Error>, Never>
    func addFav(movieId: Int, title: String, releaseDate: String, poster: String, rating: Float) -> AnyPublisher<Result<NSManagedObject, Error>, Never>
    func removeFav(_ managedObjectId: NSManagedObjectID) -> AnyPublisher<Result<NSManagedObject, Error>, Never>
}

final class MovieDetailUseCase: MovieDetailUseCaseType {
    
    let networkService: NetworkServiceType
    let localService: LocalServiceType
    
    init(networkService: NetworkServiceType, localService: LocalServiceType) {
        self.networkService = networkService
        self.localService = localService
    }
    
    func loadMovieDetail(_ movieId: Int) -> AnyPublisher<Result<Movie, Error>, Never> {
        return networkService.load(Requestable<Movie>.movieDetail(movieId))
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<Movie, Error>, Never> in .just(.failure(error)) }
            .eraseToAnyPublisher()
    }
    
    func checkItemExist(_ objectID: NSManagedObjectID) -> AnyPublisher<Result<NSManagedObject, Error>, Never> {
        return localService.checkItemExist(objectID)
            .map{ .success($0) }
            .catch { error -> AnyPublisher<Result<NSManagedObject, Error>, Never> in .just(.failure(error)) }
            .eraseToAnyPublisher()
    }
    
    func addFav(movieId: Int, title: String, releaseDate: String, poster: String, rating: Float) -> AnyPublisher<Result<NSManagedObject, Error>, Never> {
        return localService.addMovie(movieId: movieId, title: title, releaseDate: releaseDate, poster: poster, rating: rating)
            .map{ .success($0) }
            .catch { error -> AnyPublisher<Result<NSManagedObject, Error>, Never> in .just(.failure(error)) }
            .eraseToAnyPublisher()
    }
    
    func removeFav(_ managedObjectId: NSManagedObjectID) -> AnyPublisher<Result<NSManagedObject, Error>, Never> {
        return localService.removeMovie(managedObjectId)
            .map{ .success($0) }
            .catch { error -> AnyPublisher<Result<NSManagedObject, Error>, Never> in .just(.failure(error)) }
            .eraseToAnyPublisher()
    }
}

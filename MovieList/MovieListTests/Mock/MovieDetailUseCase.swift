//
//  MovieDetailUseCase.swift
//  MovieListTests
//
//  Created by Khoa Mai on 9/20/21.
//

import Foundation
import Combine
import CoreData
@testable import MovieList

class MovieDetailUseCase: MovieDetailUseCaseType {
    
    var invokedLoadMovieDetail = false
    var invokedLoadMovieDetailCount = 0
    var invokedLoadMovieDetailParameters: (movieId: Int, Void)?
    var invokedLoadMovieDetailParametersList = [(movieId: Int, Void)]()
    var stubbedLoadMovieDetailResult: AnyPublisher<Result<Movie, Error>, Never>!

    func loadMovieDetail(_ movieId: Int) -> AnyPublisher<Result<Movie, Error>, Never> {
        invokedLoadMovieDetail = true
        invokedLoadMovieDetailCount += 1
        invokedLoadMovieDetailParameters = (movieId, ())
        invokedLoadMovieDetailParametersList.append((movieId, ()))
        return stubbedLoadMovieDetailResult
    }

    var invokedCheckItemExist = false
    var invokedCheckItemExistCount = 0
    var invokedCheckItemExistParameters: (objectID: NSManagedObjectID, Void)?
    var invokedCheckItemExistParametersList = [(objectID: NSManagedObjectID, Void)]()
    var stubbedCheckItemExistResult: AnyPublisher<Result<NSManagedObject, Error>, Never>!

    func checkItemExist(_ objectID: NSManagedObjectID) -> AnyPublisher<Result<NSManagedObject, Error>, Never> {
        invokedCheckItemExist = true
        invokedCheckItemExistCount += 1
        invokedCheckItemExistParameters = (objectID, ())
        invokedCheckItemExistParametersList.append((objectID, ()))
        return stubbedCheckItemExistResult
    }

    var invokedAddFav = false
    var invokedAddFavCount = 0
    var invokedAddFavParameters: (movieId: Int, title: String, releaseDate: String, poster: String, rating: Float)?
    var invokedAddFavParametersList = [(movieId: Int, title: String, releaseDate: String, poster: String, rating: Float)]()
    var stubbedAddFavResult: AnyPublisher<Result<NSManagedObject, Error>, Never>!

    func addFav(movieId: Int, title: String, releaseDate: String, poster: String, rating: Float) -> AnyPublisher<Result<NSManagedObject, Error>, Never> {
        invokedAddFav = true
        invokedAddFavCount += 1
        invokedAddFavParameters = (movieId, title, releaseDate, poster, rating)
        invokedAddFavParametersList.append((movieId, title, releaseDate, poster, rating))
        return stubbedAddFavResult
    }

    var invokedRemoveFav = false
    var invokedRemoveFavCount = 0
    var invokedRemoveFavParameters: (managedObjectId: NSManagedObjectID, Void)?
    var invokedRemoveFavParametersList = [(managedObjectId: NSManagedObjectID, Void)]()
    var stubbedRemoveFavResult: AnyPublisher<Result<NSManagedObject, Error>, Never>!

    func removeFav(_ managedObjectId: NSManagedObjectID) -> AnyPublisher<Result<NSManagedObject, Error>, Never> {
        invokedRemoveFav = true
        invokedRemoveFavCount += 1
        invokedRemoveFavParameters = (managedObjectId, ())
        invokedRemoveFavParametersList.append((managedObjectId, ()))
        return stubbedRemoveFavResult
    }
}

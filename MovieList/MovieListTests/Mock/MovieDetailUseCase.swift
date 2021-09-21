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

    var invokedCheckItemExit = false
    var invokedCheckItemExitCount = 0
    var invokedCheckItemExitParameters: (movieId: Int, Void)?
    var invokedCheckItemExitParametersList = [(movieId: Int, Void)]()
    var stubbedCheckItemExitResult: AnyPublisher<Result<Bool, Error>, Never>!

    func checkItemExist(_ movieId: Int) -> AnyPublisher<Result<Bool, Error>, Never> {
        invokedCheckItemExit = true
        invokedCheckItemExitCount += 1
        invokedCheckItemExitParameters = (movieId, ())
        invokedCheckItemExitParametersList.append((movieId, ()))
        return stubbedCheckItemExitResult
    }

    var invokedAddFav = false
    var invokedAddFavCount = 0
    var invokedAddFavParameters: (movieId: Int, title: String, releaseDate: String, poster: String, rating: Float)?
    var invokedAddFavParametersList = [(movieId: Int, title: String, releaseDate: String, poster: String, rating: Float)]()
    var stubbedAddFavResult: AnyPublisher<Result<NSManagedObject?, Error>, Never>!

    func addFav(movieId: Int, title: String, releaseDate: String, poster: String, rating: Float) -> AnyPublisher<Result<NSManagedObject?, Error>, Never> {
        invokedAddFav = true
        invokedAddFavCount += 1
        invokedAddFavParameters = (movieId, title, releaseDate, poster, rating)
        invokedAddFavParametersList.append((movieId, title, releaseDate, poster, rating))
        return stubbedAddFavResult
    }

    var invokedRemoveFav = false
    var invokedRemoveFavCount = 0
    var invokedRemoveFavParameters: (movieId: Int, Void)?
    var invokedRemoveFavParametersList = [(movieId: Int, Void)]()
    var stubbedRemoveFavResult: AnyPublisher<Result<NSManagedObject?, Error>, Never>!

    func removeFav(_ movieId: Int) -> AnyPublisher<Result<NSManagedObject?, Error>, Never> {
        invokedRemoveFav = true
        invokedRemoveFavCount += 1
        invokedRemoveFavParameters = (movieId, ())
        invokedRemoveFavParametersList.append((movieId, ()))
        return stubbedRemoveFavResult
    }
}

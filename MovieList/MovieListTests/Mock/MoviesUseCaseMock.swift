//
//  MoviesUseCaseMock.swift
//  MovieList
//
//  Created by Khoa Mai on 9/18/21.
//

import Foundation
import Combine
@testable import MovieList

final class MoviesUseCaseMock: MoviesUseCaseType {

    var invokedLoadMovies = false
    var invokedLoadMoviesCount = 0
    var invokedLoadMoviesParameters: (keyword: String, Void)?
    var invokedLoadMoviesParametersList = [(keyword: String, Void)]()
    var stubbedLoadMoviesResult: AnyPublisher<Result<Movies, Error>, Never>!

    func loadMovies(_ keyword: String) -> AnyPublisher<Result<Movies, Error>, Never> {
        invokedLoadMovies = true
        invokedLoadMoviesCount += 1
        invokedLoadMoviesParameters = (keyword, ())
        invokedLoadMoviesParametersList.append((keyword, ()))
        return stubbedLoadMoviesResult
    }

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
}

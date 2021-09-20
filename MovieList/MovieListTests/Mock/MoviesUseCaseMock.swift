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

    var invokedSearchMovies = false
    var invokedSearchMoviesCount = 0
    var invokedSearchMoviesParameters: (keyword: String?, page: Int)?
    var invokedSearchMoviesParametersList = [(keyword: String?, page: Int)]()
    var stubbedSearchMoviesResult: AnyPublisher<Result<Movies, Error>, Never>!

    func searchMovies(_ keyword: String?, _ page: Int) -> AnyPublisher<Result<Movies, Error>, Never> {
        invokedSearchMovies = true
        invokedSearchMoviesCount += 1
        invokedSearchMoviesParameters = (keyword, page)
        invokedSearchMoviesParametersList.append((keyword, page))
        return stubbedSearchMoviesResult
    }
}

//
//  MoviesUseCase.swift
//  MovieList
//
//  Created by Khoa Mai on 9/17/21.
//

import Foundation
import Combine

protocol MoviesUseCaseType: AnyObject {
    
    func loadMovies(_ keyword: String) -> AnyPublisher<Result<Movies, Error>, Never>
    func loadMovieDetail(_ movieId: Int) -> AnyPublisher<Result<Movie, Error>, Never>
}

final class MoviesUseCase: MoviesUseCaseType {
    
    let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func loadMovies(_ keyword: String) -> AnyPublisher<Result<Movies, Error>, Never> {
        return networkService
            .load(Requestable<Movies>.movies(keyword))
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<Movies, Error>, Never> in .just(.failure(error)) }
            .eraseToAnyPublisher()
    }
    
    func loadMovieDetail(_ movieId: Int) -> AnyPublisher<Result<Movie, Error>, Never> {
        return networkService.load(Requestable<Movie>.movieDetail(movieId))
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<Movie, Error>, Never> in .just(.failure(error)) }
            .eraseToAnyPublisher()
    }
}

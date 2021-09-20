//
//  MoviesUseCase.swift
//  MovieList
//
//  Created by Khoa Mai on 9/17/21.
//

import Foundation
import Combine

protocol MoviesUseCaseType: AnyObject {
    
    func searchMovies(_ keyword: String?, _ page: Int) -> AnyPublisher<Result<Movies, Error>, Never>
}

final class MoviesUseCase: MoviesUseCaseType {
    
    let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func searchMovies(_ keyword: String?, _ page: Int) -> AnyPublisher<Result<Movies, Error>, Never> {
        return networkService
            .load(Requestable<Movies>.search(keyword, page))
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<Movies, Error>, Never> in .just(.failure(error)) }
            .eraseToAnyPublisher()
    }
}

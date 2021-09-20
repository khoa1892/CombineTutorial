//
//  FavouriteUseCase.swift
//  MovieList
//
//  Created by Khoa Mai on 9/20/21.
//

import Foundation
import Combine
import CoreData

protocol FavouriteUseCaseType: AnyObject {
    
    func loadFavourites() -> AnyPublisher<Result<[Favourite1], Error>, Never>
}

class FavouriteUseCase: FavouriteUseCaseType {
    
    let localService: LocalServiceType
    
    init(_ localService: LocalServiceType) {
        self.localService = localService
    }
    
    func loadFavourites() -> AnyPublisher<Result<[Favourite1], Error>, Never> {
        return localService.fetchMovies()
            .map{ .success($0) }
            .catch { error -> AnyPublisher<Result<[Favourite1], Error>, Never> in .just(.failure(error)) }
            .eraseToAnyPublisher()
    }
}

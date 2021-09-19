//
//  FavouriteUseCase.swift
//  MovieList
//
//  Created by Khoa Mai on 9/20/21.
//

import Foundation
import Combine

protocol FavouriteUseCaseType: AnyObject {
    
    func loadMovies() -> AnyPublisher<Result<[MovieCellViewModel], Error>, Never>
}

class FavouriteUseCase: FavouriteUseCaseType {
    
    
    init() {
        
    }
    
    func loadMovies() -> AnyPublisher<Result<[MovieCellViewModel], Error>, Never> {
        return CoreDataHelper.fetchFavItems().map{ $0 }
            .eraseToAnyPublisher()
    }
}

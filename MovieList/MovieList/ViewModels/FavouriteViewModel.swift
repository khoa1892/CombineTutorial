//
//  FavouriteViewModel.swift
//  MovieList
//
//  Created by Khoa Mai on 9/20/21.
//

import Foundation
import Combine
import CoreData

protocol FavouriteRouting: AnyObject {
    func movieDetail(_ movieId: Int)
}

class FavouriteViewModel: FavouriteViewModelType {
    
    private let useCase:FavouriteUseCaseType
    private weak var routing: FavouriteRouting?
    
    private var cancellabels = Set<AnyCancellable>()
    
    init(useCase: FavouriteUseCaseType, routing: FavouriteRouting?) {
        self.useCase = useCase
        self.routing = routing
    }
    
    func transform(input: FavouriteViewModelInput) -> FavouriteViewModelOutput {
        
        input.selection.sink { [weak self] item in
            self?.routing?.movieDetail(item.id)
        }.store(in: &cancellabels)
        
        let movies = input.appear
            .flatMap({ [unowned self] _ in self.useCase.loadFavourites() })
            .map { result -> FavouriteViewState in
                switch result {
                case .success(let items):
                    let movies = items.map { item -> MovieCellViewModel in
                        
                        let movie = Movie.init(id: Int(item.id), title: item.title ?? "", overview: item.overview ?? "", poster: item.poster, voteAverage: item.rating, releaseDate: item.releasedate)
                        return MovieCellViewModel.init(movie: movie)
                    }
                    return .success(movies)
                case .failure(let error):
                    return .error(error)
                }
            }.eraseToAnyPublisher()
        
        return movies
    }
}

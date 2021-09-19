//
//  FavouriteViewModel.swift
//  MovieList
//
//  Created by Khoa Mai on 9/20/21.
//

import Foundation
import Combine

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
    
    func initInput(input: FavouriteViewModelInput) -> FavouriteViewModelOutput {
        
        input.selection.sink { [weak self] id in
            self?.routing?.movieDetail(id)
        }.store(in: &cancellabels)
        
        let movies = input.appear
            .flatMap({ [unowned self] _ in self.useCase.loadMovies() })
            .map { result -> FavouriteViewState in
                switch result {
                case .success(let items):
                    return .success(items)
                case .failure(let error):
                    return .error(error)
                }
            }.eraseToAnyPublisher()
        
        let loading: FavouriteViewModelOutput = input.appear.map({_ in .loading }).eraseToAnyPublisher()
        
        return Publishers.Merge(movies, loading).eraseToAnyPublisher()
    }
}

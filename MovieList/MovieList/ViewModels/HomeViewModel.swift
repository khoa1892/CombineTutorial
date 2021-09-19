//
//  HomeViewModel.swift
//  MovieList
//
//  Created by Khoa Mai on 9/18/21.
//

import Foundation
import Combine

protocol Routing: AnyObject {
    func movieDetail(_ movieId: Int)
}

class HomeViewModel: HomeViewModelType {
    
    private weak var routing: Routing? = nil
    private let useCase: MoviesUseCaseType
    private var cancellabels = Set<AnyCancellable>()
    
    init(useCase: MoviesUseCaseType, routing: Routing?) {
        self.useCase = useCase
        self.routing = routing
    }
    
    func initInput(input: HomeViewModelInput) -> HomeViewModelOutput {
        
        cancellabels.forEach({ $0.cancel() })
        cancellabels.removeAll()
        
        input.selection.sink { [weak self] movieId in
            
            self?.routing?.movieDetail(movieId)
        }.store(in: &cancellabels)
        
        let loadingTrigger = input.editting.filter({ !$0.isEmpty }).map({ value -> HomeViewState in
            
            return .loading
        }).eraseToAnyPublisher()
        
        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
        
        let searchMovies = searchInput.filter({ !$0.isEmpty })
            .flatMap({ [unowned self] keyword in self.useCase.loadMovies(keyword) })
            .map({ result -> HomeViewState in
                
                switch result {
                case .success(let response):
                    if response.items.isEmpty {
                        
                        return .empty
                    } else {
                        let cellViewModels = response.items.map { movie in
                            MovieCellViewModel.init(movie: movie)
                        }
                        return .success(cellViewModels)
                    }
                case .failure(let error):
                    return .error(error)
                }
            }).eraseToAnyPublisher()
        
        let initialState: HomeViewModelOutput = .just(.idle)
        let emptySearchString: HomeViewModelOutput = searchInput.filter({ $0.isEmpty }).map({ _ in .idle }).eraseToAnyPublisher()
        
        let searchTrigger: HomeViewModelOutput = Publishers.Merge(searchMovies, loadingTrigger).eraseToAnyPublisher()
        let idle: HomeViewModelOutput = Publishers.Merge(initialState, emptySearchString).eraseToAnyPublisher()
        
        return Publishers.Merge(idle, searchTrigger).removeDuplicates().eraseToAnyPublisher()
    }
}

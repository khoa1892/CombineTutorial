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
    
    private var currentPage: Int = 1
    private var totalPage: Int = 0
    
    var items: [MovieCellViewModel] = [] {
        didSet {
            
        }
    }
    
    var canLoardMore: Bool {
        return currentPage < totalPage
    }
    
    init(useCase: MoviesUseCaseType, routing: Routing?) {
        self.useCase = useCase
        self.routing = routing
    }
    
    func transform(input: HomeViewModelInput) -> HomeViewModelOutput {
        
        cancellabels.forEach({ $0.cancel() })
        cancellabels.removeAll()
        
        input.selection.sink { [weak self] movieId in
            
            self?.routing?.movieDetail(movieId)
        }.store(in: &cancellabels)
        
        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
        
        let initialState: HomeViewModelOutput = .just(.idle)
        let emptySearchString: HomeViewModelOutput = searchInput.filter({ $0.isEmpty}).map({ _ in .empty }).eraseToAnyPublisher()
        
        let searchMovies = searchInput.filter({ !$0.isEmpty })
            .flatMap { [unowned self] keyword -> AnyPublisher<Result<Movies, Error>, Never> in
                
                self.currentPage = 1
                return self.useCase.searchMovies(keyword, self.currentPage)
            }.map({ [weak self] result -> HomeViewState in
                
                return self?.refreshList(result) ?? .empty
            }).eraseToAnyPublisher()
        
        let loadMore = input.loadMore.flatMap { [unowned self] keyword -> AnyPublisher<Result<Movies, Error>, Never> in
            
            return self.useCase.searchMovies(keyword, currentPage)
        }.map({ [weak self] result -> HomeViewState in
            
            switch result {
            case .success(let response):
                let cellViewModels = response.items.map { movie in
                    MovieCellViewModel.init(movie: movie)
                }
                self?.items += cellViewModels
                self?.currentPage += 1
                return .success(self?.items ?? [])
            case .failure(let error):
                return .error(error)
            }
        }).eraseToAnyPublisher()
        
        let idle: HomeViewModelOutput = Publishers.Merge(initialState, emptySearchString).eraseToAnyPublisher()
        let loading: HomeViewModelOutput = Publishers.Merge(searchMovies, loadMore).eraseToAnyPublisher()
        
        return Publishers.Merge(idle, loading).removeDuplicates().eraseToAnyPublisher()
    }
    
    private func refreshList(_ result: Result<Movies, Error>) -> HomeViewState {
        switch result {
        case .success(let response):
            if response.items.isEmpty {

                return .empty
            } else {
                
                let cellViewModels = response.items.map { movie in
                    MovieCellViewModel.init(movie: movie)
                }
                items = cellViewModels
                totalPage = response.totalPage
                currentPage += 1
                return .success(items)
            }
        case .failure(let error):
            return .error(error)
        }
    }
}

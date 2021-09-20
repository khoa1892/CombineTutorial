//
//  DetailViewModel.swift
//  MovieList
//
//  Created by Khoa Mai on 9/19/21.
//

import Foundation
import Combine
import CoreData

class DetailViewModel: DetailViewModelType {
    
    private let useCase: MovieDetailUseCaseType
    private let id: Int
    
    private var movieDetail: MovieDetailModel?
    
    init(_ useCase: MovieDetailUseCaseType, id: Int) {
        self.useCase = useCase
        self.id = id
    }
    
    func transform(input: DetailViewModelInput) -> DetailViewModelOutput {
        
        let favouriteClick = input.favourite.flatMap { [unowned self] result -> AnyPublisher<Result<NSManagedObject?, Error>, Never> in
            let (item, isFav) = result
            if isFav {
                return self.useCase.removeFav(self.id)
            } else {
                let movie = item.movie
                return self.useCase.addFav(movieId: movie.id, title: movie.title, releaseDate: movie.releaseDate ?? "", poster: movie.poster ?? "", rating: movie.voteAverage)
            }
        }.map { [weak self] result -> DetailViewState in
            
            return self?.updateIsFav(result) ?? .empty
        }.eraseToAnyPublisher()
        
        let movieDetail = input.appear
            .flatMap({ [unowned self] _ in self.useCase.loadMovieDetail(self.id) })
            .map { result -> DetailViewState in
                
                switch result {
                case .success(let movie):
                    let movieDetail = MovieDetailModel.init(movie: movie)
                    return .success(movieDetail)
                case .failure(let error):
                    return .error(error)
                }
            }.eraseToAnyPublisher()
        
        let favourite = self.useCase.checkItemExit(self.id)
            .map { result -> DetailViewState in
                switch result {
                case .success(let isFav):
                    return .favourite(isFav)
                case .failure(_):
                    return .favourite(false)
                }
            }.eraseToAnyPublisher()
        
        let refresh = Publishers.Merge(movieDetail, favourite).eraseToAnyPublisher()
        let reloadFav = Publishers.Merge(refresh, favouriteClick).eraseToAnyPublisher()
        
        let loading: DetailViewModelOutput = input.appear.map({_ in .loading }).eraseToAnyPublisher()
        return Publishers.Merge(loading, reloadFav).eraseToAnyPublisher()
    }
    
    private func updateIsFav(_ result: Result<NSManagedObject?, Error>) -> DetailViewState {
        
        switch result {
        case .success(let item):
            return .favourite(item != nil)
        case .failure(let error):
            return .error(error)
        }
    }
}

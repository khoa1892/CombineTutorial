//
//  DetailViewModel.swift
//  MovieList
//
//  Created by Khoa Mai on 9/19/21.
//

import Foundation
import Combine

class DetailViewModel: DetailViewModelType {
    
    private let useCase: MovieDetailUseCaseType
    private let id: Int
    
    private var movieDetail: MovieDetailModel?
    
    init(_ useCase: MovieDetailUseCaseType, id: Int) {
        self.useCase = useCase
        self.id = id
    }
    
    func transform(input: DetailViewModelInput) -> DetailViewModelOutput {
        
        let favouriteClick = input.favourite.flatMap { item -> AnyPublisher<Result<Bool, Error>, Never> in
            let isFav = CoreDataHelper.checkMovieInfoExistInFavourites(item.id)
            if isFav {
                return CoreDataHelper.removeFavItem(item.id)
            } else {
                return CoreDataHelper.addMovieItem(item)
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
        
        let favourite = CoreDataHelper.checkItemExist(self.id)
            .map { [weak self] result -> DetailViewState in
                return self?.updateIsFav(result) ?? .empty
            }.eraseToAnyPublisher()
        
        let refresh = Publishers.Merge(movieDetail, favourite).eraseToAnyPublisher()
        let reloadFav = Publishers.Merge(refresh, favouriteClick).eraseToAnyPublisher()
        
        let loading: DetailViewModelOutput = input.appear.map({_ in .loading }).eraseToAnyPublisher()
        return Publishers.Merge(loading, reloadFav).eraseToAnyPublisher()
    }
    
    private func updateIsFav(_ result: Result<Bool, Error>) -> DetailViewState {
        
        switch result {
        case .success(let isFav):
            return .favourite(isFav)
        case .failure(let error):
            return .error(error)
        }
    }
}

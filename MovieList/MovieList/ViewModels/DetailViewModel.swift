//
//  DetailViewModel.swift
//  MovieList
//
//  Created by Khoa Mai on 9/19/21.
//

import Foundation
import Combine

class DetailViewModel: DetailViewModelType {
    
    private let useCase: MoviesUseCaseType
    private let id: Int
    
    @Published var isFav: Bool = false
    private var movieDetail: MovieDetailModel?
    private var cancellabels = Set<AnyCancellable>()
    
    init(_ useCase: MoviesUseCaseType, id: Int) {
        self.useCase = useCase
        self.id = id
    }
    
    func initInput(input: DetailViewModelInput) -> DetailViewModelOutput {
        
        input.favourite.sink { item in
            
            let isFav = CoreDataHelper.checkMovieInfoExistInFavourites(item.id)
            if isFav {
                
                CoreDataHelper.removeMovieInfoObjectFromFavourites(item.id) {
                    self.isFav = false
                }
            } else {
                
                CoreDataHelper.addMovieInfoObjectToSavedItems(item) {
                    self.isFav = true
                }
            }
        }.store(in: &cancellabels)
        
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
        
        let favourite = CoreDataHelper.checkItemExist(self.id).map { result -> DetailViewState in
            switch result {
            case .success(let isFav):
                return .favourite(isFav)
            case .failure(_):
                return .favourite(false)
            }
        }.eraseToAnyPublisher()
        
        let refresh = Publishers.Merge(movieDetail, favourite).eraseToAnyPublisher()
        
        let loading: DetailViewModelOutput = input.appear.map({_ in .loading }).eraseToAnyPublisher()
        return Publishers.Merge(loading, refresh).eraseToAnyPublisher()
    }
}

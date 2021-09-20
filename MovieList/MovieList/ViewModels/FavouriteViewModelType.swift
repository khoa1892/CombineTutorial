//
//  FavouriteViewModelType.swift
//  MovieList
//
//  Created by Khoa Mai on 9/20/21.
//

import Foundation
import Combine
import CoreData

struct FavouriteViewModelInput {
    
    let selection: AnyPublisher<MovieCellViewModel, Never>
    let appear: AnyPublisher<Void, Never>
}

enum FavouriteViewState {
    case loading
    case success([MovieCellViewModel])
    case error(Error)
}

extension FavouriteViewState: Equatable {
    static func == (lhs: FavouriteViewState, rhs: FavouriteViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsMovies), .success(let rhsMovies)): return lhsMovies == rhsMovies
        case (.error, .error): return true
        default: return false
        }
    }
}

typealias FavouriteViewModelOutput = AnyPublisher<FavouriteViewState, Never>

protocol FavouriteViewModelType {
    func transform(input: FavouriteViewModelInput) -> FavouriteViewModelOutput
}

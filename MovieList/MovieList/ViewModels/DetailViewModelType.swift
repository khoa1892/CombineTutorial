//
//  DetailViewModelType.swift
//  MovieList
//
//  Created by Khoa Mai on 9/19/21.
//

import Foundation
import Combine

struct DetailViewModelInput {
    
    let appear: AnyPublisher<Void, Never>
    let favourite: AnyPublisher<MovieDetailModel, Never>
}

enum DetailViewState {
    case loading
    case success(MovieDetailModel)
    case favourite(Bool)
    case empty
    case error(Error)
}

extension DetailViewState: Equatable {
    static func == (lhs: DetailViewState, rhs: DetailViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsMovies), .success(let rhsMovies)): return lhsMovies == rhsMovies
        case (.empty, .empty): return true
        case (.error, .error): return true
        default: return false
        }
    }
}

typealias DetailViewModelOutput = AnyPublisher<DetailViewState, Never>

protocol DetailViewModelType {
    func initInput(input: DetailViewModelInput) -> DetailViewModelOutput
}

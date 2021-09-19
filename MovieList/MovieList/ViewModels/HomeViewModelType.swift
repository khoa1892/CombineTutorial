//
//  HomeViewModelType.swift
//  MovieList
//
//  Created by Khoa Mai on 9/18/21.
//

import Foundation
import Combine

struct HomeViewModelInput {
    
    let appear: AnyPublisher<Void, Never>
    let editting: AnyPublisher<String, Never>
    let search: AnyPublisher<String, Never>
    let selection: AnyPublisher<Int, Never>
}

enum HomeViewState {
    case idle
    case loading
    case success([MovieCellViewModel])
    case empty
    case error(Error)
}

extension HomeViewState: Equatable {
    static func == (lhs: HomeViewState, rhs: HomeViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsMovies), .success(let rhsMovies)): return lhsMovies == rhsMovies
        case (.empty, .empty): return true
        case (.error, .error): return true
        default: return false
        }
    }
}

typealias HomeViewModelOutput = AnyPublisher<HomeViewState, Never>

protocol HomeViewModelType {
    func initInput(input: HomeViewModelInput) -> HomeViewModelOutput
}

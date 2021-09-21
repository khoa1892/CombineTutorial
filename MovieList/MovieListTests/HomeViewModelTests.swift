//
//  HomeViewModelTests.swift
//  MovieList
//
//  Created by Khoa Mai on 9/18/21.
//

import Foundation
import XCTest
import Combine
@testable import MovieList

class HomeViewModelTests: XCTestCase {
    
    private let useCaseMock = MoviesUseCaseMock()
    private var viewModel: HomeViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel.init(useCase: useCaseMock, routing: nil)
    }
    
    func test_loadData_searchBar() {
        
        let search = PassthroughSubject<String, Never>()
        let input = HomeViewModelInput.init(appear: .just(()), search: search.eraseToAnyPublisher(), loading: .just(()), loadMore: .just(""), selection: .just(0))
        var state:HomeViewState?
        
        let expection = self.expectation(description: "movies")
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "Movies", ofType: "json") else {
            fatalError("Movies.json not found")
        }

        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert Movies.json to String")
        }

        print("The JSON string is: \(jsonString)")

        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert Movies.json to Data")
        }
        let movies: Movies = try! JSONDecoder().decode(Movies.self, from: jsonData)
        
        let expectionCellViewModels = movies.items.map { movie in
            MovieCellViewModel.init(movie: movie)
        }
        
        useCaseMock.stubbedSearchMoviesResult = .just(.success(movies))
        viewModel.transform(input: input).sink { value in
            guard case HomeViewState.success = value else { return }
            state = value
            expection.fulfill()
        }.store(in: &cancellables)
        
        search.send("abc")
        
        waitForExpectations(timeout: TimeInterval(1.0), handler: nil)
        XCTAssertEqual(state!, .success(expectionCellViewModels))
    }
    
    func test_searchKeyword_IsFailed() {
        
        let search = PassthroughSubject<String, Never>()
        let input = HomeViewModelInput.init(appear: .just(()), search: search.eraseToAnyPublisher(), loading: .just(()), loadMore: .just(""), selection: .just(0))
        var state:HomeViewState?
        
        let expection = self.expectation(description: "movies")
        
        useCaseMock.stubbedSearchMoviesResult = .just(.failure(NetworkError.invalidResponse))
        viewModel.transform(input: input).sink { value in
            guard case HomeViewState.error = value else { return }
            state = value
            expection.fulfill()
        }.store(in: &cancellables)
        
        search.send("jorker")
        
        waitForExpectations(timeout: TimeInterval(1.0), handler: nil)
        XCTAssertEqual(state!, .error(NetworkError.invalidResponse))
    }
    
}

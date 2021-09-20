//
//  DetailViewModelTests.swift
//  MovieListTests
//
//  Created by Khoa Mai on 9/20/21.
//

import XCTest
import XCTest
import Combine
@testable import MovieList

class DetailViewModelTests: XCTestCase {
    
    private let useCaseMock = MovieDetailUseCase()
    private var viewModel: DetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        viewModel = DetailViewModel.init(useCaseMock, id: 117404)
    }
    
    func test_loadData_searchBar() {
        
        var state:DetailViewState?
        
        let expection = self.expectation(description: "movies")
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "Movie", ofType: "json") else {
            fatalError("Movie.json not found")
        }

        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert Movie.json to String")
        }

        print("The JSON string is: \(jsonString)")

        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert Movie.json to Data")
        }
        let movie: Movie = try! JSONDecoder().decode(Movie.self, from: jsonData)
        let expectionCellViewModel = MovieDetailModel.init(movie: movie)
        
        let input = DetailViewModelInput.init(appear: .just(()), favourite: .just(expectionCellViewModel))
        
        useCaseMock.stubbedLoadMovieDetailResult = .just(.success(movie))
        viewModel.transform(input: input).sink { value in
            guard case DetailViewState.success = value else { return }
            state = value
            expection.fulfill()
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: TimeInterval(1.0), handler: nil)
        XCTAssertEqual(state!, .success(expectionCellViewModel))
    }
    
}

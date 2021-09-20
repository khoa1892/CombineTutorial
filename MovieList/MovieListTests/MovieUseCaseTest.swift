//
//  MovieUseCaseTest.swift
//  MovieListTests
//
//  Created by Khoa Mai on 9/19/21.
//

import XCTest
import Combine
@testable import MovieList

class MovieUseCaseTest: XCTestCase {

    private let networkService = NetworkServiceTypeMock()
    private var useCase: MoviesUseCase!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        useCase = MoviesUseCase.init(networkService: networkService)
    }
    
    func test_searchmovie_Success() {
        // Given
        var result: Result<Movies, Error>!
        let expectation = self.expectation(description: "movies")
        
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
        
        networkService.responses["/3/search/movie"] = movies
        
        // When
        useCase.searchMovies("abc", 1).sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &cancellables)
        
        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .success = result! else {
            XCTFail()
            return
        }
    }
    
    func test_searchmovie_Fail() {
        // Given
        var result: Result<Movies, Error>!
        let expectation = self.expectation(description: "movies")
        
        networkService.responses["/3/search/movie"] = NetworkError.invalidResponse
        
        // When
        useCase.searchMovies("abc", 1).sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &cancellables)
        
        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .failure = result! else {
            XCTFail()
            return
        }
    }

}

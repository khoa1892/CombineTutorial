//
//  NetworkServiceTypeMock.swift
//  MovieListTests
//
//  Created by Khoa Mai on 9/19/21.
//

import Foundation
import Combine
@testable import MovieList

class NetworkServiceTypeMock: NetworkServiceType {

    var loadCallsCount = 0
    var loadCalled: Bool {
        return loadCallsCount > 0
    }
    var responses = [String:Any]()

    func load<T>(_ requestable: Requestable<T>) -> AnyPublisher<T, Error> {
        if let response = responses[requestable.url.path] as? T {
            return .just(response)
        } else if let error = responses[requestable.url.path] as? NetworkError {
            return .fail(error: error)
        } else {
            return .fail(error: NetworkError.invalidRequest)
        }
    }
}

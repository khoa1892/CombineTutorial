//
//  NetworkServiceTYpe.swift
//  MovieList
//
//  Created by Khoa Mai on 9/18/21.
//

import Foundation
import Combine

protocol NetworkServiceType: AnyObject {
    
    func load<T>(_ requestable: Requestable<T>) -> AnyPublisher<T, Error>
}

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case errorLoading(code: Int, data: Data)
    case jsonDecodeError(error: Error)
    case unknown
}

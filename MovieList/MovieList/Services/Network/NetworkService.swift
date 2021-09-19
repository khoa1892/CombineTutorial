//
//  NetworkService.swift
//  MovieList
//
//  Created by Khoa Mai on 9/18/21.
//

import Foundation
import Combine

final class NetworkService: NetworkServiceType {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.init(configuration: .default)) {
        self.session = session
    }
    
    func load<T>(_ requestable: Requestable<T>) -> AnyPublisher<T, Error> {
        guard let request = requestable.request else {
            return .fail(error: NetworkError.invalidRequest)
        }
        return session.dataTaskPublisher(for: request)
            .mapError { _ in NetworkError.invalidRequest }
            .print()
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(error: NetworkError.invalidResponse)
                }

                guard 200..<300 ~= response.statusCode else {
                    return .fail(error: NetworkError.errorLoading(code: response.statusCode, data: data))
                }
                return .just(data)
            }
            .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
}

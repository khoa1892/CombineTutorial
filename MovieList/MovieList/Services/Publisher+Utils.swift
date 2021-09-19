//
//  Publisher+Utils.swift
//  MovieList
//
//  Created by Khoa Mai on 9/18/21.
//

import Foundation
import Combine

extension Publisher {
    
    static func empty() -> AnyPublisher<Output, Failure> {
        return Empty().eraseToAnyPublisher()
    }

    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        return Just(output)
            .catch { _ in AnyPublisher<Output, Failure>.empty() }
            .eraseToAnyPublisher()
    }
    
    static func fail(error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail.init(error: error).eraseToAnyPublisher()
    }
}

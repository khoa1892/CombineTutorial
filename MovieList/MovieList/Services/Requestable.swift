//
//  Requestable.swift
//  MovieList
//
//  Created by Khoa Mai on 9/18/21.
//

import Foundation

struct Requestable<T: Decodable> {
    
    let url: URL
    let parameters: [String: CustomStringConvertible]
    var request: URLRequest? {
        guard var components = URLComponents.init(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map({ key in
            URLQueryItem.init(name: key, value: parameters[key]?.description)
        })
        guard let url = components.url else {
            return nil
        }
        return URLRequest.init(url: url)
    }
    
    init(url: URL, parameters: [String: CustomStringConvertible] = [:]) {
        self.url = url
        self.parameters = parameters
    }
}

extension Requestable {
    
    static func search(_ keyword: String?, _ page: Int) -> Requestable<Movies> {
        let url = ApiConstant.baseUrl.appendingPathComponent("/search/movie")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": ApiConstant.apiKey,
            "query": keyword ?? "\"\"",
            "page": page
        ]
        return Requestable<Movies>.init(url: url, parameters: parameters)
    }
    
    static func movieDetail(_ movieId: Int) -> Requestable<Movie> {
        let url = ApiConstant.baseUrl.appendingPathComponent("/movie/\(movieId)")
        let parameters: [String: CustomStringConvertible] = [
            "api_key": ApiConstant.apiKey
        ]
        return Requestable<Movie>.init(url: url, parameters: parameters)
    }
}

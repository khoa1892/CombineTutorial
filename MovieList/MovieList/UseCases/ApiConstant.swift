//
//  ApiConstant.swift
//  MovieList
//
//  Created by Khoa Mai on 9/17/21.
//

import Foundation

struct ApiConstant {
    
    static let apiKey = "5ebff4e7f372574a699bd576dd435b47"
    static let baseUrl = URL.init(string: "https://api.themoviedb.org/3")!
    static let originalImageUrl = URL(string: "https://image.tmdb.org/t/p/original")!
    static let smallImageUrl = URL(string: "https://image.tmdb.org/t/p/w154")!
}

//
//  Movies.swift
//  MovieList
//
//  Created by Khoa Mai on 9/17/21.
//

import Foundation

struct Movies {
    
    let page: Int
    let items: [Movie]
}

extension Movies: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case items = "results"
        case page = "page"
    }
}

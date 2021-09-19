//
//  Movie.swift
//  MovieList
//
//  Created by Khoa Mai on 9/17/21.
//

import Foundation

struct Movie {
    
    let id: Int
    let title: String
    let overview: String
    let poster: String?
    let voteAverage: Float
    let releaseDate: String?
}

extension Movie: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case poster = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}

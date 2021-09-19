//
//  MovieDetailModel.swift
//  MovieList
//
//  Created by Khoa Mai on 9/19/21.
//

import Foundation
import Combine

struct MovieDetailModel {
    
    let id: Int
    let title: String
    let overview: String
    let rating: String?
    let poster: URL?
    let movie: Movie

    init(movie: Movie) {
        self.movie = movie
        self.id = movie.id
        self.title = movie.title
        self.overview = movie.overview
        if movie.voteAverage > 0.0 {
            self.rating = "Rating: " + String(format: "%.1f", movie.voteAverage)
        } else {
            self.rating = nil
        }
        self.poster = ApiConstant.originalImageUrl.appendingPathComponent(movie.poster ?? "")
    }
}

extension MovieDetailModel: Hashable {
    static func == (lhs: MovieDetailModel, rhs: MovieDetailModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


//
//  MovieCellViewModel.swift
//  MovieList
//
//  Created by Khoa Mai on 9/18/21.
//

import Foundation
import CoreData

struct MovieCellViewModel {
    
    let movie: Movie
    let id: Int
    let managedObjectId: NSManagedObjectID?
    let title: String
    let releaseDate: String?
    let overview: String?
    let rating: String?
    let poster: URL?
    
    init(movie: Movie) {
        self.movie = movie
        self.id = movie.id
        self.title = movie.title
        if let date = movie.releaseDate {
            self.releaseDate = "Release Date: " + date
        } else {
            self.releaseDate = nil
        }
        if movie.voteAverage > 0.0 {
            self.rating = "Rating: " + String(format: "%.1f", movie.voteAverage)
        } else {
            self.rating = nil
        }
        self.overview = movie.overview
        self.poster = ApiConstant.smallImageUrl.appendingPathComponent(movie.poster ?? "")
        self.managedObjectId = nil
    }
    
    init(movie: Movie, managedObjectId: NSManagedObjectID?) {
        self.movie = movie
        self.id = movie.id
        self.title = movie.title
        if let date = movie.releaseDate {
            self.releaseDate = "Release Date: " + date
        } else {
            self.releaseDate = nil
        }
        if movie.voteAverage > 0.0 {
            self.rating = "Rating: " + String(format: "%.1f", movie.voteAverage)
        } else {
            self.rating = nil
        }
        self.overview = movie.overview
        self.poster = ApiConstant.smallImageUrl.appendingPathComponent(movie.poster ?? "")
        self.managedObjectId = managedObjectId
    }
}

extension MovieCellViewModel: Hashable {
    static func == (lhs: MovieCellViewModel, rhs: MovieCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

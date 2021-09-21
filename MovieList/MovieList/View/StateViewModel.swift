//
//  StateViewModel.swift
//  MovieList
//
//  Created by Khoa Mai on 9/21/21.
//

import Foundation

struct StateViewModel {
    
    let title: String
    let description: String?

    static var noResults: StateViewModel {
        let title = "No movies found!"
        let description = "Try searching again..."
        return StateViewModel(title: title, description: description)
    }
    
    static var startingSearch: StateViewModel {
        let title = "Searching by keyword..."
        return StateViewModel(title: title, description: nil)
    }

    static var startSearch: StateViewModel {
        let title = "Search for a movie..."
        return StateViewModel(title: title, description: nil)
    }
    
}

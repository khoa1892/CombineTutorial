//
//  CoreDataHelper.swift
//  MovieList
//
//  Created by Khoa Mai on 9/19/21.
//

import Foundation
import CoreData
import Combine

class CoreDataHelper {
    
    static func clearSavedFavourites(_ completionHandler: (()->Void)?) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite1")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            completionHandler?()
        } catch {
            print("Could not delete Favourite entity records. \(error)")
        }
    }
    
    static func removeMovieInfoObjectFromFavourites(_ movieId: Int,
                                                    completionHandler: (()->Void)?) {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite1")
        fetchRequest.predicate = NSPredicate(format: "id == \(movieId)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            completionHandler?()
        } catch {
            print("Could not delete Favourite entity record for id: \(movieId) \(error)")
        }
    }
    
    static func removeFavItem(_ movieId: Int) -> AnyPublisher<Result<Bool, Error>, Never> {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite1")
        fetchRequest.predicate = NSPredicate(format: "id == \(movieId)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            return .just(.success(false))
        } catch {
            return .just(.failure(error))
        }
    }
    
    static func checkMovieInfoExistInFavourites(_ id: Int) -> Bool {
        let savedItems = fetchSavedItemsMovieInfoList()
        for item in savedItems {
            if item.id == id {
                return true
            }
        }
        return false
    }
    
    static func checkItemExist(_ id: Int) -> AnyPublisher<Result<Bool, Error>, Never> {
        let savedItems = fetchSavedItemsMovieInfoList()
        for item in savedItems {
            if item.id == id {
                return .just(.success(true))
            }
        }
        return .just(.success(false))
    }
    
    static func addMovieInfoObjectToSavedItems(_ movieInfo: MovieDetailModel, _ completionHandler: (()->Void)?) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        if checkMovieInfoExistInFavourites(movieInfo.id) { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "Favourite1", in: context) else {
            return
        }
        
        let savedItems = NSManagedObject(entity: entity, insertInto: context)
        savedItems.setValue(movieInfo.title, forKeyPath: "title")
        savedItems.setValue(movieInfo.movie.poster ?? "", forKey: "poster")
        savedItems.setValue(movieInfo.movie.voteAverage, forKey: "rating")
        savedItems.setValue(movieInfo.id, forKey: "id")
        
        do {
            try context.save()
            completionHandler?()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func addMovieItem(_ movieInfo: MovieDetailModel) -> AnyPublisher<Result<Bool, Error>, Never> {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        if checkMovieInfoExistInFavourites(movieInfo.id) { return .just(.failure(LocalError.itemExist)) }
        guard let entity = NSEntityDescription.entity(forEntityName: "Favourite1", in: context) else {
            return .just(.failure(LocalError.entityNotFound))
        }
        
        let savedItems = NSManagedObject(entity: entity, insertInto: context)
        savedItems.setValue(movieInfo.title, forKeyPath: "title")
        savedItems.setValue(movieInfo.movie.poster ?? "", forKey: "poster")
        savedItems.setValue(movieInfo.movie.voteAverage, forKey: "rating")
        savedItems.setValue(movieInfo.id, forKey: "id")
        
        do {
            try context.save()
            return .just(.success(true))
        } catch let error as NSError {
            return .just(.failure(error))
        }
    }
    
    static func fetchSavedItemsMovieInfoList() -> [MovieCellViewModel] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        var fetchedMovieInfoList = [MovieCellViewModel]()
        do {
            let favouriteItems:[Favourite1] = try context.fetch(Favourite1.fetchRequest())
            
            fetchedMovieInfoList = favouriteItems.map { item in
                
                let movie = Movie.init(id: Int(item.id), title: item.title ?? "", overview: item.overview ?? "", poster: item.poster, voteAverage: item.rating, releaseDate: item.releasedate)
                return MovieCellViewModel.init(movie: movie)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchedMovieInfoList
    }
    
    static func fetchFavItems() -> AnyPublisher<Result<[MovieCellViewModel], Error>, Never> {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        var fetchedMovieInfoList = [MovieCellViewModel]()
        do {
            let favouriteItems:[Favourite1] = try context.fetch(Favourite1.fetchRequest())
            
            fetchedMovieInfoList = favouriteItems.map { item in
                
                let movie = Movie.init(id: Int(item.id), title: item.title ?? "", overview: item.overview ?? "", poster: item.poster, voteAverage: item.rating, releaseDate: item.releasedate)
                return MovieCellViewModel.init(movie: movie)
            }
            return .just(.success(fetchedMovieInfoList))
        } catch let error as NSError {
            return .just(.failure(error))
        }
    }
    
}

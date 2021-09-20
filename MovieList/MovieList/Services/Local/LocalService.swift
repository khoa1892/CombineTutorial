//
//  LocalService.swift
//  MovieList
//
//  Created by Khoa Mai on 9/20/21.
//

import Foundation
import CoreData
import Combine

class LocalService<T: NSManagedObject>: LocalServiceType {
    
    typealias Entity = T
    
    let context: NSManagedObjectContext
    init(_ context: NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext) {
        self.context = context
    }
    
    func checkItemExist(_ managedObjectId: NSManagedObjectID) -> AnyPublisher<Entity, Error> {
        guard let object = try? context.existingObject(with: managedObjectId) as? Entity else {
            return .fail(error: LocalError.itemNotExist)
        }
        return .just(object)
    }
    
    func checkItemExist(_ movieId: Int) -> AnyPublisher<Bool, Error> {
        var isExist:Bool = false
        do {
            if let favouriteItems = try context.fetch(Entity.fetchRequest()) as? [Entity] {
                
                for item in favouriteItems {
                    let id = item.value(forKey: "id") as? Int64 ?? 0
                    if movieId == id {
                        isExist = true
                        break
                    }
                }
            }
            return .just(isExist)
        } catch {
            return .fail(error: error)
        }
    }
    
    func addMovie(movieId: Int, title: String, releaseDate: String, poster: String, rating: Float) -> AnyPublisher<Entity?, Error> {
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Entity.self), in: context) else {
            return .fail(error: LocalError.entityNotFound)
        }
        let savedItem = NSManagedObject(entity: entity, insertInto: context)
        savedItem.setValue(title, forKeyPath: "title")
        savedItem.setValue(poster, forKey: "poster")
        savedItem.setValue(rating, forKey: "rating")
        savedItem.setValue(movieId, forKey: "id")
        do {
            try context.save()
            return .just(savedItem as? Entity)
        } catch let error as NSError {
            return .fail(error: error)
        }
    }
    
    func removeMovie(_ movieId: Int) -> AnyPublisher<Entity?, Error> {
        
        do {
            if let favouriteItems = try context.fetch(Entity.fetchRequest()) as? [Entity] {
                
                for item in favouriteItems {
                    let id = item.value(forKey: "id") as? Int64 ?? 0
                    if movieId == id {
                        self.context.delete(context.object(with: item.objectID))
                        break
                    }
                }
            }
            try self.context.save()
            return .just(nil)
        } catch let error {
            return .fail(error: error)
        }
    }

    func fetchMovies() -> AnyPublisher<[Entity], Error> {
        do {

            let favouriteItems = try context.fetch(Entity.fetchRequest()) as? [Entity]
            return .just(favouriteItems ?? [])
        } catch let error {
            return .fail(error: error)
        }
    }
}

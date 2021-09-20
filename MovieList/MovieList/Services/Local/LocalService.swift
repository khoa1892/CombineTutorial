//
//  LocalService.swift
//  MovieList
//
//  Created by Khoa Mai on 9/20/21.
//

import Foundation
import CoreData
import Combine

class LocalService: LocalServiceType {
    
    let context: NSManagedObjectContext
    init(_ context: NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext) {
        self.context = context
    }
    
    func checkItemExist<Entity: NSManagedObject>(_ managedObjectId: NSManagedObjectID) -> AnyPublisher<Entity, Error> {
        guard let object = try? context.existingObject(with: managedObjectId) as? Entity else {
            return .fail(error: LocalError.itemNotExist)
        }
        return .just(object)
    }
    
    func addMovie<Entity: NSManagedObject>(movieId: Int, title: String, releaseDate: String, poster: String, rating: Float) -> AnyPublisher<Entity, Error> {
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
            return .just(savedItem as! Entity)
        } catch let error as NSError {
            return .fail(error: error)
        }
    }
    
    func removeMovie<Entity: NSManagedObject>(_ managedObjectId: NSManagedObjectID) -> AnyPublisher<Entity, Error> {
        guard let object = try? context.existingObject(with: managedObjectId) as? Entity else {
            return .fail(error: LocalError.itemNotExist)
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Entity.self))
        fetchRequest.predicate = NSPredicate(format: "objectID == \(managedObjectId)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            return .just(object)
        } catch {
            return .fail(error: error)
        }
    }
    
    func fetchMovies<Entity: NSManagedObject>() -> AnyPublisher<[Entity], Error> {
        do {
            
            let favouriteItems = try context.fetch(Entity.fetchRequest()) as? [Entity]
            return .just(favouriteItems ?? [])
        } catch let error {
            return .fail(error: error)
        }
    }
}

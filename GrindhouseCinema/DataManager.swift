//
//  DataManager.swift
//  GrindhouseCinema
//
//  Created by Kai-Hong Tseng on 2019/4/25.
//  Copyright © 2019 jotshin. All rights reserved.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    func saveFetchedMovies(_ movies: [Movie])
    func fetchSavedMovies(_ completion: @escaping ([Movie]) -> Void)
}

class DataManager: DataManagerProtocol {
    func fetchSavedMovies(_ completion: @escaping ([Movie]) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.predicate = nil
        var movies: [Movie] = []
        mainQueueContext.performAndWait {
            guard let movieDataArray = try? mainQueueContext.fetch(fetchRequest) as? [MovieData] else {
                return
            }
            for movieData in movieDataArray {
                let movie = Movie(id: Int(movieData.id), title: movieData.title ?? "", posterURL: movieData.posterURL ?? "")
                movies.append(movie)
            }
            completion(movies)
        }
    }
    
    func saveFetchedMovies(_ movies: [Movie]) {
        privateQueueContext.performAndWait {
            for movie in movies {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
                let predicate = NSPredicate(format: "id == \(Int32(movie.id))")
                fetchRequest.predicate = predicate
                
                guard let movieDataArray = try? privateQueueContext.fetch(fetchRequest) as? [MovieData] else {
                    return
                }
                if movieDataArray.count > 0 {
                    return
                }
                
                guard let movieData = NSEntityDescription.insertNewObject(forEntityName: "MovieData",
                                                                                     into: privateQueueContext) as? MovieData else {
                    return
                }
                movieData.id = Int32(movie.id)
                movieData.title = movie.title
                movieData.posterURL = movie.posterURL ?? ""
                try? saveChanges()
            }
        }
        
    }
    
    let managedObjectModelName: String
    
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd"),
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            return nil
        }
        return managedObjectModel
    }()
    
    private var applicationDocumentsDirectory: URL? = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let managedObjectModel = managedObjectModel, let applicationDocumentsDirectory = applicationDocumentsDirectory else {
            return nil
        }
        var coordinator =
            NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let pathComponent = "\(managedObjectModelName).sqlite"
        let url = applicationDocumentsDirectory.appendingPathComponent(pathComponent)
        
        let store = try? coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                        configurationName: nil,
                                                        at: url,
                                                                options: nil)
        return coordinator
    }()
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        moc.name = "Main Queue Context (UI Context)"
        
        return moc
    }()
    
    lazy var privateQueueContext: NSManagedObjectContext = {
        
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = self.mainQueueContext
        moc.name = "Primary Private Queue Context"
        
        return moc
    }()
    
    required init(modelName: String) {
        managedObjectModelName = modelName
    }
    
    func saveChanges() throws {
        var error: Error?
        
        privateQueueContext.performAndWait { () -> Void in
            if self.privateQueueContext.hasChanges {
                do {
                    try self.privateQueueContext.save()
                }
                catch let saveError {
                    error = saveError
                }
            }
        }
        
        if let error = error {
            throw error
        }
        
        mainQueueContext.performAndWait { () -> Void in
            
            if self.mainQueueContext.hasChanges {
                do {
                    try self.mainQueueContext.save()
                }
                catch let saveError {
                    error = saveError
                }
            }
        }
        if let error = error {
            throw error
        }
    }
}

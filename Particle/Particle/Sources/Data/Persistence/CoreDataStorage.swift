//
//  CoreDataStorage.swift
//  Particle
//
//  Created by 이원빈 on 2024/01/12.
//

import CoreData

public final class CoreDataStorage {

    public static let shared = CoreDataStorage()

    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

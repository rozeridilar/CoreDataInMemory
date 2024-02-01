//
//  CoreDataHelpers.swift
//  
//
//  Created by Rozeri Dağtekin on 01.02.24.
//

import Foundation
import CoreData

extension NSPersistentContainer {

    static func load(modelName name: String, in bundle: Bundle) -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            return // Error cases should be considered
        }

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // Store only on memory
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { fatalError() }

        return container
    }
}

//
//  Movie+CoreDataProperties.swift
//  CoreDataInMemory
//
//  Created by Rozeri Dağtekin on 01.02.24.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var timeStamp: Date?

    static func find(in context: NSManagedObjectContext) throws -> Movie? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }

    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> Movie {
        try find(in: context).map(context.delete)
        return Movie(context: context)
    }
}

extension Movie : Identifiable {

}

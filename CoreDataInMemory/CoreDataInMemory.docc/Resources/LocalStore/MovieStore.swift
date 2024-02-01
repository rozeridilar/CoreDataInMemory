//
//  MovieStore.swift
//  
//
//  Created by Rozeri Dağtekin on 01.02.24.
//

import Foundation
import CoreData

protocol MovieStore {

    public init(storeURL: URL, bundle: Bundle = .main) throws

    public func retrieve(completion: @escaping RetrievalCompletion)

    public func insert(_ timestamp: Date, completion: @escaping InsertionCompletion)

    public func deleteCachedFeed(completion: @escaping DeletionCompletion)
}

public final class CoreDataMovieStore: MovieStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    public init(bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "Movie", in: bundle)
        context = container.newBackgroundContext()
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            do {
                if let cache = try Movie.find(in: context) {
                    completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
                } else {
                    completion(.empty)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func insert(_ timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            do {
                let movie = try Movie.newUniqueInstance(in: context)
                movie.timestamp = timestamp
                // ...

                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            do {
                try Movie.find(in: context).map(context.delete).map(context.save)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}

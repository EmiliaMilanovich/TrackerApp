//
//  TrackerCategoryStore.swift
//  TrackerApp
//
//  Created by Эмилия on 11.01.2024.
//

import UIKit
import CoreData

enum ErrorStore: Error {
    case error
}

//MARK: - TrackerCategoryStoreDelegate
protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateData(in store: TrackerCategoryStore)
}

//MARK: - TrackerCategoryStore
final class TrackerCategoryStore: NSObject {
    
    //MARK: - Properties
    weak var delegate: TrackerCategoryStoreDelegate?
    static let shared = TrackerCategoryStore()
    
    //MARK: - Private properties
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore.shared
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>! = {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let sortDescriptor = NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()
    
    //     MARK: - Initializers
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: - Methods
    func createCategory(_ category: TrackerCategory) throws {
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.title = category.title
        newCategory.trackers = NSSet(array: [])
        try context.save()
    }
    
    func fetchAllCategories() throws -> [TrackerCategoryCoreData] {
        return try context.fetch(NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData"))
    }
    
    func deleteCategory(with title: String) throws {
        let request = fetchedResultsController.fetchRequest
        request.predicate = NSPredicate(format: "%K == %@", "title", title)
        do {
            let categories = try context.fetch(request)
            if let categoryToDelete = categories.first {
                context.delete(categoryToDelete)
                try context.save()
            } else {
                throw ErrorStore.error
            }
        } catch {
            throw ErrorStore.error
        }
    }
}

// MARK: - Extension
extension TrackerCategoryStore {
    func createCategoryAndTracker(tracker: Tracker, with titleCategory: String) throws {
        guard let trackerCoreData = try trackerStore.createNewTracker(from: tracker) else {
            throw ErrorStore.error
        }
        guard let existingCategory = try fetchCategory(with: titleCategory) else {
            throw ErrorStore.error
        }
        var existingTrackers = existingCategory.trackers?.allObjects as? [TrackerCoreData] ?? []
        existingTrackers.append(trackerCoreData)
        existingCategory.trackers = NSSet(array: existingTrackers)
        try context.save()
    }
    
    func decodingCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title else {
            throw ErrorStore.error
        }
        guard let trackers = trackerCategoryCoreData.trackers else {
            throw ErrorStore.error
        }
        return TrackerCategory(title: title, trackers: trackers.compactMap { coreDataTracker -> Tracker? in
            if let coreDataTracker = coreDataTracker as? TrackerCoreData {
                return try? trackerStore.decodingTrackers(from: coreDataTracker)
            }
            return nil
        })
    }
    
    //MARK: - Private methods
    private func fetchCategory(with title: String) throws -> TrackerCategoryCoreData? {
        let request = fetchedResultsController.fetchRequest
        request.predicate = NSPredicate(format: "title == %@", title)
        return try context.fetch(request).first
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateData(in: self)
    }
}


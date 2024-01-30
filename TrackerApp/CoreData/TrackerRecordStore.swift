//
//  TrackerRecordStore.swift
//  TrackerApp
//
//  Created by Эмилия on 11.01.2024.
//

import UIKit
import CoreData

//MARK: - TrackerRecordStoreDelegate
protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateData(in store: TrackerRecordStore)
}

//MARK: - TrackerRecordStore
final class TrackerRecordStore: NSObject {
    
    //MARK: - Properties
    public static let shared = TrackerRecordStore()
    weak var delegate: TrackerRecordStoreDelegate?
    
    //MARK: - Private properties
    private let context: NSManagedObjectContext
    
    // MARK: - Initializers
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: - Methods
    func createRecord(from trackerRecord: TrackerRecord) throws {
        let newRecord = TrackerRecordCoreData(context: context)
        newRecord.id = trackerRecord.id
        newRecord.date = trackerRecord.date
        try context.save()
    }
    
    func deleteRecord(trackerRecord: TrackerRecord) throws {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date == %@", trackerRecord.id as CVarArg, trackerRecord.date as CVarArg)
        
        do {
            let records = try context.fetch(fetchRequest)
            if let recordToDelete = records.first {
                context.delete(recordToDelete)
                try context.save()
            } else {
                throw ErrorStore.error
            }
        } catch {
            throw ErrorStore.error
        }
    }
    
    func deleteAllRecordForID(for id: UUID) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let trackersRecords = try? context.fetch(request) else { return }
        trackersRecords.forEach {
            context.delete($0)
        }
        try context.save()
    }
    
    func fetchRecords() throws -> [TrackerRecord] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw ErrorStore.error
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        do {
            let trackerRecordCoreDataArray = try managedContext.fetch(fetchRequest)
            let trackerRecords = trackerRecordCoreDataArray.map { trackerRecordCoreData in
                return TrackerRecord(
                    id: trackerRecordCoreData.id ?? UUID(),
                    date: trackerRecordCoreData.date ?? Date()
                )
            }
            return trackerRecords
        } catch {
            throw ErrorStore.error
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateData(in: self)
    }
}

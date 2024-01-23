//
//  TrackerRecordStore.swift
//  TrackerApp
//
//  Created by Эмилия on 11.01.2024.
//

import UIKit
import CoreData

//MARK: - TrackerRecordStore
final class TrackerRecordStore {
    
    //MARK: - Properties
    public static let shared = TrackerRecordStore()
    
    //MARK: - Private properties
    private let context: NSManagedObjectContext

    // MARK: - Initializers
    convenience init() {
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
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerRecord.id as CVarArg)
        
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

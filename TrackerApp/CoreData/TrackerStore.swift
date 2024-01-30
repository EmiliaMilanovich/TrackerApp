//
//  TrackerStore.swift
//  TrackerApp
//
//  Created by Эмилия on 11.01.2024.
//

import UIKit
import CoreData

//MARK: - TrackerStore
final class TrackerStore {
    
    //MARK: - Properties
    public static let shared = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore.shared
    
    
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
    func createNewTracker(from tracker: Tracker) throws -> TrackerCoreData? {
        let newTracker = TrackerCoreData(context: context)
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.color = UIColorMarshalling.hexString(from: tracker.color)
        newTracker.emoji = tracker.emoji
        newTracker.shedule = self.getDataFromWeekDay(tracker.shedule)
        newTracker.isPinned = tracker.isPinned
        return newTracker
    }
    
    func fetchTrackers() throws -> [Tracker] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw ErrorStore.error
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        do {
            let trackerCoreDataArray = try managedContext.fetch(fetchRequest)
            let trackers = trackerCoreDataArray.map { trackerCoreData in
                return Tracker(
                    id: trackerCoreData.id ?? UUID(),
                    name: trackerCoreData.name ?? "",
                    color: UIColorMarshalling.color(from: trackerCoreData.color ?? ""),
                    emoji: trackerCoreData.emoji ?? "",
                    shedule: self.getWeekDayFromData(trackerCoreData.shedule ?? Data()),
                    isPinned: trackerCoreData.isPinned
                )
            }
            return trackers
        } catch {
            throw ErrorStore.error
        }
    }
    
    func updateTracker(with tracker: Tracker) throws {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        do {
            let existingTrackers = try context.fetch(fetchRequest)
            
            if let existingTracker = existingTrackers.first {
//                existingTracker.setValue(tracker.name, forKey: "name")
//                existingTracker.setValue(tracker.emoji, forKey: "emoji")
                existingTracker.id = tracker.id
                existingTracker.name = tracker.name
                existingTracker.color = UIColorMarshalling.hexString(from: tracker.color)
                existingTracker.emoji = tracker.emoji
                existingTracker.shedule = self.getDataFromWeekDay(tracker.shedule)
                existingTracker.isPinned = tracker.isPinned
                try context.save()
            } else {
                throw ErrorStore.error
            }
        } catch {
            throw ErrorStore.error
        }
    }
    
    func deleteTrackers(tracker: Tracker) throws {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        do {
            let tracker = try context.fetch(fetchRequest)
            
            if let trackerToDelete = tracker.first {
                context.delete(trackerToDelete)
                try context.save()
            } else {
                throw ErrorStore.error
            }
        } catch {
            throw ErrorStore.error
        }
    }
    
    func pinTrackerCoreData(_ tracker: Tracker) throws {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        do {
            guard let trackerCD = try? context.fetch(fetchRequest) else { return }
            if let trackerToPin = trackerCD.first {
                if trackerToPin.isPinned == false {
                    trackerToPin.isPinned = true
                } else if trackerToPin.isPinned == true {
                    trackerToPin.isPinned = false
                }
                try context.save()
            }
        } catch {
            throw ErrorStore.error
        }
    }
    
    func decodingTrackers(from trackersCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackersCoreData.id,
              let name = trackersCoreData.name,
              let color = trackersCoreData.color,
              let emoji = trackersCoreData.emoji,
              let shedule = trackersCoreData.shedule else {
            throw ErrorStore.error
        }
        
        return Tracker(
            id: id,
            name: name,
            color: UIColorMarshalling.color(from: color),
            emoji: emoji,
            shedule: self.getWeekDayFromData(shedule),
            isPinned: trackersCoreData.isPinned
        )
    }
}

//MARK: - Extension
private extension TrackerStore {
    func getDataFromWeekDay(_ array: [WeekDay]) -> Data? {
        do {
            return try JSONEncoder().encode(array)
        } catch {
            return nil
        }
    }
    
    func getWeekDayFromData(_ data: Data) -> [WeekDay] {
        do {
            return try JSONDecoder().decode([WeekDay].self, from: data)
        } catch {
            return []
        }
    }
}

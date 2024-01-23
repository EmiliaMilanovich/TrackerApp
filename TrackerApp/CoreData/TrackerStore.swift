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
                    shedule: self.getWeekDayFromData(trackerCoreData.shedule ?? Data())
                )
            }
            return trackers
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
            shedule: self.getWeekDayFromData(shedule)
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

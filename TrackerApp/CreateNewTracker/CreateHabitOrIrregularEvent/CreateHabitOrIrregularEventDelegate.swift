//
//  CreateHabitOrIrregularEventDelegate.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import Foundation

//MARK: - CreateHabitOrIrregularEventDelegate
protocol CreateHabitOrIrregularEventDelegate: AnyObject {
    func createTrackers(tracker: Tracker, category: String)
}

//
//  DataStorage.swift
//  TrackerApp
//
//  Created by Эмилия on 30.01.2024.
//

import Foundation

// MARK: - DataStorage
final class DataStorage {
    
    //MARK: - Properties
    static let shared = DataStorage()
    
    var firstLaunchApplication: Bool {
        get {
            return defaults.value(forKey: firstLaunchKey) as? Bool ?? false
        }
        set {
            defaults.set(newValue, forKey: firstLaunchKey)
        }
    }
    
    //MARK: - Private properties
    private let defaults = UserDefaults.standard
    private let firstLaunchKey = "firstLaunchApplication"
}

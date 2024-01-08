//
//  Tracker.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

struct Tracker: Hashable {
    let id = UUID()
    let name: String
    let color: UIColor
    let emoji: String
    let shedule: [WeekDay]
}

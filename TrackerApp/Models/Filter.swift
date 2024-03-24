//
//  Filter.swift
//  TrackerApp
//
//  Created by Эмилия on 26.01.2024.
//

import Foundation

enum Filter: String, CaseIterable {
    case all = "Все трекеры"
    case today = "Трекеры на сегодня"
    case completed = "Завершенные"
    case uncompleted = "Незавершенные"
}

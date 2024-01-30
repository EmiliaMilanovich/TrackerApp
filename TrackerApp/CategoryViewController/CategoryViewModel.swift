//
//  CategoryViewModel.swift
//  TrackerApp
//
//  Created by Эмилия on 23.01.2024.
//

import Foundation

//MARK: - CategoryViewModel
final class CategoryViewModel {
    
    //MARK: - Properties
    var onChange: (() -> Void)?
    
    var categories: [TrackerCategory] = [] {
        didSet {
            onChange?()
        }
    }
    
    //MARK: - Private properties
    private var trackerCategoryStore = TrackerCategoryStore.shared
    private var trackerRecordStore = TrackerRecordStore.shared
    
    // MARK: - Methods
    func fetchCategories() throws {
        do {
            let coreDataCategories = try trackerCategoryStore.fetchAllCategories()
            categories = try coreDataCategories.compactMap { coreDataCategory in
                return try trackerCategoryStore.decodingCategory(from: coreDataCategory)
            }
        } catch {
            throw ErrorStore.error
        }
    }
    
    func createCategory(_ newCategory: TrackerCategory) {
        try? trackerCategoryStore.createCategory(newCategory)
    }
    
    func countCategories() -> Int {
        categories.count
    }
    
    func selectCategory(at indexPath: IndexPath) -> String {
        return categories[indexPath.row].title
    }
    
    func removeCategory(atIndex index: Int) throws {
        let category = categories[index]
        do {
            guard let trackers = categories.first(where: { $0.title == category.title })?.trackers else { return }
            trackers.forEach { try? trackerRecordStore.deleteAllRecordForID(for: $0.id) }
            try trackerCategoryStore.deleteCategory(with: category.title)
        } catch {
            throw ErrorStore.error
        }
    }
}

// MARK: - TrackerCategoryStoreDelegate
extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func didUpdateCategory() {
        try? fetchCategories()
    }
}


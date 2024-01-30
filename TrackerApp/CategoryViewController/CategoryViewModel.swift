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
        let nameOfCategory = categories[index].title
        do {
            try trackerCategoryStore.deleteCategory(with: nameOfCategory)
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


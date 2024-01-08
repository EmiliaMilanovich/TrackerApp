//
//  CategoriesCell.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - CategoriesCell
final class CategoriesCell: UICollectionReusableView {
    
    //MARK: - Properties
    static let identifier = "CategoriesCell"
    
    //MARK: - Private properties
    private var categoriesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = Color.blackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(categoriesLabel)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Methods
    func configureHeaderCell(header: String) {
        categoriesLabel.text = header
    }
}

//MARK: - Extension
@objc extension CategoriesCell {
    private func layoutViews() {
        NSLayoutConstraint.activate([
            categoriesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            categoriesLabel.topAnchor.constraint(equalTo: topAnchor),
            categoriesLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

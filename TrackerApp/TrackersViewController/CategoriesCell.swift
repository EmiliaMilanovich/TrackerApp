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
    
    //MARK: - UI Components
    private var categoriesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = Color.blackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Methods
    func configureHeaderCell(header: String) {
        categoriesLabel.text = header
    }
    
    //MARK: - Private methods
    private func setupCell() {
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        addSubview(categoriesLabel)
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            categoriesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            categoriesLabel.topAnchor.constraint(equalTo: topAnchor),
            categoriesLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

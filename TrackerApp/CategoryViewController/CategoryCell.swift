//
//  CategoryCell.swift
//  TrackerApp
//
//  Created by Эмилия on 18.01.2024.
//

import UIKit

//MARK: - CategoryCell
final class CategoryCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoryCell"
    
    //MARK: - UI Components
    private var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.blackDay
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private var doneImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "done"))
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func configureCell(category: String) {
        categoryLabel.text = category
    }
    
    func selectedCategory() {
        doneImageView.isHidden.toggle()
    }
    
    //MARK: - Private methods
    private func setupCell() {
        contentView.backgroundColor = Color.backgroundDay
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        [categoryLabel,
         doneImageView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    private func layoutViews() {
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            doneImageView.heightAnchor.constraint(equalToConstant: 24),
            doneImageView.widthAnchor.constraint(equalToConstant: 24),
            doneImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            doneImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

//
//  HeaderCell.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - HeaderCell
final class HeaderCell: UICollectionReusableView {
    
    //MARK: - Properties
    static let identifier = "HeaderCell"
    
    //MARK: - Private properties
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = Color.blackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Methods
    func configure(header: String) {
        headerLabel.text = header
    }
    
    private func setupCell() {
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        addSubview(headerLabel)
    }
}

//MARK: - Extension
@objc extension HeaderCell {
    private func layoutViews() {
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

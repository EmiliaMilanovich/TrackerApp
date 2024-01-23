//
//  ColorsCell.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - ColorsCell
final class ColorsCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "ColorsCell"
        
    //MARK: - UI Components
    let colorLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
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
    func configure(color: UIColor, isSelected: Bool) {
        colorLabel.backgroundColor = color
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = isSelected ? 3.0 : 0.0
        contentView.layer.borderColor = colorLabel.backgroundColor?.withAlphaComponent(0.3).cgColor
    }
    
    //MARK: - Private methods
    private func setupCell() {
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        contentView.addSubview(colorLabel)
    }

    private func layoutViews() {
        NSLayoutConstraint.activate([
            colorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorLabel.heightAnchor.constraint(equalToConstant: 40),
            colorLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}

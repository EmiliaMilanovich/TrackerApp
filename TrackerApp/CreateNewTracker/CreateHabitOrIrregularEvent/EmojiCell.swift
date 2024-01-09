//
//  EmojiCell.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - EmojiCell
final class EmojiCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "EmojiCell"
    
    //MARK: - Private properties
    
    //MARK: - UI Components
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
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
    func configure(emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = isSelected ? Color.lightGray : .clear
    }
    
    //MARK: - Private methods
    private func setupCell() {
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        contentView.addSubview(emojiLabel)
    }
}

//MARK: - Extension
@objc extension EmojiCell {
    private func layoutViews() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

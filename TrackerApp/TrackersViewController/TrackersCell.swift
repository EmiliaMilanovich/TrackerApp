//
//  TrackersCell.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - TrackersCellDelegate
protocol TrackersCellDelegate: AnyObject {
    func didTapPlusButton(cell: TrackersCell)
}

//MARK: - TrackersCell
final class TrackersCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "TrackersCell"
    weak var delegate: TrackersCellDelegate?
    
    //MARK: - UI Components
    private var backgroundCellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private var emojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Color.whiteDay.withAlphaComponent(0.3)
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private var trackerNamelabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.whiteDay
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private var counterDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.blackDay
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Color.whiteDay
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapPlusButton),
            for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Methods
    func configureCell(tracker: Tracker) {
        let color = tracker.color
        setupCell()
        backgroundCellView.backgroundColor = color
        plusButton.backgroundColor = color
        trackerNamelabel.text = tracker.name
        emojiLabel.text = tracker.emoji
    }
    
    func updateRecord(days: Int, isCompleted: Bool) {
        updatePlusButton(isCompleted: isCompleted)
        updateCounterDayLabel(days: days)
    }
    
    //MARK: - Private methods
    private func updateCounterDayLabel(days: Int) {
        switch days % 10 {
        case 1:
            counterDayLabel.text = "\(days) день"
        case 2...4:
            counterDayLabel.text = "\(days) дня"
        default:
            counterDayLabel.text = "\(days) дней"
        }
    }
    
    private func updatePlusButton(isCompleted: Bool) {
        if isCompleted {
            let image = UIImage(systemName: "checkmark")
            plusButton.setImage(image, for: .normal)
            plusButton.layer.opacity = 0.3
        } else {
            let image = UIImage(systemName: "plus")
            plusButton.setImage(image, for: .normal)
            plusButton.layer.opacity = 1
        }
    }
    
    private func setupCell() {
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        [backgroundCellView,
         counterDayLabel,
         plusButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [emojiLabel,
         trackerNamelabel].forEach {
            backgroundCellView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            backgroundCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundCellView.heightAnchor.constraint(equalToConstant: 90),
            backgroundCellView.widthAnchor.constraint(equalToConstant: 167),
            
            emojiLabel.leadingAnchor.constraint(equalTo: backgroundCellView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: backgroundCellView.topAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            trackerNamelabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            trackerNamelabel.leadingAnchor.constraint(equalTo: backgroundCellView.leadingAnchor, constant: 12),
            trackerNamelabel.trailingAnchor.constraint(equalTo: backgroundCellView.trailingAnchor, constant: -12),
            trackerNamelabel.bottomAnchor.constraint(equalTo: backgroundCellView.bottomAnchor, constant: 12),
            
            counterDayLabel.leadingAnchor.constraint(equalTo: backgroundCellView.leadingAnchor, constant: 12),
            counterDayLabel.topAnchor.constraint(equalTo: backgroundCellView.bottomAnchor, constant: 16),
            counterDayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -54),
            counterDayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            plusButton.trailingAnchor.constraint(equalTo: backgroundCellView.trailingAnchor, constant: -12),
            plusButton.topAnchor.constraint(equalTo: backgroundCellView.bottomAnchor, constant: 8),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
}

//MARK: - Extension
@objc extension TrackersCell {
    private func didTapPlusButton() {
        delegate?.didTapPlusButton(cell: self)
    }
}

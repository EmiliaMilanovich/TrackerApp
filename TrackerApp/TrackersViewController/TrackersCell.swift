//
//  TrackersCell.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - TrackersCellDelegate
protocol TrackersCellDelegate: AnyObject {
    func didTapPlusButton(id: UUID)
}

//MARK: - TrackersCell
final class TrackersCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "TrackersCell"
    weak var delegate: TrackersCellDelegate?
    
    //MARK: - Private properties
    private var tracker: Tracker?
    private var trackerId: UUID?
    private let analyticsService = AnalyticsService()
    
    //MARK: - UI Components
    var backgroundCellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var pinnedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pin")
        imageView.isHidden = true
        return imageView
    }()
    
    private var emojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Color.white.withAlphaComponent(0.3)
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private var trackerNamelabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.white
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
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Methods
    func configureCell(tracker: Tracker) {
        let color = tracker.color
        backgroundCellView.backgroundColor = color
        plusButton.backgroundColor = color
        trackerNamelabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        pinnedImage.isHidden = !tracker.isPinned
        self.trackerId = tracker.id
    }
    
    func updateRecord(days: Int, isCompleted: Bool) {
        updatePlusButton(isCompleted: isCompleted)
        counterDayLabel.text = formatDaysText(forDays: days)
    }
    
    //MARK: - Private methods
    private func formatDaysText(forDays days: Int) -> String {
        let daysCounter = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "numberOfDays"), days)
        return daysCounter
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
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
    }
    
    private func addViews() {
        [backgroundCellView,
         counterDayLabel,
         plusButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [emojiLabel,
         trackerNamelabel,
         pinnedImage].forEach {
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
            
            pinnedImage.topAnchor.constraint(equalTo: backgroundCellView.topAnchor, constant: 12),
            pinnedImage.trailingAnchor.constraint(equalTo: backgroundCellView.trailingAnchor, constant: -4),
            pinnedImage.heightAnchor.constraint(equalToConstant: 24),
            pinnedImage.widthAnchor.constraint(equalToConstant: 24),
            
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
        guard let trackerId = trackerId else { return }
        delegate?.didTapPlusButton(id: trackerId)
        analyticsService.report(event: "click", params: ["screen" : "Main", "item" : "track"])
    }
}

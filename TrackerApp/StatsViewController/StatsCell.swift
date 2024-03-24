//
//  StatsCell.swift
//  TrackerApp
//
//  Created by Эмилия on 25.01.2024.
//

import UIKit

//MARK: - StatsCell
final class StatsCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "StatsCell"
    
    //MARK: - UI Components
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
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
    func configureCell(stats: Stats) {
        countLabel.text = stats.count
        titleLabel.text = stats.title
    }
    
    //MARK: - Private methods
    private func setupCell() {
        addViews()
        layoutViews()
        configureGradient()
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    private func configureGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.red.cgColor,
            UIColor.green.cgColor,
            UIColor.blue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        contentView.layer.addSublayer(gradientLayer)
    }
    
    private func addViews() {
        [countLabel,
         titleLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}


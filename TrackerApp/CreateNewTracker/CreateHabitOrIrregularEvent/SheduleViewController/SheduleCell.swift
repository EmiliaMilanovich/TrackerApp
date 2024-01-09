//
//  SheduleCell.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - SheduleCellDelegate
protocol SheduleCellDelegate: AnyObject {
    func addDay(day: WeekDay, isOn: Bool)
}

//MARK: - SheduleCell
final class SheduleCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "SheduleCell"
    weak var delegate: SheduleCellDelegate?
    
    //MARK: - Private properties
    private var day: WeekDay?
    
    //MARK: - UI Components
    private var dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.blackDay
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.onTintColor = Color.blue
        switcher.addTarget(
            self,
            action: #selector(didTapSwitcher),
            for: .valueChanged)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func configureCell(day: WeekDay, isSwitch: Bool) {
        self.day = day
        dayLabel.text = day.rawValue
        switcher.isOn = isSwitch
    }
    
    //MARK: - Private methods
    private func setupCell() {
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(switcher)
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switcher.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor)
        ])
    }
}

//MARK: - Extension
@objc extension SheduleCell {
    private func didTapSwitcher() {
        guard let day = day else {return}
        delegate?.addDay(day: day, isOn: switcher.isOn)
    }
}

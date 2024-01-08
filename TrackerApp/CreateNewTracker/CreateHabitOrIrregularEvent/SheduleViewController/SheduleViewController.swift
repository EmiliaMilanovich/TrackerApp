//
//  SheduleViewController.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - SheduleViewControllerDelegate
protocol SheduleViewControllerDelegate: AnyObject {
    func createShedule(shedule: [WeekDay])
}

//MARK: - SheduleViewController
final class SheduleViewController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: SheduleViewControllerDelegate?
    
    //MARK: - Private properties
    private var weekDayAvailable: [WeekDay] = []
    
    //MARK: - UI Components
    private var sheduleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.textColor = Color.blackDay
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = Color.backgroundDay
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Color.gray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SheduleCell.self, forCellReuseIdentifier: "SheduleCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var completedButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.blackDay
        button.layer.cornerRadius = 16
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Color.whiteDay, for: .normal)
        button.addTarget(
            self,
            action: #selector(didCompletedButton),
            for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.whiteDay
        configure()
        configureCompletedButton()
    }
    
    //MARK: - Private methods
    private func configure() {
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        view.addSubview(sheduleLabel)
        view.addSubview(tableView)
        view.addSubview(completedButton)
    }
    
    private func configureCompletedButton() {
        if weekDayAvailable.isEmpty {
            completedButton.isEnabled = false
        } else {
            completedButton.isEnabled = true
        }
    }
}

//MARK: - Extension
@objc extension SheduleViewController {
    private func layoutViews() {
        NSLayoutConstraint.activate([
            sheduleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sheduleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            tableView.topAnchor.constraint(equalTo: sheduleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: completedButton.topAnchor, constant: -39),
            completedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            completedButton.heightAnchor.constraint(equalToConstant: 60),
            completedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func didCompletedButton() {
        delegate?.createShedule(shedule: weekDayAvailable)
        dismiss(animated: true)
    }
}

//MARK: - SheduleCellDelegate
extension SheduleViewController: SheduleCellDelegate {
    func addDay(day: WeekDay, isOn: Bool) {
        if isOn {
            weekDayAvailable.append(day)
            configureCompletedButton()
        } else {
            if let index = weekDayAvailable.firstIndex(of: day) {
                weekDayAvailable.remove(at: index)
                configureCompletedButton()
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension SheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SheduleCell", for: indexPath) as? SheduleCell
        else { fatalError("Ячейка не создана") }
        let day = WeekDay.allCases[indexPath.row]
        let isSwitch = false
        cell.configureCell(day: day, isSwitch: isSwitch)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

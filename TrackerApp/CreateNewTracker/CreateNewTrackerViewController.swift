//
//  CreateNewTrackerViewController.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - CreateNewTrackerViewControllerDelegate
protocol CreateNewTrackerViewControllerDelegate: AnyObject {
    func createTrackers(tracker: Tracker, category: String)
}

//MARK: - CreateNewTrackerViewController
final class CreateNewTrackerViewController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: CreateNewTrackerViewControllerDelegate?
    
    //MARK: - Private properties
    private var createTrackerLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.textColor = Color.blackDay
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createHabitButton: UIButton = {
        let button = UIButton()
        let text = "Привычка"
        button.setTitle(text, for: .normal)
        button.setTitleColor(Color.whiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = Color.blackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(createHabit),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var createIrregularEventButton: UIButton = {
        let button = UIButton()
        let text = "Нерегулярное событие"
        button.setTitle(text, for: .normal)
        button.setTitleColor(Color.whiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = Color.blackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(createIrregularEvent),
            for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Private methods
    private func configure() {
        view.backgroundColor = Color.whiteDay
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        view.addSubview(createTrackerLabel)
        view.addSubview(createHabitButton)
        view.addSubview(createIrregularEventButton)
    }
}

//MARK: - Extension
@objc extension CreateNewTrackerViewController {
    private func layoutViews() {
        NSLayoutConstraint.activate([
            createTrackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            createTrackerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            createHabitButton.topAnchor.constraint(equalTo: createTrackerLabel.bottomAnchor, constant: 281),
            createHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createHabitButton.heightAnchor.constraint(equalToConstant: 60),
            
            createIrregularEventButton.topAnchor.constraint(equalTo: createHabitButton.bottomAnchor, constant: 16),
            createIrregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createIrregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createIrregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func createHabit() {
        let createHabitViewController = CreateHabitViewController()
        createHabitViewController.delegate = self
        present(createHabitViewController, animated: true)
    }
    
    private func createIrregularEvent() {
        let createIrregularEventViewController = CreateIrregularEventViewController()
        createIrregularEventViewController.delegate = self
        present(createIrregularEventViewController, animated: true)
    }
}

//MARK: - CreateHabitOrIrregularEventDelegate
extension CreateNewTrackerViewController: CreateHabitOrIrregularEventDelegate {
    func createTrackers(tracker: Tracker, category: String) {
        let tracker = tracker
        let category = category
        delegate?.createTrackers(tracker: tracker, category: category)
    }
}

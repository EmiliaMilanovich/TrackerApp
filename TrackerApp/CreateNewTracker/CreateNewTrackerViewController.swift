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
    
    //MARK: - UI Components
    private var createTrackerLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.textColor = Color.blackDay
        label.font = .systemFont(ofSize: 16, weight: .medium)
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
        [createTrackerLabel,
         createHabitButton,
         createIrregularEventButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
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
}

//MARK: - Extension
@objc extension CreateNewTrackerViewController {
    private func createHabit() {
        let createHabitViewController = CreateHabitOrIrregularEventViewController()
        createHabitViewController.typeOfTracker = .habit
        createHabitViewController.delegate = self
        present(createHabitViewController, animated: true)
    }
    
    private func createIrregularEvent() {
        let createIrregularEventViewController = CreateHabitOrIrregularEventViewController()
        createIrregularEventViewController.typeOfTracker = .irregularEvent
        createIrregularEventViewController.delegate = self
        present(createIrregularEventViewController, animated: true)
    }
}

//MARK: - CreateHabitOrIrregularEventDelegate
extension CreateNewTrackerViewController: CreateHabitOrIrregularEventDelegate {
    func createTrackers(tracker: Tracker, category: String) {
        delegate?.createTrackers(tracker: tracker, category: category)
    }
}

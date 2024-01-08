//
//  CreateIrregularEventViewController.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - CreateIrregularEventViewController
final class CreateIrregularEventViewController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: CreateHabitOrIrregularEventDelegate?
    
    //MARK: - Private properties
    private var shedule: [WeekDay] = []
    private var category: String = "Default Category"
    private var color: UIColor = Color.colorSelection7
    private var emoji: String = "☺️"
    
    //MARK: - UI Components
    private var createIrregularEventLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание нерегулярного события"
        label.textColor = Color.blackDay
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nameHabitTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = Color.blackDay
        textField.backgroundColor = Color.backgroundDay
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Категория", for: .normal)
        button.setTitleColor(Color.blackDay, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .leading
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = Color.backgroundDay
        button.addTarget(
            self,
            action: #selector(didTapCategoryButton),
            for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var chevronCategoryImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "chevron"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = Color.red.cgColor
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Color.red, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapCancelButton),
            for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = Color.gray
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Color.whiteDay, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapCreateButton),
            for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        updateCreateButton()
    }
    
    //MARK: - Private methods
    private func configure() {
        view.backgroundColor = Color.whiteDay
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        view.addSubview(createIrregularEventLabel)
        view.addSubview(nameHabitTextField)
        view.addSubview(categoryButton)
        view.addSubview(chevronCategoryImage)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
    }
    
    private func updateCreateButton() {
        if nameHabitTextField.text == "" {
            createButton.isEnabled = false
        } else {
            createButton.isEnabled = true
            createButton.backgroundColor = Color.blackDay
        }
    }
}

//MARK: - Extension
@objc extension CreateIrregularEventViewController {
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            createIrregularEventLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            createIrregularEventLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameHabitTextField.heightAnchor.constraint(equalToConstant: 75),
            nameHabitTextField.topAnchor.constraint(equalTo: createIrregularEventLabel.bottomAnchor, constant: 38),
            nameHabitTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameHabitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryButton.topAnchor.constraint(equalTo: nameHabitTextField.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            chevronCategoryImage.heightAnchor.constraint(equalToConstant: 24),
            chevronCategoryImage.widthAnchor.constraint(equalToConstant: 24),
            chevronCategoryImage.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            chevronCategoryImage.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func didTapCategoryButton() {
        // TODO: present CategoryViewController
    }
    
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    private func didTapCreateButton() {
        guard let trackerName = nameHabitTextField.text else { return }
        let newTracker = Tracker(
            name: trackerName,
            color: color,
            emoji: emoji,
            shedule: shedule)
        delegate?.createTrackers(tracker: newTracker, category: category)
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension CreateIrregularEventViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateCreateButton()
        return nameHabitTextField.resignFirstResponder()
    }
}

//
//  CreateHabitViewController.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - CreateHabitViewController
final class CreateHabitViewController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: CreateHabitOrIrregularEventDelegate?
    
    //MARK: - Private properties
    private var shedule: [WeekDay] = []
    private var category: String = "Default Category"
    private var color: UIColor = Color.colorSelection7
    private var emoji: String = "☺️"
    
    //MARK: - UI Components
    private var createHabitLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание привычки"
        label.textColor = Color.blackDay
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameHabitTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = Color.blackDay
        textField.backgroundColor = Color.backgroundDay
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        textField.delegate = self
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
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
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
    
    private var separatorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Color.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sheduleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Расписание", for: .normal)
        button.setTitleColor(Color.blackDay, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .leading
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = Color.backgroundDay
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.addTarget(
            self,
            action: #selector(didTapSheludeButton),
            for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var chevronSheduleImage: UIImageView = {
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
        view.addSubview(createHabitLabel)
        view.addSubview(nameHabitTextField)
        view.addSubview(categoryButton)
        view.addSubview(chevronCategoryImage)
        view.addSubview(separatorLabel)
        view.addSubview(sheduleButton)
        view.addSubview(chevronSheduleImage)
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
@objc extension CreateHabitViewController {
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            createHabitLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            createHabitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameHabitTextField.heightAnchor.constraint(equalToConstant: 75),
            nameHabitTextField.topAnchor.constraint(equalTo: createHabitLabel.bottomAnchor, constant: 38),
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
            
            separatorLabel.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            separatorLabel.heightAnchor.constraint(equalToConstant: 0.5),
            separatorLabel.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
            separatorLabel.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            
            sheduleButton.topAnchor.constraint(equalTo: separatorLabel.bottomAnchor),
            sheduleButton.heightAnchor.constraint(equalToConstant: 75),
            sheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            chevronSheduleImage.heightAnchor.constraint(equalToConstant: 24),
            chevronSheduleImage.widthAnchor.constraint(equalToConstant: 24),
            chevronSheduleImage.centerYAnchor.constraint(equalTo: sheduleButton.centerYAnchor),
            chevronSheduleImage.trailingAnchor.constraint(equalTo: sheduleButton.trailingAnchor, constant: -16),
            
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
    
    private func didTapSheludeButton() {
        let sheduleViewController = SheduleViewController()
        sheduleViewController.delegate = self
        present(sheduleViewController, animated: true)
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
extension CreateHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateCreateButton()
        return nameHabitTextField.resignFirstResponder()
    }
}

//MARK: - UITextFieldDelegate
extension CreateHabitViewController: SheduleViewControllerDelegate {
    func createShedule(shedule: [WeekDay]) {
        self.shedule = shedule
    }
}

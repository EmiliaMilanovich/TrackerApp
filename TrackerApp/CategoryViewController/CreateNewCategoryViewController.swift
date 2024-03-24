//
//  CreateNewCategoryViewController.swift
//  TrackerApp
//
//  Created by Эмилия on 17.01.2024.
//

import UIKit

//MARK: - TypeOfCategory
enum TypeOfCategory {
    case create
    case edit
}

//MARK: - CreateNewCategoryViewControllerDelegate
protocol CreateNewCategoryViewControllerDelegate: AnyObject {
    func addNewCategories(category: String)
    func reloadCategories()
}

//MARK: - CreateNewCategoryViewController
final class CreateNewCategoryViewController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: CreateNewCategoryViewControllerDelegate?
    var editingCategoryName: String?
    var typeOfCategory: TypeOfCategory?
    
    //MARK: - Private properties
    private var nameCategory: String = ""
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    //MARK: - UI Components
    private var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.textColor = Color.blackDay
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var nameCategoryTextField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Введите название категории"
        textField.textColor = Color.blackDay
        textField.backgroundColor = Color.backgroundDay
        textField.layer.cornerRadius = 16
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(Color.whiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = Color.gray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(
            self,
            action: #selector(didTapCreateCategoryButton),
            for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        editCategory()
    }
    
    //MARK: - Private methods
    private func configure() {
        view.backgroundColor = Color.whiteDay
        addViews()
        layoutViews()
    }
    
    private func editCategory() {
        if typeOfCategory == .edit {
            nameCategoryTextField.text = editingCategoryName
            categoryLabel.text = "Редактирование категории"
        }
    }
    
    private func updateCreateButton() {
        if nameCategoryTextField.text?.isEmpty == false {
            createCategoryButton.backgroundColor = Color.blackDay
            createCategoryButton.isEnabled = true
        } else {
            createCategoryButton.backgroundColor = Color.gray
            createCategoryButton.isEnabled = false
        }
    }
    
    private func addViews() {
        [categoryLabel,
         nameCategoryTextField,
         createCategoryButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            nameCategoryTextField.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 38),
            nameCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

//MARK: - Extension
@objc extension CreateNewCategoryViewController {
    func didTapCreateCategoryButton() {
        if typeOfCategory == .create {
            delegate?.addNewCategories(category: nameCategory)
            
        } else if typeOfCategory == .edit {
            guard let editingCategoryName = editingCategoryName else { return }
            trackerCategoryStore.updateCategory(categoryName: editingCategoryName, with: nameCategory)
            delegate?.reloadCategories()
        }
        dismiss(animated: true)
    }
}
//MARK: - UITextFieldDelegate
extension CreateNewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateCreateButton()
        nameCategoryTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateCreateButton()
        nameCategory = textField.text ?? ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

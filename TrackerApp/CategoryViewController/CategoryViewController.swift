//
//  CategoryViewController.swift
//  TrackerApp
//
//  Created by Эмилия on 17.01.2024.
//

import UIKit

//MARK: - CategoryViewDelegate
protocol CategoryViewControllerDelegate: AnyObject {
    func updateCategory(category: String)
}

//MARK: - CategoryViewController
final class CategoryViewController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: CategoryViewControllerDelegate?
    var viewModel: CategoryViewModel
    
    //MARK: - UiElements
    private var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = Color.blackDay
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .none
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Color.gray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CategoryCell.self,
            forCellReuseIdentifier: CategoryCell.identifier)
        return tableView
    }()
    
    private var stubView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var stubImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "error1"))
        return image
    }()
    
    private var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.numberOfLines = 2
        label.textColor = Color.blackDay
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(Color.whiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = Color.blackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(
            self,
            action: #selector(didTapAddCategoryButton),
            for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        checkEmptyCategories()
        
        viewModel.onChange = { [weak self] in
            self?.tableView.reloadData()
            self?.checkEmptyCategories()
        }
    }
    
    //MARK: - Initializers
    init() {
        viewModel = CategoryViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func configure() {
        view.backgroundColor = Color.whiteDay
        addViews()
        layoutViews()
    }
    
    private func checkEmptyCategories() {
        try? viewModel.fetchCategories()
        tableView.reloadData()
        
        if !viewModel.categories.isEmpty {
            stubView.isHidden = true
            tableView.isHidden = false
        } else {
            stubView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    private func addViews() {
        [categoryLabel,
         addCategoryButton,
         tableView,
         stubView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [stubImage,
         stubLabel].forEach {
            stubView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            tableView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -38),
            stubView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
            stubView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stubView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stubView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor),
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

@objc extension CategoryViewController {
    func didTapAddCategoryButton() {
        let createNewCategoryViewController = CreateNewCategoryViewController()
        createNewCategoryViewController.delegate = self
        present(createNewCategoryViewController, animated: true)
    }
}

//MARK: - NewCategoryViewControllerDelegate
extension CategoryViewController: CreateNewCategoryViewControllerDelegate {
    func addNewCategories(category: String) {
        if !viewModel.categories.contains(where: { $0.title == category }) {
            let newCategory = TrackerCategory(title: category, trackers: [])
            viewModel.createCategory(newCategory)
            checkEmptyCategories()
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else { return }
        cell.selectedCategory()
        
        guard let delegate = delegate else { return }
        let category = viewModel.selectCategory(at: indexPath)
        delegate.updateCategory(category: category)
        tableView.deselectRow(at: indexPath, animated: false)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.countCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryCell.identifier,
            for: indexPath
        ) as? CategoryCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.layer.masksToBounds = true
        
        if viewModel.countCategories() == 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if indexPath.row == viewModel.countCategories() - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            cell.layer.cornerRadius = 0
        }
        
        let category = viewModel.selectCategory(at: indexPath)
        cell.configureCell(category: category)
        return cell
    }
}

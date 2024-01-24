//
//  TrackersViewController.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - TrackersViewController
final class TrackersViewController: UIViewController {
    
    //MARK: - Private properties
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    
    //MARK: - UI Components
    private var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.isTranslucent = false
        return navBar
    }()
    
    private lazy var addNewTrackerButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "plus")!,
            target: self,
            action: #selector(addNewTracker))
        button.tintColor = Color.blackDay
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.calendar.firstWeekday = 2
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(
            self,
            action: #selector(dateChanged),
            for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.placeholder = "Поиск"
        textField.borderStyle = .none
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Color.colorSearchField
        textField.textColor = Color.blackDay
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        return textField
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
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var collectionViewTrackers: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            CategoriesCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CategoriesCell.identifier)
        collectionView.register(
            TrackersCell.self,
            forCellWithReuseIdentifier: TrackersCell.identifier)
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        try? fetchCategories()
        configure()
        reloadVisibleCategories()
        try? fetchRecord()
    }
    
    //MARK: - Private methods
    private func checkEmptyCategories() {
        if !visibleCategories.isEmpty {
            stubView.isHidden = true
            collectionViewTrackers.isHidden = false
        } else {
            stubView.isHidden = false
            collectionViewTrackers.isHidden = true
        }
    }
    
    private func configure() {
        view.backgroundColor = Color.whiteDay
        addViews()
        layoutViews()
    }
    
    private func configureNavBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addNewTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationBar.topItem?.title = "Трекеры"
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
    }
    
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: datePicker.date)
        let filterText = (searchTextField.text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.shedule.contains { weekDay in
                    weekDay.numberValue == filterWeekday
                } == true
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(
                title: category.title,
                trackers: trackers)
        }
        
        checkEmptyCategories()
        collectionViewTrackers.reloadData()
    }
    
    private func addViews() {
        view.addSubview(navigationBar)
        configureNavBar()
        
        [searchTextField,
         stubView,
         collectionViewTrackers].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [stubLabel,
         stubImage].forEach {
            stubView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            collectionViewTrackers.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 34),
            collectionViewTrackers.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewTrackers.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionViewTrackers.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stubView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            stubView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stubView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stubView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.topAnchor.constraint(equalTo: stubView.topAnchor, constant: 220),
            stubImage.centerXAnchor.constraint(equalTo: stubView.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: stubView.centerXAnchor)
        ])
    }
}

//MARK: - Extension
@objc extension TrackersViewController {
    private func addNewTracker() {
        let createNewTrackerViewController = CreateNewTrackerViewController()
        createNewTrackerViewController.delegate = self
        present(createNewTrackerViewController, animated: true)
    }
    
    private func dateChanged() {
        currentDate = datePicker.date
        collectionViewTrackers.reloadData()
        reloadVisibleCategories()
        dismiss(animated: true)
    }
}

//MARK: - Core Data extension
extension TrackersViewController {
    private func fetchCategories() throws {
        do {
            let coreDataCategories = try trackerCategoryStore.fetchAllCategories()
            categories = try coreDataCategories.compactMap { coreDataCategory in
                return try trackerCategoryStore.decodingCategory(from: coreDataCategory)
            }
        } catch {
            throw ErrorStore.error
        }
    }
    
    private func fetchRecord() throws {
        do {
            completedTrackers = try trackerRecordStore.fetchRecords()
        } catch {
            throw ErrorStore.error
        }
    }
    
    private func createRecord(record: TrackerRecord) throws {
        do {
            try trackerRecordStore.createRecord(from: record)
            try fetchRecord()
        } catch {
            throw ErrorStore.error
        }
    }
    
    private func deleteRecord(atIndex index: Int) throws {
        let record = completedTrackers[index]
        do {
            try trackerRecordStore.deleteRecord(trackerRecord: record)
            try fetchRecord()
        } catch {
            throw ErrorStore.error
        }
    }
}

//MARK: - CreateNewTrackerViewControllerDelegate
extension TrackersViewController: CreateNewTrackerViewControllerDelegate {
    func createTrackers(tracker: Tracker, category: String) {
        try? trackerCategoryStore.createCategoryAndTracker(tracker: tracker, with: category)
        try? fetchCategories()
        checkEmptyCategories()
        reloadVisibleCategories()
        collectionViewTrackers.reloadData()
    }
}

//MARK: - TrackersCellDelegate
extension TrackersViewController: TrackersCellDelegate {
    func didTapPlusButton(id: UUID) {
        if currentDate > Date() { return } else {
            if let index = completedTrackers.firstIndex(where: { $0.date == currentDate && $0.id == id }) {
                try? deleteRecord(atIndex: index)
            } else {
                let record = TrackerRecord(id: id, date: currentDate)
                try? createRecord(record: record)
            }
            try? fetchRecord()
            collectionViewTrackers.reloadData()
        }
    }
}

//MARK: - UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        reloadVisibleCategories()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        reloadVisibleCategories()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = visibleCategories[section].trackers
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCell.identifier, for: indexPath) as? TrackersCell else { return UICollectionViewCell() }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let daysCount = completedTrackers.filter { $0.id == tracker.id }.count
        let isCompleted = completedTrackers.contains { $0.id == tracker.id && $0.date == currentDate }
        cell.delegate = self
        cell.prepareForReuse()
        cell.configureCell(tracker: tracker)
        cell.updateRecord(days: daysCount, isCompleted: isCompleted)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CategoriesCell.identifier,
            for: indexPath
        ) as? CategoriesCell else {
            return UICollectionReusableView()
        }
        view.configureHeaderCell(header: visibleCategories[indexPath.section].title)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 25)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width / 2) - 16 - 4.5, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
}

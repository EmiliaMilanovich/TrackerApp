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
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    
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
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var stubView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stubImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "error1"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавьте первый трекер"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionViewTrackers: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            TrackersCell.self,
            forCellWithReuseIdentifier: TrackersCell.identifier)
        collectionView.register(
            CategoriesCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CategoriesCell.identifier)
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        reloadVisibleCategories()
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
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: datePicker)]
        navigationBar.topItem?.title = "Трекеры"
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
    }
    
    private func addViews() {
        view.addSubview(navigationBar)
        configureNavBar()
        view.addSubview(searchTextField)
        view.addSubview(stubView)
        stubView.addSubview(stubLabel)
        stubView.addSubview(stubImage)
        view.addSubview(collectionViewTrackers)
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
        reloadVisibleCategories()
        dismiss(animated: true)
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
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

//MARK: - CreateNewTrackerViewControllerDelegate
extension TrackersViewController: CreateNewTrackerViewControllerDelegate {
    func createTrackers(tracker: Tracker, category: String) {
        if let index = categories.firstIndex(where: { $0.title == category }) {
            let updatedTrackers = categories[index].trackers + [tracker]
            let updatedCategory = TrackerCategory(title: category, trackers: updatedTrackers)
            categories[index] = updatedCategory
        } else {
            let newTrackerCategory = TrackerCategory(title: category, trackers: [tracker])
            categories.append(newTrackerCategory)
        }
        reloadVisibleCategories()
    }
}

//MARK: - TrackersCellDelegate
extension TrackersViewController: TrackersCellDelegate {
    func didTapPlusButton(cell: TrackersCell) {
        guard let indexPath: IndexPath = collectionViewTrackers.indexPath(for: cell) else { return }
        let id = visibleCategories[indexPath.section].trackers[indexPath.row].id
        let trackerRecord = TrackerRecord(id: id, date: currentDate)
        var daysCount = completedTrackers.filter { $0.id == id }.count
        
        if currentDate <= Date() {
            if !completedTrackers.contains(where: { $0.id == id && $0.date == currentDate }) {
                completedTrackers.insert(trackerRecord)
                daysCount += 1
                cell.updateRecord(days: daysCount, isCompleted: true)
            } else {
                completedTrackers.remove(trackerRecord)
                daysCount -= 1
                cell.updateRecord(days: daysCount, isCompleted: false)
            }
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
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2) - 16 - 4.5, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}

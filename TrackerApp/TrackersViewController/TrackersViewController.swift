//
//  TrackersViewController.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - TrackersViewController
final class TrackersViewController: UIViewController {
    
    //MARK: - Properties
    var selectedFilter: Filter?
    
    //MARK: - Private properties
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private let trackerStore = TrackerStore.shared
    private let analyticsService = AnalyticsService.shared
    
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
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: 50, right: .zero)
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Color.whiteDay
        collectionView.register(
            CategoriesCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CategoriesCell.identifier)
        collectionView.register(
            TrackersCell.self,
            forCellWithReuseIdentifier: TrackersCell.identifier)
        return collectionView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        let textTitle = NSLocalizedString("filterButton", comment: "filterButton")
        button.setTitle(textTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(Color.white, for: .normal)
        button.backgroundColor = Color.blue
        button.layer.cornerRadius = 16
        button.addTarget(
            self, action:
                #selector(didTapFilterButton),
            for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analyticsService.report(event: "open", params: ["screen": "Main"])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyticsService.report(event: "close", params: ["screen" : "Main"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? fetchCategories()
        try? fetchRecord()
        configure()
        reloadPinTrackers()
        reloadVisibleCategories()
        collectionViewTrackers.reloadData()
    }
    
    //MARK: - Private methods
    private func checkEmptyCategories() {
        if !visibleCategories.isEmpty {
            stubView.isHidden = true
            collectionViewTrackers.isHidden = false
            filterButton.isHidden = false
        } else {
            stubView.isHidden = false
            filterButton.isHidden = true
            collectionViewTrackers.isHidden = true
        }
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
            
            if trackers.isEmpty { return nil }
            return TrackerCategory(title: category.title, trackers: trackers)
        }
        
        if selectedFilter == .completed {
            filteringTrackers(completed: true)
        } else if selectedFilter == .uncompleted {
            filteringTrackers(completed: false)
        }
        
        configureStubView()
        checkEmptyCategories()
        collectionViewTrackers.reloadData()
    }
    
    private func reloadPinTrackers() {
        categories = []
        var pinnedTrackers: [Tracker] = []
        
        for category in trackerCategoryStore.trackerCategory {
            let trackers = category.trackers
            let pinnedTrackersForCategory = trackers.filter { $0.isPinned }
            let unpinnedTrackers = trackers.filter { !$0.isPinned }
            pinnedTrackers.append(contentsOf: pinnedTrackersForCategory)
            
            if !unpinnedTrackers.isEmpty {
                let unpinnedCategory = TrackerCategory(title: category.title, trackers: unpinnedTrackers)
                categories.append(unpinnedCategory)
            }
        }
        
        if !pinnedTrackers.isEmpty {
            let pinnedCategory = TrackerCategory(
                title: NSLocalizedString("pinnedTrackers", comment: "Pinned"),
                trackers: pinnedTrackers)
            categories.insert(pinnedCategory, at: 0)
        }
    }
    
    private func filteringTrackers(completed: Bool) {
        visibleCategories = visibleCategories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                completed ? isTrackersRecordCompletedToday(id: tracker.id, date: datePicker.date)
                : !isTrackersRecordCompletedToday(id: tracker.id, date: datePicker.date)
            }
            if trackers.isEmpty { return nil }
            return TrackerCategory(title: category.title, trackers: trackers)
        }
    }
    
    private func isTrackersRecordCompletedToday(id: UUID, date: Date) -> Bool {
        completedTrackers.contains { record in
            let isSameDay = Calendar.current.isDate(record.date, inSameDayAs: date)
            return record.id == id && isSameDay
        }
    }
    
    private func configureStubView() {
        let searchText = searchTextField.text ?? ""
        if visibleCategories.isEmpty && !categories.isEmpty || !searchText.isEmpty{
            stubLabel.text = NSLocalizedString("searchErrorStub", comment: "searchErrorStub")
            stubImage.image = UIImage(named: "error2")
        } else {
            stubLabel.text = NSLocalizedString("emptyErrorStub", comment: "emptyErrorStub")
            stubImage.image = UIImage(named: "error1")
        }
    }
    
    private func configure() {
        view.backgroundColor = Color.whiteDay
        addViews()
        layoutViews()
        configureNavBar()
    }
    
    private func configureNavBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addNewTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationBar.topItem?.title = NSLocalizedString("trackerTitle", comment: "trackerTitle")
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
    }
    
    private func addViews() {
        view.addSubview(navigationBar)
        
        [searchTextField,
         stubView,
         collectionViewTrackers,
         filterButton].forEach {
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
            datePicker.widthAnchor.constraint(equalToConstant: 110),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
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
            stubLabel.centerXAnchor.constraint(equalTo: stubView.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//MARK: - objc extension
@objc extension TrackersViewController {
    private func addNewTracker() {
        let createNewTrackerViewController = CreateNewTrackerViewController()
        createNewTrackerViewController.delegate = self
        analyticsService.report(event: "click", params: ["screen" : "Main", "item" : "add_track"])
        present(createNewTrackerViewController, animated: true)
    }
    
    private func dateChanged() {
        currentDate = datePicker.date
        reloadPinTrackers()
        reloadVisibleCategories()
        dismiss(animated: true)
    }
    
    private func didTapFilterButton() {
        let filtersViewController = FiltersViewController()
        filtersViewController.delegate = self
        filtersViewController.selectedFilter = selectedFilter
        analyticsService.report(event: "click", params: ["screen" : "Main", "item" : "filter"])
        present(filtersViewController, animated: true)
    }
}

//MARK: - Core Data
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
    
    private func deleteTrackerInCategory(atIndex index: IndexPath) throws {
        let tracker = visibleCategories[index.section].trackers[index.row]
        do {
            try trackerStore.deleteTrackers(tracker: tracker)
            try trackerRecordStore.deleteAllRecordForID(for: tracker.id)
            try fetchCategories()
            reloadPinTrackers()
            reloadVisibleCategories()
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
    
    private func pinTracker(_ tracker: Tracker) throws {
        do {
            try trackerStore.pinTrackerCoreData(tracker)
            try? fetchCategories()
            reloadPinTrackers()
            reloadVisibleCategories()
        } catch {
            throw ErrorStore.error
        }
    }
}

//MARK: - FiltersViewControllerDelegate
extension TrackersViewController: FiltersViewControllerDelegate {
    func filterSelected(filter: Filter) {
        selectedFilter = filter
        searchTextField.text = ""
        switch filter {
        case .all:
            filterButton.setTitleColor(Color.whiteDay, for: .normal)
        case .today:
            datePicker.setDate(Date(), animated: false)
            currentDate = datePicker.date
            filterButton.setTitleColor(Color.whiteDay, for: .normal)
        case .completed:
            filterButton.setTitleColor(Color.red, for: .normal)
        case .uncompleted:
            filterButton.setTitleColor(Color.red, for: .normal)
        }
        reloadVisibleCategories()
    }
}

// MARK: - Edit Tracker
extension TrackersViewController {
    func trackerUpdate(_ tracker: Tracker, category: String) {
        try? trackerStore.updateTracker(with: tracker)
        try? fetchCategories()
        reloadPinTrackers()
        reloadVisibleCategories()
    }
    
    private func editingTrackers(category: TrackerCategory, tracker: Tracker) {
        let daysCount = completedTrackers.filter { $0.id == tracker.id }.count
        let createHabitViewController = CreateHabitOrIrregularEventViewController()
        createHabitViewController.typeOfTracker = .edit
        createHabitViewController.delegate = self
        createHabitViewController.daysCount = daysCount
        createHabitViewController.editCategory = category.title
        createHabitViewController.editTracker = tracker
        present(createHabitViewController, animated: true)
    }
}

//MARK: - CreateNewTrackerViewControllerDelegate, CreateHabitOrIrregularEventDelegate
extension TrackersViewController: CreateNewTrackerViewControllerDelegate, CreateHabitOrIrregularEventDelegate {
    func createTrackers(tracker: Tracker, category: String) {
        try? trackerCategoryStore.createCategoryAndTracker(tracker: tracker, with: category)
        try? fetchCategories()
        checkEmptyCategories()
        reloadVisibleCategories()
        collectionViewTrackers.reloadData()
    }
    
    func updateTracker(tracker: Tracker, category: String) {
        try? trackerStore.updateTracker(with: tracker)
        try? fetchCategories()
        reloadPinTrackers()
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
            reloadPinTrackers()
            reloadVisibleCategories()
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

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let trackers = visibleCategories[section].trackers
        return trackers.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCell.identifier,
            for: indexPath
        ) as? TrackersCell else {
            return UICollectionViewCell()
        }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let daysCount = completedTrackers.filter { $0.id == tracker.id }.count
        let isCompleted = completedTrackers.contains { $0.id == tracker.id && $0.date == currentDate }
        cell.delegate = self
        cell.prepareForReuse()
        cell.configureCell(tracker: tracker)
        cell.updateRecord(days: daysCount, isCompleted: isCompleted)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = collectionView.cellForItem(at: indexPath) as? TrackersCell else { return nil }
        
        let view = cell.backgroundCellView
        return UITargetedPreview(view: view)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = collectionView.cellForItem(at: indexPath) as? TrackersCell else { return nil }
        
        let view = cell.backgroundCellView
        return UITargetedPreview(view: view)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let category = visibleCategories[indexPath.section]
        let unpinTracker = NSLocalizedString("unpinTracker", comment: "unpinTracker")
        let pinTracker = NSLocalizedString("pinTracker", comment: "pinTracker")
        let titleTextIsPinned = tracker.isPinned ? unpinTracker : pinTracker
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions in
            
            let pinTracker = UIAction(title: titleTextIsPinned) { [weak self] _ in
                guard let self = self else { return }
                try? self.pinTracker(tracker)
            }
            
            let editTracker = UIAction(
                title: NSLocalizedString("editTracker", comment: "editTracker")) { [weak self] _ in
                    guard let self = self else { return }
                    self.editingTrackers(category: category, tracker: tracker)
                    self.analyticsService.report(event: "click", params: ["screen" : "Main", "item" : "edit"])
                }
            
            let deleteTracker = UIAction(
                title: NSLocalizedString("deleteTracker", comment: "deleteTracker"),
                image: nil,
                identifier: nil,
                discoverabilityTitle: nil,
                attributes: .destructive) {[weak self] _ in
                    guard let self = self else { return }
                    self.showDeleteAlert(indexPath: indexPath)
                    self.analyticsService.report(event: "click", params: ["screen" : "Main", "item" : "delete"])
                }
            return  UIMenu(children: [pinTracker, editTracker, deleteTracker])
        }
        return configuration
    }
}

// MARK: - Alert Action
extension TrackersViewController {
    private func showDeleteAlert(indexPath: IndexPath) {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("showDeleteAlert", comment: "showDeleteAlert"),
            preferredStyle: .actionSheet
        )
        let deleteButton = UIAlertAction(
            title: NSLocalizedString("deleteTracker", comment: "deleteTracker"),
            style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                do {
                    try self.deleteTrackerInCategory(atIndex: indexPath)
                } catch {
                    print("Error deleting tracker: \(error)")
                }
            }
        let cencelButton = UIAlertAction(
            title: NSLocalizedString("cancel", comment: "cancel"),
            style: .cancel
        )
        alert.addAction(deleteButton)
        alert.addAction(cencelButton)
        self.present(alert, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 25)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: (collectionView.bounds.width / 2) - 16 - 4.5, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        16
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        9
    }
}

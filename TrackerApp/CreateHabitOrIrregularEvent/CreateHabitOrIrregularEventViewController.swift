//
//  CreateHabitOrIrregularEventViewController.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - TypeOfTracker
enum TypeOfTracker {
    case habit
    case irregularEvent
    case edit
}

//MARK: - CreateHabitOrIrregularEventDelegate
protocol CreateHabitOrIrregularEventDelegate: AnyObject {
    func createTrackers(tracker: Tracker, category: String)
    func updateTracker(tracker: Tracker, category: String)
}

//MARK: - CreateHabitOrIrregularEventViewController
final class CreateHabitOrIrregularEventViewController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: CreateHabitOrIrregularEventDelegate?
    
    var typeOfTracker: TypeOfTracker?
    var editCategory: String?
    var editTracker: Tracker?
    var daysCount: Int?
    
    //MARK: - Private properties
    private let trackerStore = TrackerStore.shared
    
    private var category: String = ""
    private var emoji: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private var color: [UIColor] = [
        Color.colorSelection1, Color.colorSelection2, Color.colorSelection3, Color.colorSelection4,
        Color.colorSelection5, Color.colorSelection6, Color.colorSelection7, Color.colorSelection8,
        Color.colorSelection9, Color.colorSelection10, Color.colorSelection11, Color.colorSelection12,
        Color.colorSelection13, Color.colorSelection14, Color.colorSelection15, Color.colorSelection16,
        Color.colorSelection17, Color.colorSelection18
    ]
    
    private var shedule: [WeekDay] = []
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    private var selectedEmojiIndex: Int?
    private var selectedColorIndex: Int?
    
    //MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private var createHabitLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.blackDay
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var completedDaysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.isHidden = true
        label.textAlignment = .center
        label.isHidden = true
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
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Категория", for: .normal)
        button.setTitleColor(Color.blackDay, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .leading
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = Color.backgroundDay
        button.addTarget(
            self,
            action: #selector(didTapCategoryButton),
            for: .touchUpInside)
        return button
    }()
    
    private var selectedCategoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.gray
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private var chevronCategoryImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "chevron"))
        return image
    }()
    
    private var separatorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Color.gray
        return label
    }()
    
    private lazy var sheduleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Расписание", for: .normal)
        button.setTitleColor(Color.blackDay, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
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
        return button
    }()
    
    private var selectedSheduleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.gray
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private var chevronSheduleImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "chevron"))
        return image
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(
            HeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderCell.identifier)
        collectionView.register(
            EmojiCell.self,
            forCellWithReuseIdentifier: EmojiCell.identifier)
        return collectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(
            HeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderCell.identifier)
        collectionView.register(
            ColorsCell.self,
            forCellWithReuseIdentifier: ColorsCell.identifier)
        return collectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.backgroundColor = Color.whiteDay
        button.layer.borderColor = Color.red.cgColor
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Color.red, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapCancelButton),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = Color.gray
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Color.whiteDay, for: .normal)
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
        createHabitOrIrregularEvent()
        layoutViews()
    }
    
    private func updateCreateButton() {
        if (nameHabitTextField.text?.isEmpty == false) &&
            (category.isEmpty == false) &&
            (shedule.isEmpty == false) &&
            (selectedEmoji != nil) &&
            (selectedColor != nil) {
            createButton.isEnabled = true
            createButton.backgroundColor = Color.blackDay
            
        } else {
            createButton.isEnabled = false
        }
    }
    
    private func createHabitOrIrregularEvent() {
        switch typeOfTracker {
        case .habit:
            createHabitLabel.text = "Новая привычка"
            categoryButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            createButton.addTarget(
                self,
                action: #selector(didTapCreateButton),
                for: .touchUpInside)
        case .irregularEvent:
            createHabitLabel.text = "Новое нерегулярное событие"
            shedule = WeekDay.allCases
            createButton.addTarget(
                self,
                action: #selector(didTapCreateButton),
                for: .touchUpInside)
        case .edit:
            guard let daysCount = daysCount else { return }
            guard let editTracker = editTracker else { return }
            guard let editCategory = editCategory else { return }
            createHabitLabel.text = "Редактирование привычки"
            completedDaysLabel.isHidden = false
            categoryButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            completedDaysLabel.text = formatDaysText(forDays: daysCount)
            createButton.setTitle("Сохранить", for: .normal)
            createButton.addTarget(
                self,
                action: #selector(didTapSaveButton),
                for: .touchUpInside)
            nameHabitTextField.text = editTracker.name
            updateCategory(category: editCategory)
            createShedule(shedule: editTracker.shedule)
            selectedEmoji = editTracker.emoji
            selectedEmojiIndex = emoji.firstIndex(of: selectedEmoji ?? "")
            selectedColor = editTracker.color
            selectedColorIndex = color.firstIndex(of: selectedColor ?? Color.colorSelection1)
        case .none: break
        }
    }
    
    private func formatDaysText(forDays days: Int) -> String {
        let daysCounter = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "numberOfDays"), days)
        return daysCounter
    }
    
    private func addViews() {
        [createHabitLabel,
         scrollView,
         cancelButton,
         createButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.addSubview(contentView)
        
        [completedDaysLabel,
         nameHabitTextField,
         categoryButton,
         selectedCategoryLabel,
         chevronCategoryImage,
         emojiCollectionView,
         colorCollectionView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if typeOfTracker == .habit || typeOfTracker == .edit {
            [separatorLabel,
             sheduleButton,
             selectedSheduleLabel,
             chevronSheduleImage].forEach {
                contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }
    
    private func layoutViews() {
        let nameHabitTextFieldConstant: CGFloat = editTracker == nil ? 0 : 78
        let contentHeightAnchor: CGFloat = editTracker == nil ? 741 : 843
        NSLayoutConstraint.activate([
            createHabitLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            createHabitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: createHabitLabel.bottomAnchor, constant: 38),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -76),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: contentHeightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            completedDaysLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            completedDaysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completedDaysLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completedDaysLabel.heightAnchor.constraint(equalToConstant: 38),
            
            nameHabitTextField.heightAnchor.constraint(equalToConstant: 75),
            nameHabitTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: nameHabitTextFieldConstant),
            nameHabitTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameHabitTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryButton.topAnchor.constraint(equalTo: nameHabitTextField.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            selectedCategoryLabel.heightAnchor.constraint(equalToConstant: 22),
            selectedCategoryLabel.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
            selectedCategoryLabel.topAnchor.constraint(equalTo: categoryButton.topAnchor, constant: 43),
            selectedCategoryLabel.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -56),
            
            chevronCategoryImage.heightAnchor.constraint(equalToConstant: 24),
            chevronCategoryImage.widthAnchor.constraint(equalToConstant: 24),
            chevronCategoryImage.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            chevronCategoryImage.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        if typeOfTracker == .habit || typeOfTracker == .edit {
            NSLayoutConstraint.activate([
                separatorLabel.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
                separatorLabel.heightAnchor.constraint(equalToConstant: 0.5),
                separatorLabel.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
                separatorLabel.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
                
                sheduleButton.topAnchor.constraint(equalTo: separatorLabel.bottomAnchor),
                sheduleButton.heightAnchor.constraint(equalToConstant: 75),
                sheduleButton.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor),
                sheduleButton.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor),
                
                selectedSheduleLabel.heightAnchor.constraint(equalToConstant: 22),
                selectedSheduleLabel.leadingAnchor.constraint(equalTo: sheduleButton.leadingAnchor, constant: 16),
                selectedSheduleLabel.topAnchor.constraint(equalTo: sheduleButton.topAnchor, constant: 43),
                selectedSheduleLabel.trailingAnchor.constraint(equalTo: sheduleButton.trailingAnchor, constant: -56),
                
                chevronSheduleImage.heightAnchor.constraint(equalToConstant: 24),
                chevronSheduleImage.widthAnchor.constraint(equalToConstant: 24),
                chevronSheduleImage.centerYAnchor.constraint(equalTo: sheduleButton.centerYAnchor),
                chevronSheduleImage.trailingAnchor.constraint(equalTo: sheduleButton.trailingAnchor, constant: -16),
                
                emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                emojiCollectionView.topAnchor.constraint(equalTo: sheduleButton.bottomAnchor, constant: 32),
                emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
                
                colorCollectionView.leadingAnchor.constraint(equalTo: emojiCollectionView.leadingAnchor),
                colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
                colorCollectionView.trailingAnchor.constraint(equalTo: emojiCollectionView.trailingAnchor),
                colorCollectionView.heightAnchor.constraint(equalToConstant: 222)
            ])
        } else if typeOfTracker == .irregularEvent {
            NSLayoutConstraint.activate([
                emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                emojiCollectionView.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 32),
                emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
                
                colorCollectionView.leadingAnchor.constraint(equalTo: emojiCollectionView.leadingAnchor),
                colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
                colorCollectionView.trailingAnchor.constraint(equalTo: emojiCollectionView.trailingAnchor),
                colorCollectionView.heightAnchor.constraint(equalToConstant: 222)
            ])
        }
    }
}

//MARK: - Extension
@objc extension CreateHabitOrIrregularEventViewController {
    private func didTapCategoryButton() {
        let categoryViewController = CategoryViewController()
        categoryViewController.delegate = self
        present(categoryViewController, animated: true)
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
            id: UUID(),
            name: trackerName,
            color: selectedColor ?? Color.colorSelection1,
            emoji: selectedEmoji ?? "",
            shedule: shedule,
            isPinned: false)
        delegate?.createTrackers(tracker: newTracker, category: category)
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    private func didTapSaveButton() {
        guard let editTracker = editTracker else { return }
        guard let trackerName = nameHabitTextField.text else { return }
        
        let newTracker = Tracker(
            id: editTracker.id,
            name: trackerName,
            color: selectedColor ?? Color.colorSelection1,
            emoji: selectedEmoji ?? "",
            shedule: shedule,
            isPinned: editTracker.isPinned)
        delegate?.updateTracker(tracker: newTracker, category: category)
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension CreateHabitOrIrregularEventViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateCreateButton()
        nameHabitTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateCreateButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: - SheduleViewControllerDelegate
extension CreateHabitOrIrregularEventViewController: SheduleViewControllerDelegate {
    func createShedule(shedule: [WeekDay]) {
        if !shedule.isEmpty {
            if shedule.count == 7 {
                selectedSheduleLabel.text = "Каждый день"
            } else {
                let sortedSchedule = shedule.sorted { (firstDay, secondDay) -> Bool in
                    return firstDay.rawValue < secondDay.rawValue
                }
                let filteredAndSortedSchedule = WeekDay.allCases.filter { sortedSchedule.contains($0) }
                selectedSheduleLabel.text = filteredAndSortedSchedule.map { $0.shortName }.joined(separator: ", ")
            }
        }
        self.shedule = shedule
        updateCreateButton()
    }
}

//MARK: - CategoryViewControllerDelegate
extension CreateHabitOrIrregularEventViewController: CategoryViewControllerDelegate {
    func updateCategory(category: String) {
        self.category = category
        selectedCategoryLabel.text = category
        updateCreateButton()
    }
}

//MARK: - SheduleViewControllerDelegate
extension CreateHabitOrIrregularEventViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emoji.count
        } else if collectionView == colorCollectionView {
            return color.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            if collectionView.cellForItem(at: indexPath) is EmojiCell {
                selectedEmojiIndex = indexPath.item
                self.selectedEmoji = emoji[indexPath.item]
                emojiCollectionView.reloadData()
                
            }
        } else if collectionView == colorCollectionView {
            if collectionView.cellForItem(at: indexPath) is ColorsCell {
                selectedColorIndex = indexPath.item
                self.selectedColor = color[indexPath.item]
                colorCollectionView.reloadData()
            }
        }
        updateCreateButton()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if collectionView == emojiCollectionView {
            guard let emojiCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCell.identifier,
                for: indexPath
            ) as? EmojiCell else {
                return UICollectionViewCell()
            }
            let emoji = emoji[indexPath.row]
            emojiCell.configure(emoji: emoji, isSelected: indexPath.item == selectedEmojiIndex)
            return emojiCell
            
        } else if collectionView == colorCollectionView {
            guard let colorCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorsCell.identifier,
                for: indexPath
            ) as? ColorsCell else {
                return UICollectionViewCell()
            }
            let color = color[indexPath.row]
            colorCell.configure(color: color, isSelected: indexPath.item == selectedColorIndex)
            return colorCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderCell.identifier,
            for: indexPath
        ) as? HeaderCell else {
            return UICollectionReusableView()
        }
        if collectionView == emojiCollectionView {
            view.configure(header: "Emoji")
        } else {
            view.configure(header: "Цвет")
        }
        return view
    }
}

extension CreateHabitOrIrregularEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 25, left: 20, bottom: 25, right: 20)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 43)
    }
}

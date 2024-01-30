//
//  OnboardingViewController.swift
//  TrackerApp
//
//  Created by Эмилия on 23.01.2024.
//

import UIKit

//MARK: - OnboardingViewController
final class OnboardingViewController: UIPageViewController {
    
    //MARK: - Private properties
    private let dataStorage = DataStorage.shared
    
    //MARK: - UI Components
    private lazy var pages: [UIViewController] = [
        {
            let controller = PagesViewController()
            controller.backgroundImage = UIImage(named: "onboarding1")
            controller.descriptionText = "Отслеживайте только \nто, что хотите"
            return controller
        }(),
        {
            let controller = PagesViewController()
            controller.backgroundImage = UIImage(named: "onboarding2")
            controller.descriptionText = "Даже если это \nне литры воды и йога"
            return controller
        }()
    ]
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPageIndicatorTintColor = Color.blackDay
        pageControl.pageIndicatorTintColor = Color.backgroundDay
        pageControl.currentPage = 0
        pageControl.addTarget(
            OnboardingViewController.self,
            action: #selector(didTapPageControl),
            for: .valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        delegate = self
        dataSource = self
    }
    
    // MARK: - Private methods
    private func configure() {
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        view.addSubview(pageControl)
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - Extension
@objc extension OnboardingViewController {
    private func didTapPageControl(_ sender: UIPageControl) {
        let tappedPageIndex = sender.currentPage
        if tappedPageIndex >= 0 && tappedPageIndex < pages.count {
            let targetPage = pages[tappedPageIndex]
            guard let currentViewController = viewControllers?.first else { return }
            if let currentIndex = pages.firstIndex(of: currentViewController) {
                let direction: UIPageViewController.NavigationDirection = tappedPageIndex > currentIndex ? .forward : .reverse
                setViewControllers([targetPage], direction: direction, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return pages.last
        }
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return pages.first
        }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            guard let currentViewController = viewControllers?.first else { return }
            if let currentIndex = pages.firstIndex(of: currentViewController) {
                let nextIndex = currentIndex + 1
                if nextIndex < pages.count {
                    let nextViewController = pages[nextIndex]
                    self.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
                    pageControl.currentPage = nextIndex
                } else {
                    guard let window = UIApplication.shared.windows.first else {
                        fatalError("Invalid Configuration")
                    }
                    window.rootViewController = TabBarController()
                    dataStorage.firstLaunchApplication = true
                }
            }
        }
}

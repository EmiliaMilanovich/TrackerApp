//
//  TabBarController.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

//MARK: - TabBarController
final class TabBarController: UITabBarController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    //MARK: - Private methods
    private func configureTabBar() {
        tabBar.backgroundColor = Color.whiteDay
        tabBar.tintColor = Color.active
        tabBar.barTintColor = Color.inActive
        tabBar.layer.borderColor = Color.gray.cgColor
        tabBar.layer.borderWidth = 1
        tabBar.layer.masksToBounds = true
        
        let trackersViewController = TrackersViewController()
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersNavigationController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackers"),
            selectedImage: nil
        )
        
        let statsViewController = StatsViewController()
        statsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "stats"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackersNavigationController, statsViewController]
    }
}

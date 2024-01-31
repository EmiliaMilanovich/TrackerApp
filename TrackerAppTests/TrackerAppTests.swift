//
//  TrackerAppTests.swift
//  TrackerAppTests
//
//  Created by Эмилия on 29.01.2024.
//

import XCTest
import SnapshotTesting
@testable import TrackerApp

final class TrackerAppTests: XCTestCase {
    
    func testingTrackersViewControllerLightStyle() {
            let vc = TrackersViewController()
            
            assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
        }
        
        func testingTrackersViewControllerDarkStyle() {
            let vc = TrackersViewController()
            
            assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
        }
}

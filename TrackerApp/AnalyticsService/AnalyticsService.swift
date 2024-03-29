//
//  AnalyticsService.swift
//  TrackerApp
//
//  Created by Эмилия on 27.01.2024.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    static let shared = AnalyticsService()
    
    func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}



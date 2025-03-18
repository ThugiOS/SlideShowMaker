//
//  Settings.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 30.11.23.
//

import Foundation

enum Settings {
    private static let onboardingKey = "OnboardingCompleted"

    static var isOnboardingCompleted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: onboardingKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: onboardingKey)
        }
    }
}

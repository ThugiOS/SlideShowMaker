//
//  OnboardingCoordinator.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 29.11.23.
//

import Combine
import SwiftUI
import UIKit

class OnboardingCoordinator: Coordinator {
    var rootViewController = UIViewController()

    var hasSeenOnboarding: CurrentValueSubject<Bool, Never>

    init(hasSeenOnboarding: CurrentValueSubject<Bool, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
    }

    func start() {
        let view = OnboardingView { [weak self] in
            self?.hasSeenOnboarding.send(true)
        }
        rootViewController = UIHostingController(rootView: view)
    }
}

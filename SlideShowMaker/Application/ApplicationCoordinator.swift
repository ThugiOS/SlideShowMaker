//
//  ApplicationCoordinator.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 29.11.23.
//

import Combine
import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow

    var childCoordinators = [Coordinator]()

    let hasSeenOnboarding = CurrentValueSubject<Bool, Never>(false)
    var subscriptions = Set<AnyCancellable>()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        setupOnboardingValue()

        hasSeenOnboarding
            .removeDuplicates()
            .sink { [weak self] hasSeen in
            if hasSeen {
                let homeCoordinator = HomeCoordinator()
                homeCoordinator.start()
                self?.childCoordinators = [homeCoordinator]
                self?.window.rootViewController = homeCoordinator.rootViewController
            }
            else if let hasSeenOnboarding = self?.hasSeenOnboarding {
                let onboardingCoordinator = OnboardingCoordinator(hasSeenOnboarding: hasSeenOnboarding)
                onboardingCoordinator.start()
                self?.childCoordinators = [onboardingCoordinator]
                self?.window.rootViewController = onboardingCoordinator.rootViewController
            }
            }
        .store(in: &subscriptions)
    }

    func setupOnboardingValue() {
        let key = "hasSeenOnboarding"
        let value = UserDefaults.standard.bool(forKey: key)
        hasSeenOnboarding.send(value)

        hasSeenOnboarding
            .filter { $0 }
            .sink { value in
                UserDefaults.standard.setValue(value, forKey: key)
            }
            .store(in: &subscriptions)
    }
}

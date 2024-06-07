//
//  ApplicationCoordinator.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 29.11.23.
//

import UIKit

final class ApplicationCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if Settings.isOnboardingCompleted {
            showHome()
        }
        else {
            showOnboarding {
                Settings.isOnboardingCompleted = true
                self.showHome()
            }
        }
    }

    func showOnboarding(completion: @escaping () -> Void) {
        let onboardingViewController = OnboardingViewController(coordinator: self, completion: completion)
        navigationController.setViewControllers([onboardingViewController], animated: true)
    }

    func showHome() {
        let homeViewController = HomeViewController(coordinator: self)
        navigationController.setViewControllers([homeViewController], animated: true)
    }

    func showSlideEditor() {
        let slideEditorViewController = SlideEditorViewController(coordinator: self)
        navigationController.pushViewController(slideEditorViewController, animated: true)
        navigationController.navigationBar.isHidden = true
    }

    func showArchive() {
        let archiveViewController = ArchiveViewController(coordinator: self)
        navigationController.pushViewController(archiveViewController, animated: true)
        navigationController.navigationBar.isHidden = true
    }

    func showSettings() {
        let settingsViewController = SettingsViewController(coordinator: self)
        navigationController.pushViewController(settingsViewController, animated: true)
        navigationController.navigationBar.isHidden = true
    }
}

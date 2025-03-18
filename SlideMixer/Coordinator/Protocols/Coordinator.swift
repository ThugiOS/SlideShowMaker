//
//  Coordinator.swift
//  SlideMixer
//
//  Created by Никитин Артем on 29.11.23.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }

    func start()
    func showOnboarding(completion: @escaping () -> Void)
    func showHome()
    func showSlideEditor()
    func showArchive()
    func showSettings()
}

extension Coordinator {
    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}

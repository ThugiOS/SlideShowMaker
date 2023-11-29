//
//  HomeCoordinator.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 29.11.23.
//

import UIKit

class HomeCoordinator: Coordinator {
    var rootViewController = UIViewController()

    func start() {
        rootViewController = HomeViewController()
    }
}

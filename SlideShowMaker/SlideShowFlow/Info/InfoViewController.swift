//
//  InfoViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 5.12.23.
//

import UIKit

final class InfoViewController: UIViewController {
    weak var coordinator: Coordinator?

    // MARK: - UI Components
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(named: "grayForDemo")
        button.tintColor = .white
        button.setTitle("Х", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initializers
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraint()
    }

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(backButton)

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors
    @objc
    private func backButtonTapped() {
        coordinator?.navigateBack()
    }
}

// MARK: - Constraints
extension InfoViewController {
    private func setConstraint() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            backButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -22)
        ])
    }
}

//
//  SlideEditorViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 5.12.23.
//

import UIKit

final class SlideEditorViewController: UIViewController {
    weak var coordinator: Coordinator?

    // MARK: - UI Components
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(named: "grayForDemo")
        button.tintColor = .white
        button.setTitle("<", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
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
extension SlideEditorViewController {
    private func setConstraint() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 22)
        ])
    }
}

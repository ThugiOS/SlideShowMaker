//
//  HomeViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 29.11.23.
//

import UIKit

final class HomeViewController: UIViewController {
    weak var coordinator: Coordinator?

    // MARK: - UI Components
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "grayForDemo")
        label.font = .systemFont(ofSize: 34, weight: .semibold)
        label.text = "My Projects"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let createProjectButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor(named: "grayForDemo")
        button.tintColor = .white
        button.setTitle("+ New Project", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(named: "grayForDemo")
        button.tintColor = .white
        button.setTitle("i", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let proButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(named: "grayForDemo")
        button.tintColor = .white
        button.setTitle("PRO", for: .normal)
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

        view.addSubview(greetingLabel)
        view.addSubview(createProjectButton)
        view.addSubview(infoButton)
        view.addSubview(proButton)

        createProjectButton.addTarget(self, action: #selector(createProjectButtonTapped), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors
    @objc
    private func createProjectButtonTapped() {
        coordinator?.showSlideEditor()
    }

    @objc
    private func infoButtonTapped() {
        coordinator?.showInfo()
    }
}

// MARK: - Constraints
extension HomeViewController {
    private func setConstraint() {
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            greetingLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 22),

            infoButton.centerYAnchor.constraint(equalTo: greetingLabel.centerYAnchor),
            infoButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -22),

            proButton.centerYAnchor.constraint(equalTo: greetingLabel.centerYAnchor),
            proButton.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -5),
            proButton.widthAnchor.constraint(equalToConstant: 50),

            createProjectButton.widthAnchor.constraint(equalToConstant: 180),
            createProjectButton.heightAnchor.constraint(equalToConstant: 70),
            createProjectButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            createProjectButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
}

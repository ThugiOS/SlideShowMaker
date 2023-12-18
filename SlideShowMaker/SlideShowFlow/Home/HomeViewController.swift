//
//  HomeViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 29.11.23.
//

import SnapKit
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
        greetingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(22)
        }

        infoButton.snp.makeConstraints { make in
            make.centerY.equalTo(greetingLabel)
            make.trailing.equalToSuperview().offset(-22)
        }

        proButton.snp.makeConstraints { make in
            make.centerY.equalTo(greetingLabel)
            make.trailing.equalTo(infoButton.snp.leading).offset(-5)
            make.width.equalTo(50)
        }

        createProjectButton.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(70)
            make.bottom.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
        }
    }
}

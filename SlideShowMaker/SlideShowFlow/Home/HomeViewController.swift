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
    private let myProjectsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "grayForDemo")
        label.font = .systemFont(ofSize: 34, weight: .semibold)
        label.text = String(localized: "My Projects")
        return label
    }()

    private let createProjectButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor(named: "grayForDemo")
        button.tintColor = .white
        button.setTitle(String(localized: "+ New Project"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()

    private let infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(named: "grayForDemo")
        button.tintColor = .white
        button.setTitle(String(localized: "i"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()

    private let proButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(named: "grayForDemo")
        button.tintColor = .white
        button.setTitle(String(localized: "PRO"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
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

        view.addSubview(myProjectsLabel)
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
        myProjectsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(22)
        }

        infoButton.snp.makeConstraints { make in
            make.centerY.equalTo(myProjectsLabel)
            make.trailing.equalToSuperview().offset(-22)
        }

        proButton.snp.makeConstraints { make in
            make.centerY.equalTo(myProjectsLabel)
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

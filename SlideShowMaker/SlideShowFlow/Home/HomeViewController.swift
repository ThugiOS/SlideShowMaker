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
    private let createFirstProjectView = FirstSlideShowView()

    private let myProjectsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelBlack
        label.font = UIFont(name: "Gilroy-Bold", size: 34)
        label.text = String(localized: "My Projects")
        return label
    }()

    private let createProjectButtonView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "buttonCreateProject")
        view.isUserInteractionEnabled = true
        return view
    }()

    private let createProjectButtonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Gilroy-Bold", size: 17)
        label.text = String(localized: "New Project")
        return label
    }()

    private let proButtonView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ticketStar")
        view.isUserInteractionEnabled = true
        return view
    }()

    private let proButtonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelBlack
        label.font = UIFont(name: "Gilroy-Bold", size: 14)
        label.text = String(localized: "PRO")
        return label
    }()

    private let infoButtonView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "info")
        view.isUserInteractionEnabled = true
        return view
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
        setupGestures()
    }

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .backgroundWhite

        view.addSubview(myProjectsLabel)

        view.addSubview(proButtonView)
        proButtonView.addSubview(proButtonLabel)

        view.addSubview(infoButtonView)

        view.addSubview(createFirstProjectView)

        view.addSubview(createProjectButtonView)
        createProjectButtonView.addSubview(createProjectButtonLabel)
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

    @objc
    private func proButtonTapped() {
        print("Pro button tapped")
    }
}

// MARK: - Gestures
private extension HomeViewController {
    func setupGestures() {
        let createProjectTapGesture = UITapGestureRecognizer(target: self, action: #selector(createProjectButtonTapped))
        createProjectButtonView.addGestureRecognizer(createProjectTapGesture)

        let proButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(proButtonTapped))
        proButtonView.addGestureRecognizer(proButtonTapGesture)

        let infoButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(infoButtonTapped))
        infoButtonView.addGestureRecognizer(infoButtonTapGesture)
    }
}

// MARK: - Constraints
private extension HomeViewController {
    func setConstraint() {
        let screenWidth = UIScreen.main.bounds.width

        myProjectsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(20)
        }

        infoButtonView.snp.makeConstraints { make in
            make.centerY.equalTo(myProjectsLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(29)
        }

        proButtonView.snp.makeConstraints { make in
            make.centerY.equalTo(myProjectsLabel)
            make.trailing.equalTo(infoButtonView.snp.leading).offset(-5)
            make.width.equalTo(71)
            make.height.equalTo(29)
        }

        proButtonLabel.snp.makeConstraints { make in
            make.centerY.equalTo(proButtonView)
            make.leading.equalToSuperview().offset(12)
        }

        createFirstProjectView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoButtonView.snp.bottom).offset(10)
            make.bottom.equalTo(createProjectButtonView.snp.top).offset(-10)
            make.width.equalTo(screenWidth)
        }

        createProjectButtonView.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(70)
            make.bottom.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
        }

        createProjectButtonLabel.snp.makeConstraints { make in
            make.centerY.equalTo(createProjectButtonView)
            make.leading.equalTo(createProjectButtonView.snp.leading).offset(55)
        }
    }
}

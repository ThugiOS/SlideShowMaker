//
//  OnboardingViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 29.11.23.
//

import SnapKit
import UIKit

final class OnboardingViewController: UIViewController {
    weak var coordinator: Coordinator?
    private var completion: (() -> Void)?

    // MARK: - UI Components
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelBlack
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = String(localized: "Onboarding")
        return label
    }()

    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.backgroundColor = .labelBlack
        button.tintColor = .white
        button.setTitle(String(localized: "Done"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()

    // MARK: - Initializers
    init(coordinator: Coordinator, completion: @escaping () -> Void) {
        self.coordinator = coordinator
        self.completion = completion
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
        view.addSubview(doneButton)

        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors
    @objc
    private func doneButtonTapped() {
        completion?()
    }
}

    // MARK: - Constraints
 extension OnboardingViewController {
    private func setConstraint() {
        greetingLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }

        doneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(80)
            make.trailing.equalToSuperview().offset(-80)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
        }
    }
 }

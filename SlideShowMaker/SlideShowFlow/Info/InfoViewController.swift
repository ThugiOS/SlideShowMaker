//
//  InfoViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 5.12.23.
//

import SnapKit
import UIKit

final class InfoViewController: UIViewController {
    weak var coordinator: Coordinator?

    // MARK: - UI Components
    private let goHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(named: "grayForDemo")
        button.tintColor = .white
        button.setTitle("Х", for: .normal)
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

        view.addSubview(goHomeButton)

        goHomeButton.addTarget(self, action: #selector(goHomeButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors
    @objc
    private func goHomeButtonTapped() {
        coordinator?.showHome()
    }
}

// MARK: - Constraints
extension InfoViewController {
    private func setConstraint() {
        goHomeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.trailing.equalToSuperview().offset(-22)
        }
    }
}

//
//  HomeViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 29.11.23.
//

import Lottie
import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    weak var coordinator: Coordinator?

    // MARK: - UI Components
    private let newLottieView: LottieAnimationView = {
        let lottie = LottieAnimationView(name: "8")
        lottie.contentMode = .scaleAspectFill
        lottie.loopMode = .loop
        lottie.animationSpeed = 0.2
        return lottie
    }()

    private let tipLabel: UILabel = {
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.text = String(localized: "To create a video from your images\n click the New Project button")
        $0.numberOfLines = 2
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(UILabel())

    private lazy var projectCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.register(ProjectCell.self, forCellWithReuseIdentifier: ProjectCell.identifier)

        return collectionView
    }()

    private let myProjectsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.text = String(localized: "My Projects")
        return label
    }()

    private let createProjectButton: AnimatedGradientButton = {
        let button = AnimatedGradientButton()
        button.setTitle(String(localized: "New Project"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 35
        button.clipsToBounds = true

        let image = UIImage(systemName: "person.crop.rectangle.badge.plus.fill")
        button.setImage(image)
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

        projectCollection.delegate = self
        projectCollection.dataSource = self

        setupViews()
        setConstraint()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if RealmManager.shared.loadProjects().isEmpty {
            projectCollection.isHidden = true
            newLottieView.isHidden = false
            tipLabel.isHidden = false
        }
        else {
            projectCollection.isHidden = false
            newLottieView.isHidden = true
            tipLabel.isHidden = true
        }
        projectCollection.reloadData()

        createProjectButton.restartAnimation()
        newLottieView.play()
    }

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .mainBackground

        view.addSubview(myProjectsLabel)
        view.addSubview(newLottieView)
        view.addSubview(tipLabel)
        view.addSubview(projectCollection)
        view.addSubview(createProjectButton)

        createProjectButton.addTarget(self, action: #selector(createProjectButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors
    @objc
    private func createProjectButtonTapped() {
        coordinator?.showSlideEditor()
    }
}

// MARK: - Constraints
private extension HomeViewController {
    func setConstraint() {
        let screenHeight = UIScreen.main.bounds.height

        let myProjectsLabelTopOffset: Int
        let createProjectButtonBottomOffset: Int

        if screenHeight <= 667 { // Height of iPhone 8, SE 2-3 etc.
            myProjectsLabelTopOffset = 30
            createProjectButtonBottomOffset = 15
        }
        else {
            myProjectsLabelTopOffset = 60
            createProjectButtonBottomOffset = 50
        }

        let screenWidth = UIScreen.main.bounds.width
        myProjectsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(myProjectsLabelTopOffset)
            make.centerX.equalToSuperview()
        }

        newLottieView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        projectCollection.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(myProjectsLabel.snp.bottom).offset(20)
            make.bottom.equalTo(createProjectButton.snp.top).offset(-20)
            make.width.equalTo(screenWidth)
        }

        tipLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalTo(createProjectButton.snp.top).offset(-20)
        }

        createProjectButton.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-createProjectButtonBottomOffset)
            make.centerX.equalToSuperview()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RealmManager.shared.loadProjects().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.identifier, for: indexPath) as? ProjectCell else {
            fatalError("Error create cell")
        }

        let project = RealmManager.shared.loadProjects()[indexPath.row]

        if let firstImagePath = project.imagePaths.first {
            let imageURL = FileManager.documentsDirectoryURL.appendingPathComponent(firstImagePath)
            if let imageData = try? Data(contentsOf: imageURL) {
                cell.configureProjectCell(image: UIImage(data: imageData) ?? UIImage(), date: project.date.formatted(), projectName: project.name)
            }
        }

        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let project = RealmManager.shared.loadProjects()[indexPath.row]
        guard let coordinator else {
            return
        }
        let SlideVC = SlideEditorViewController(coordinator: coordinator)

        SlideVC.images = project.imagePaths.map { path in
            let imageURL = FileManager.documentsDirectoryURL.appendingPathComponent(path)
            return UIImage(contentsOfFile: imageURL.path) ?? UIImage()
        }
        navigationController?.pushViewController(SlideVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 334, height: 223)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

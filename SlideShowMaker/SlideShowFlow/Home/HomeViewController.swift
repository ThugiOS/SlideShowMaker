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
        label.textColor = .labelBlack
        label.font = UIFont.gilroyBold(ofSize: 34)
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
        label.font = UIFont.gilroyBold(ofSize: 17)
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
        label.font = UIFont.gilroyBold(ofSize: 14)
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

        projectCollection.delegate = self
        projectCollection.dataSource = self

        setupViews()
        setConstraint()
        setupGestures()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if RealmManager.shared.loadProjects().isEmpty {
            projectCollection.isHidden = true
            createFirstProjectView.isHidden = false
        }
        else {
            projectCollection.isHidden = false
            createFirstProjectView.isHidden = true
        }
        projectCollection.reloadData()
    }

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .backgroundWhite

        view.addSubview(myProjectsLabel)

        view.addSubview(proButtonView)
        proButtonView.addSubview(proButtonLabel)

        view.addSubview(infoButtonView)

        view.addSubview(createFirstProjectView)

        view.addSubview(projectCollection)

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

        createFirstProjectView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoButtonView.snp.bottom).offset(10)
            make.bottom.equalTo(createProjectButtonView.snp.top).offset(-10)
            make.width.equalTo(screenWidth)
        }

        projectCollection.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoButtonView.snp.bottom).offset(20)
            make.bottom.equalTo(createProjectButtonView.snp.top).offset(-20)
            make.width.equalTo(screenWidth)
        }

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
        let SlideVC = SlideEditorViewController(coordinator: coordinator!)

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

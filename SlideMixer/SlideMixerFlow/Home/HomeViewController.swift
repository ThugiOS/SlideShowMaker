//
//  HomeViewController.swift
//  SlideMixer
//
//  Created by Никитин Артем on 29.11.23.
//

import Lottie
import Realm
import RealmSwift
import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    weak var coordinator: Coordinator?

    // MARK: - UI Components
    private let settingsButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "gear")
        configuration.imagePadding = 10

        configuration.imagePlacement = .leading
        configuration.image?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.layer.cornerRadius = 20
        button.backgroundColor = .lightGray.withAlphaComponent(0.1)
        button.tintColor = .white

        return button
    }()

    private let myProjectsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.text = String(localized: "My Projects")
        return label
    }()

    private let archiveButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "archivebox")
        configuration.imagePadding = 10

        configuration.imagePlacement = .leading
        configuration.image?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.layer.cornerRadius = 20
        button.backgroundColor = .lightGray.withAlphaComponent(0.1)
        button.tintColor = .white

        return button
    }()

    private let lottieView: LottieAnimationView = {
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

        showTempView()
        projectCollection.reloadData()
        createProjectButton.restartAnimation()
        lottieView.play()
    }

    // MARK: - UI Setup
    private func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .mainBackground

        view.addSubview(settingsButton)
        view.addSubview(myProjectsLabel)
        view.addSubview(archiveButton)
        view.addSubview(lottieView)
        view.addSubview(tipLabel)
        view.addSubview(projectCollection)
        view.addSubview(createProjectButton)

        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        archiveButton.addTarget(self, action: #selector(archiveButtonTapped), for: .touchUpInside)
        createProjectButton.addTarget(self, action: #selector(createProjectButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors
    @objc
    private func createProjectButtonTapped() {
        coordinator?.showSlideEditor()
    }

    @objc
    private func archiveButtonTapped() {
        coordinator?.showArchive()
    }

    @objc
    private func settingsButtonTapped() {
        coordinator?.showSettings()
    }
}

// MARK: - Constraints
private extension HomeViewController {
    func setConstraint() {
        let screenHeight = UIScreen.main.bounds.height

        let myProjectsLabelTopOffset: Int
        let createProjectButtonBottomOffset: Int

        if screenHeight <= 667 { // Height of iPhone 8, SE 2-3 etc.
            myProjectsLabelTopOffset = 40
            createProjectButtonBottomOffset = 15
        }
        else {
            myProjectsLabelTopOffset = 70
            createProjectButtonBottomOffset = 50
        }

        let screenWidth = UIScreen.main.bounds.width
        myProjectsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(myProjectsLabelTopOffset)
            make.centerX.equalToSuperview()
        }

        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(myProjectsLabel)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(50)
        }

        archiveButton.snp.makeConstraints { make in
            make.centerY.equalTo(myProjectsLabel)
            make.trailing.equalToSuperview().offset(-24)
            make.width.height.equalTo(50)
        }

        lottieView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(myProjectsLabel.snp.bottom)
            make.bottom.equalTo(createProjectButton.snp.top)
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

// MARK: - CollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RealmManager.shared.loadProjects().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.identifier, for: indexPath) as? ProjectCell else {
            fatalError("Error create cell")
        }

        let project = RealmManager.shared.loadProjects()[indexPath.row] // нужно загрузить в обратном порядке

        if let firstImagePath = project.imagePaths.first {
            let imageURL = FileManager.documentsDirectoryURL.appendingPathComponent(firstImagePath)
            if let imageData = try? Data(contentsOf: imageURL) {
                cell.configureProjectCell(image: UIImage(data: imageData) ?? UIImage(), date: project.date.formatted(), projectName: project.name)
            }
        }

        cell.sendToArchiveHandler = { [weak self] in
            self?.sendToArchive(project: project)
        }

        return cell
    }
}

// MARK: - CollectionViewDelegate
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
//        SlideVC.duration = project.duration
//        SlideVC.resolution = project.resolution

        navigationController?.pushViewController(SlideVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 334, height: 223)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

private extension HomeViewController {
    func sendToArchive(project: Project) {
        do {
            let realm = try Realm()
            try realm.write {
                project.archive = true
            }
            showTempView()
            projectCollection.reloadData()
        }
        catch {
            print("Error sending product to archive: \(error.localizedDescription)")
        }
    }

    func showTempView() {
        if RealmManager.shared.loadProjects().isEmpty {
            projectCollection.isHidden = true
            lottieView.isHidden = false
            tipLabel.isHidden = false
        }
        else {
            projectCollection.isHidden = false
            lottieView.isHidden = true
            tipLabel.isHidden = true
        }
    }
}




import CoreHaptics

class HapticManager {
    private var hapticEngine: CHHapticEngine?

    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("⚠️ Устройство не поддерживает Core Haptics")
            return
        }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("❌ Ошибка инициализации Core Haptics: \(error.localizedDescription)")
        }
    }

    func playCustomHaptic() {
        guard let engine = hapticEngine else {
            print("⚠️ Движок вибрации не инициализирован")
            return
        }

        do {
            // 1. Короткий сильный толчок
            let sharpTap = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                ],
                relativeTime: 0.0
            )

            // 2. Средний мягкий толчок через 200 мс
            let softTap = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ],
                relativeTime: 0.2
            )

            // 3. Длительная вибрация 700 мс через 400 мс
            let continuousVibration = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
                ],
                relativeTime: 0.4,
                duration: 0.7
            )

            let pattern = try CHHapticPattern(events: [sharpTap, softTap, continuousVibration], parameters: [])
            let player = try engine.makePlayer(with: pattern)

            try player.start(atTime: CHHapticTimeImmediate)

        } catch {
            print("❌ Ошибка воспроизведения тактильного отклика: \(error.localizedDescription)")
        }
    }
}

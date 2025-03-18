//
//  ArchiveViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 5.12.23.
//

import RealmSwift
import SnapKit
import UIKit

final class ArchiveViewController: UIViewController {
    weak var coordinator: Coordinator?

    private var archivedProjects: Results<Project>? {
        didSet {
            notificationToken = archivedProjects?.observe { [weak self] _ in
                self?.updateClearArchiveButtonVisibility()
            }
        }
    }
    private var notificationToken: NotificationToken?

    // MARK: - UI Components
    private let boxView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "shippingbox")
        $0.tintColor = .darkGray.withAlphaComponent(0.1)
        return $0
    }(UIImageView())

    private let goHomeButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.backward")
        view.tintColor = .button1
        view.isUserInteractionEnabled = true
        return view
    }()

    private let archiveLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.text = String(localized: "Archive")
        return label
    }()

    private lazy var archiveCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.register(ArchiveCell.self, forCellWithReuseIdentifier: ArchiveCell.identifier)

        return collectionView
    }()

    private let tipLabel: UILabel = {
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.text = String(localized: "To add a project to the archive\nclick the button:")
        $0.numberOfLines = 2
        $0.lineBreakMode = .byWordWrapping
        $0.isHidden = true
        return $0
    }(UILabel())

    private let tipImage: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "archivebox.fill")
        $0.tintColor = .darkGray
        $0.isHidden = true
        return $0
    }(UIImageView())

    private let clearArchiveDataButton: UIButton = {
        $0.backgroundColor = .clear
        $0.setTitle(String(localized: "Clear archive"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        $0.setTitleColor(.red, for: .normal)
        return $0
    }(UIButton())

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
        archiveCollection.delegate = self
        archiveCollection.dataSource = self

        setupViews()
        setConstraint()
        loadData()
        tipsArchive()
    }

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .mainBackground

        view.addSubview(boxView)
        view.addSubview(goHomeButton)
        view.addSubview(archiveLabel)
        view.addSubview(archiveCollection)
        view.addSubview(clearArchiveDataButton)
        view.addSubview(tipLabel)
        view.addSubview(tipImage)

        let goHomeButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(goHomeButtonTapped))
        goHomeButton.addGestureRecognizer(goHomeButtonTapGesture)

        clearArchiveDataButton.addTarget(self, action: #selector(clearArchiveDataTapped), for: .touchUpInside)
    }

    // MARK: - Selectors
    @objc
    private func goHomeButtonTapped() {
        coordinator?.navigateBack()
    }

    @objc
    private func clearArchiveDataTapped() {
        let alert = UIAlertController(title: String(localized: "Clear Archive"),
                                      message: String(localized: "Are you sure you want to delete all archived projects?"),
                                      preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: String(localized: "Delete"), style: .destructive) { _ in
            RealmManager.shared.deleteAllArchivedProjects()
            self.loadData() // Refresh the data after deletion
        }

        let cancelAction = UIAlertAction(title: String(localized: "Cancel"), style: .default, handler: nil)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    deinit {
        notificationToken?.invalidate()
    }
}

// MARK: - Constraints
private extension ArchiveViewController {
    func setConstraint() {
        let screenHeight = UIScreen.main.bounds.height

        boxView.snp.makeConstraints { make in
            make.width.height.equalTo(700)
            make.bottom.leading.equalToSuperview()
        }

        goHomeButton.snp.makeConstraints { make in
            make.width.equalTo(29)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(screenHeight * 0.1)
            make.leading.equalToSuperview().offset(screenHeight * 0.02)
        }

        archiveLabel.snp.makeConstraints { make in
            make.centerY.equalTo(goHomeButton)
            make.centerX.equalToSuperview()
        }

        tipLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        tipImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tipLabel.snp.bottom).offset(5)
            make.width.height.equalTo(50)
        }

        archiveCollection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(goHomeButton.snp.bottom).offset(20)
            make.bottom.equalTo(clearArchiveDataButton.snp.top)
        }

        clearArchiveDataButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
    }
}

// MARK: - CollectionViewDataSource
extension ArchiveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return archivedProjects?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArchiveCell.identifier, for: indexPath) as? ArchiveCell else {
            fatalError("Error create cell")
        }
        let project = archivedProjects?[indexPath.row]

        if let firstImagePath = project?.imagePaths.first {
            let imageURL = FileManager.documentsDirectoryURL.appendingPathComponent(firstImagePath)
            if let imageData = try? Data(contentsOf: imageURL) {
                cell.configureProjectCell(image: UIImage(data: imageData) ?? UIImage(), date: project?.date.formatted() ?? "", projectName: project?.name ?? "")
            }
        }

        cell.returnToMainCollectionHandler = { [weak self] in
            self?.removeFromArchive(project: project)
        }

        return cell
    }
}

// MARK: - CollectionViewDelegate
extension ArchiveViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 334, height: 223)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

private extension ArchiveViewController {
    func loadData() {
        archivedProjects = RealmManager.shared.loadArchiveProjects()
        archiveCollection.reloadData()
    }

    func removeFromArchive(project: Project?) {
        guard let project = project else {
            return
        }
        do {
            let realm = try Realm()
            try realm.write {
                project.archive = false
            }

            loadData()
        }
        catch {
            print("Error sending project to archive: \(error.localizedDescription)")
        }
    }

    func updateClearArchiveButtonVisibility() {
        clearArchiveDataButton.isHidden = archivedProjects?.isEmpty ?? true // Проверка на пустоту архива
    }

    func tipsArchive() {
        if archivedProjects?.isEmpty ?? true {
            tipImage.isHidden = false
            tipLabel.isHidden = false
        }
    }
}

////
////  ArchiveViewController.swift
////  SlideShowMaker
////
////  Created by Никитин Артем on 5.12.23.
////

 import SnapKit
 import UIKit

 final class ArchiveViewController: UIViewController {
    weak var coordinator: Coordinator?

    // MARK: - UI Components
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
    }

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .mainBackground

        view.addSubview(goHomeButton)
        view.addSubview(archiveLabel)
        view.addSubview(archiveCollection)
        view.addSubview(clearArchiveDataButton)

        let goHomeButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(goHomeButtonTapped))
        goHomeButton.addGestureRecognizer(goHomeButtonTapGesture)
    }

    // MARK: - Selectors
    @objc
    private func goHomeButtonTapped() {
        coordinator?.navigateBack()
    }
 }

// MARK: - Constraints
 private extension ArchiveViewController {
    func setConstraint() {
        let screenHeight = UIScreen.main.bounds.height

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

extension ArchiveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RealmManager.shared.loadProjects().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArchiveCell.identifier, for: indexPath) as? ArchiveCell else {
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

extension ArchiveViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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

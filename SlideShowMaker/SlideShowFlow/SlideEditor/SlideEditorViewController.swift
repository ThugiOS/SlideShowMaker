//
//  SlideEditorViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 5.12.23.
//

import SnapKit
import UIKit

final class SlideEditorViewController: UIViewController {
    weak var coordinator: Coordinator?

    private var images: [UIImage] = []

    private var isDeleteButtonEnabled = false {
        didSet {
            deleteImageButton.isEnabled = isDeleteButtonEnabled
            deleteImageButton.backgroundColor = isDeleteButtonEnabled ? .grayForDemo : .clear
        }
    }

    // MARK: - UI Components
    private let goHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.backgroundColor = .grayForDemo
        button.tintColor = .white
        button.setTitle("<", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 18
        button.backgroundColor = .grayForDemo
        button.tintColor = .white
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        return collectionView
    }()

    private let controlPanelView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()

    private let deleteImageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("Х", for: .normal)
        button.setTitleColor(UIColor.systemGray5, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isEnabled = false
        return button
    }()

    private let addImageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .grayForDemo
        button.tintColor = .white
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        return button
    }()

    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grayForDemo
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let toolbar: UIToolbar = {
        let tb = UIToolbar()
        tb.barStyle = .default
        tb.backgroundColor = .systemBackground
        return tb
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
        setBarItems()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(goHomeButton)
        view.addSubview(saveButton)
        view.addSubview(selectedImageView)
        view.addSubview(controlPanelView)
        controlPanelView.addSubview(deleteImageButton)
        view.addSubview(collectionView)
        view.addSubview(addImageButton)
        view.addSubview(toolbar)

        goHomeButton.addTarget(self, action: #selector(goHomeButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        addImageButton.addTarget(self, action: #selector(openPhotoPicker), for: .touchUpInside)
        deleteImageButton.addTarget(self, action: #selector(deleteSelectedPhoto), for: .touchUpInside)
    }

    // MARK: - Private Methods
    private func setBarItems() {
        let canvasButton = makeToolbarButton(name: "Canvas", imageName: "questionmark", action: #selector(openCanvasViewController))
        let timingButton = makeToolbarButton(name: "Timing", imageName: "questionmark", action: #selector(openTimingViewController))
        let audioButton = makeToolbarButton(name: "Audio", imageName: "questionmark", action: #selector(openAudioViewController))

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let items = [flexibleSpace, canvasButton, flexibleSpace, timingButton, flexibleSpace, audioButton, flexibleSpace]
        toolbar.setItems(items, animated: true)
    }

    private func makeToolbarButton(name: String, imageName: String, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: name, image: UIImage(systemName: imageName), target: self, action: action)
    }

    private func openViewController(_ viewController: UIViewController) {
        let modalVC = UIViewController()
        modalVC.modalPresentationStyle = .custom
        modalVC.transitioningDelegate = self
        modalVC.addChild(viewController)
        viewController.didMove(toParent: modalVC)
        modalVC.view.addSubview(viewController.view)
        present(modalVC, animated: true, completion: nil)
    }

    // MARK: - Selectors
    @objc
    private func goHomeButtonTapped() {
        coordinator?.showHome()
    }

    @objc
    private func saveButtonTapped() {
        print("Project was saved")
    }

    @objc
    private func openPhotoPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
    }

    @objc
    private func deleteSelectedPhoto() {
        guard let selectedImage = selectedImageView.image,
              let index = images.firstIndex(of: selectedImage) else {
            return
        }

        images.remove(at: index)
        collectionView.reloadData()

        // Display the first image in selectedImageView (if available)
        selectedImageView.image = images.first

        // Disable deleteButton if the collection is empty
        isDeleteButtonEnabled = !images.isEmpty
    }

    @objc
    func openCanvasViewController() {
        openViewController(CanvasViewController())
    }

    @objc
    func openTimingViewController() {
        openViewController(TimingViewController())
    }

    @objc
    func openAudioViewController() {
        openViewController(AudioViewController())
    }
}

// MARK: - Constraints
extension SlideEditorViewController {
    private func setConstraint() {
        goHomeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(22)
        }

        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(goHomeButton.snp.centerY)
            make.trailing.equalToSuperview().offset(-22)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }

        selectedImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(142)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(348)
        }

        controlPanelView.snp.makeConstraints { make in
            make.top.equalTo(selectedImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }

        deleteImageButton.snp.makeConstraints { make in
            make.centerY.equalTo(controlPanelView.snp.centerY)
            make.centerX.equalTo(controlPanelView.snp.centerX)
            make.height.width.equalTo(44)
        }

        addImageButton.snp.makeConstraints { make in
            make.top.equalTo(controlPanelView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalTo(collectionView.snp.leading).offset(-5)
            make.width.height.equalTo(74)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(controlPanelView.snp.bottom).offset(20)
            make.trailing.equalToSuperview()
            make.height.equalTo(74)
        }

        toolbar.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - CollectionView DataSource
extension SlideEditorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
            fatalError("Error create cell")
        }

        let image = self.images[indexPath.row]
        cell.configure(with: image)

        return cell
    }
}

// MARK: - CollectionView Delegate
extension SlideEditorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = images[indexPath.row]
        selectedImageView.image = selectedImage
        isDeleteButtonEnabled = true
        collectionView.reloadData()
    }
}

extension SlideEditorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 74)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}

// MARK: - ImagePickerController
extension SlideEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.append(image)
            collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ViewControllerTransitioningDelegate
extension SlideEditorViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

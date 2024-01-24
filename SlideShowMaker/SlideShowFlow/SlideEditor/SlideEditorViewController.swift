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

    private var videoInfo: VideoInfo?

    private var isDeleteButtonEnabled = false {
        didSet {
            deleteImageButton.isEnabled = isDeleteButtonEnabled
            deleteImageButton.backgroundColor = isDeleteButtonEnabled ? .gray : .clear
        }
    }

    // MARK: - UI Components
    private let goHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setTitle("<", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 18
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setTitle(String(localized: "Save"), for: .normal)
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
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        return button
    }()

    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
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

        view.addSubview(controlPanelView)
        controlPanelView.addSubview(deleteImageButton)
        controlPanelView.addSubview(goHomeButton)
        controlPanelView.addSubview(saveButton)
        controlPanelView.addSubview(selectedImageView)
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
        let canvasButton = makeToolbarButton(name: String(localized: "Canvas"), action: #selector(openCanvasViewController))
        let timingButton = makeToolbarButton(name: String(localized: "Timing"), action: #selector(openTimingViewController))
        let audioButton = makeToolbarButton(name: String(localized: "Audio"), action: #selector(openAudioViewController))

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let items = [flexibleSpace, canvasButton, flexibleSpace, timingButton, flexibleSpace, audioButton, flexibleSpace]
        toolbar.setItems(items, animated: true)
    }

    private func makeToolbarButton(name: String, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: name, style: .plain, target: self, action: action)
    }

    private func openViewController(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        present(viewController, animated: true, completion: nil)
    }

    // MARK: - Selectors
    @objc
    private func goHomeButtonTapped() {
        coordinator?.showHome()
    }

    @objc
    private func saveButtonTapped() {
        guard let videoInfo = videoInfo else {
            // Здесь укажите разрешение, кадры в секунду и длительность видео
            self.videoInfo = VideoInfo(resolution: .canvas1x1, duration: 5)
            return
        }

        let videoCreator = VideoCreator(images: images)
        videoCreator.createVideo(videoInfo: videoInfo) { [weak self] url in
            guard url != nil else {
                print("Failed to create and save video.")
                return
            }

            DispatchQueue.main.async {
                self?.showAlert(withTitle: "Video Saved", message: "The video has been saved to the gallery.")
            }
        }
    }

    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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
        let timingViewController = TimingViewController()
        timingViewController.numberOfImages = images.count
        openViewController(timingViewController)
    }

    @objc
    func openAudioViewController() {
        openViewController(AudioViewController())
    }
}

// MARK: - Constraints
private extension SlideEditorViewController {
    func setConstraint() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width

        controlPanelView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(screenHeight * 0.68)
        }

        goHomeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(screenHeight * 0.1)
            make.leading.equalToSuperview().offset(screenHeight * 0.02)
        }

        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(goHomeButton.snp.centerY)
            make.trailing.equalToSuperview().offset(-(screenHeight * 0.02))
            make.width.equalTo(100)
            make.height.equalTo(50)
        }

        selectedImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(screenHeight * 0.17)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(screenHeight * 0.43)
        }

        deleteImageButton.snp.makeConstraints { make in
            make.centerX.equalTo(controlPanelView.snp.centerX)
            make.top.equalTo(selectedImageView.snp.bottom).offset(screenHeight * 0.01)
            make.bottom.equalTo(controlPanelView.snp.bottom).offset(-screenHeight * 0.01)
            make.width.equalTo(screenWidth * 0.12)
        }

        addImageButton.snp.makeConstraints { make in
            make.top.equalTo(controlPanelView.snp.bottom).offset(screenWidth * 0.09)
            make.leading.equalToSuperview().offset(19)
            make.width.height.equalTo(80)
        }

        collectionView.snp.makeConstraints { make in
            make.centerY.equalTo(addImageButton.snp.centerY)
            make.leading.equalTo(addImageButton.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.height.equalTo(74)
        }

        toolbar.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(screenHeight * 0.11)
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

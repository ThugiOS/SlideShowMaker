//
//  SlideEditorViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 5.12.23.
//

import SnapKit
import UIKit

final class SlideEditorViewController: UIViewController {
    // MARK: - Public Properties
    weak var coordinator: Coordinator?

    // MARK: - Private Properties
    private var images: [UIImage] = []

    private var videoInfo: VideoInfo?

    private var videoCreator: VideoCreator?

    private var selectedImageIndex: Int? {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - UI Components
    private let goHomeButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrow")
        view.isUserInteractionEnabled = true
        return view
    }()

    private let saveButton = CustomButton(text: String(localized: "Save"), fontSize: 16)

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

    private let picturePanelView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundLightGrey
        return view
    }()

    private let controlBoardView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .backgroundLightGrey
        return view
    }()

    private let binImageButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bin")
        view.isUserInteractionEnabled = true
        return view
    }()

    private let playImageButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "play")
        view.isUserInteractionEnabled = true
        return view
    }()

    private let timerLabel = CustomLabel(title: String(localized: "00.00.00"), size: 14, alpha: 1, fontType: .medium)

    private let addImageButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "rectangle")
        view.isUserInteractionEnabled = true
        return view
    }()

    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.backgroundColor = .backgroundLightGrey
        return toolbar
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
        setupGestures()
        setDefaultVideoSettings()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .backgroundWhite
        view.addSubview(picturePanelView)
        view.addSubview(goHomeButton)
        view.addSubview(saveButton)
        view.addSubview(selectedImageView)
        view.addSubview(controlBoardView)
        view.addSubview(playImageButton)
        view.addSubview(timerLabel)
        view.addSubview(collectionView)
        view.addSubview(addImageButton)
        view.addSubview(toolbar)
        view.addSubview(binImageButton)
    }

    // MARK: - Private Methods
    private func setBarItems() {
        let canvasImage = UIImage(named: "canvas")
        let canvasButton = makeToolbarButton(image: canvasImage, action: #selector(openCanvasViewController))

        let timingImage = UIImage(named: "timing")
        let timingButton = makeToolbarButton(image: timingImage, action: #selector(openTimingViewController))

        let audioImage = UIImage(named: "audio")
        let audioButton = makeToolbarButton(image: audioImage, action: #selector(openAudioViewController))

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let items = [flexibleSpace, canvasButton, flexibleSpace, timingButton, flexibleSpace, audioButton, flexibleSpace]
        toolbar.setItems(items, animated: true)
    }

    private func makeToolbarButton(image: UIImage?, action: Selector) -> UIBarButtonItem {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        imageView.addGestureRecognizer(tapGesture)
        return UIBarButtonItem(customView: imageView)
    }

    private func openViewController(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        present(viewController, animated: true, completion: nil)
    }

    private func updateButtonsStatus(_ numberOfItems: Int) {
        binImageButton.alpha = numberOfItems > 0 ? 0.9 : 0.1
        playImageButton.alpha = numberOfItems > 0 ? 0.9 : 0.1
        saveButton.alpha = numberOfItems > 0 ? 1 : 0.3
        saveButton.isUserInteractionEnabled = numberOfItems > 0 ? true : false
    }

    private func setDefaultVideoSettings() {
        let defaultSetting = VideoInfo(resolution: .canvas1x1, duration: TimeInterval(5))
        self.videoInfo = defaultSetting
    }

    // MARK: - Selectors
    @objc
    private func goHomeButtonTapped() {
        coordinator?.navigateBack()
    }

    @objc
    private func saveButtonTapped() {
        let videoCreator = VideoCreator(images: images)
        let videoInfo = videoInfo ?? VideoInfo(resolution: .canvas1x1, duration: 5)
        videoCreator.createVideo(videoInfo: videoInfo) { url in
            guard url != nil else {
                print("Failed to create and save video.")
                return
            }

            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }

                self.showAlert(withTitle: String(localized: "Video Saved"), message: String(localized: "The video has been saved to the gallery."))
                self.videoCreator = nil
            }
        }

        self.videoCreator = videoCreator
    }

    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String(localized: "OK"), style: .default, handler: nil)
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
        selectedImageView.image = images.first
    }

    @objc
    func openCanvasViewController() {
        let canvasViewController = CanvasViewController()
        canvasViewController.delegate = self
        canvasViewController.videoCanvasInfo = self.videoInfo
        openViewController(canvasViewController)
    }

    @objc
    func openTimingViewController() {
        let timingViewController = TimingViewController()
        timingViewController.delegate = self
        timingViewController.videoTimeInfo = self.videoInfo
        timingViewController.numberOfImages = images.count
        openViewController(timingViewController)
    }

    @objc
    func openAudioViewController() {
        openViewController(AudioViewController())
    }
}

extension SlideEditorViewController: VideoInfoDelegateProtocol {
    func updateVideoInfo(_ userInfo: VideoInfo) {
        self.videoInfo = userInfo
    }
}

// MARK: - Constraints
private extension SlideEditorViewController {
    // swiftlint:disable:next function_body_length
    func setConstraint() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width

        picturePanelView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(selectedImageView)
        }

        controlBoardView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(picturePanelView)
            make.top.equalTo(picturePanelView.snp.bottom).offset(3)
            make.height.equalTo(screenHeight * 0.075)
        }

        goHomeButton.snp.makeConstraints { make in
            make.width.height.equalTo(33)
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

        binImageButton.snp.makeConstraints { make in
            make.centerY.equalTo(playImageButton)
            make.trailing.equalTo(playImageButton).offset(-110)
            make.width.height.equalTo(30)
        }

        playImageButton.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(controlBoardView)
            make.width.height.equalTo(30)
        }

        timerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(playImageButton)
            make.trailing.equalTo(playImageButton).offset(130)
        }

        addImageButton.snp.makeConstraints { make in
            make.top.equalTo(controlBoardView.snp.bottom).offset(screenWidth * 0.08)
            make.leading.equalToSuperview().offset(19)
            make.width.height.equalTo(80)
        }

        collectionView.snp.makeConstraints { make in
            make.centerY.equalTo(addImageButton.snp.centerY)
            make.leading.equalTo(addImageButton.snp.trailing).offset(15)
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

// MARK: - Gestures
private extension SlideEditorViewController {
    func setupGestures() {
        let goHomeButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(goHomeButtonTapped))
        goHomeButton.addGestureRecognizer(goHomeButtonTapGesture)

        let saveButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped))
        saveButton.addGestureRecognizer(saveButtonTapGesture)

        let addImageButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(openPhotoPicker))
        addImageButton.addGestureRecognizer(addImageButtonTapGesture)

        let deleteImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteSelectedPhoto))
        binImageButton.addGestureRecognizer(deleteImageTapGesture)
    }
}

// MARK: - CollectionView DataSource
extension SlideEditorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = images.count
        updateButtonsStatus(numberOfItems)
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
            fatalError("Error create cell")
        }

        let image = self.images[indexPath.row]
        let hasSelectedImage = selectedImageView.image != nil
        cell.configure(with: image, isSelected: indexPath.row == selectedImageIndex, hasSelectedImage: hasSelectedImage)
        return cell
    }
}

// MARK: - CollectionView Delegate
extension SlideEditorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = images[indexPath.row]
        selectedImageView.image = selectedImage
        selectedImageIndex = indexPath.row
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension SlideEditorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 74)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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

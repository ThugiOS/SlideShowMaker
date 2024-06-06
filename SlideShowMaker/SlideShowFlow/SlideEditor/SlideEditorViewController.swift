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
    var images: [UIImage] = []

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
        view.image = UIImage(systemName: "chevron.backward")
        view.tintColor = .button1
        view.isUserInteractionEnabled = true
        return view
    }()

    private let saveButton: AnimatedGradientButton = {
        let button = AnimatedGradientButton()
        button.setTitle(String(localized: "Create"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()

    private let tipsView = TipsView()

    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let binImageButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "xmark.bin.fill")
        view.tintColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()

    private let addImageButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "rectangle")
        view.isUserInteractionEnabled = true
        return view
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

    private let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .black
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
        setDefaultVideoSettings()
        navigationController?.isNavigationBarHidden = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        if !images.isEmpty {
            selectedImageIndex = 0
            selectedImageView.image = images.first
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveButton.restartAnimation()
    }

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .mainBackground

        view.addSubview(goHomeButton)
        view.addSubview(saveButton)
        view.addSubview(tipsView)
        view.addSubview(selectedImageView)
        view.addSubview(collectionView)
        view.addSubview(addImageButton)
        view.addSubview(toolbar)
        view.addSubview(binImageButton)

        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        let goHomeButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(goHomeButtonTapped))
        goHomeButton.addGestureRecognizer(goHomeButtonTapGesture)
        let addImageButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(openPhotoPicker))
        addImageButton.addGestureRecognizer(addImageButtonTapGesture)
        let deleteImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteSelectedPhoto))
        binImageButton.addGestureRecognizer(deleteImageTapGesture)
    }

    // MARK: - Private Methods
    private func setBarItems() {
        let canvasImage = UIImage(named: "resolution")
        let canvasButton = makeToolbarButton(image: canvasImage, action: #selector(openCanvasViewController))

        let timingImage = UIImage(named: "timer")
        let timingButton = makeToolbarButton(image: timingImage, action: #selector(openTimingViewController))

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let items = [flexibleSpace, canvasButton, flexibleSpace, timingButton, flexibleSpace]
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
        binImageButton.alpha = numberOfItems > 0 ? 0.9 : 0.0
        saveButton.alpha = numberOfItems > 0 ? 1 : 0.1
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
        saveButton.animateButton()

        /// Сохраняем проект
        guard !images.isEmpty else { // массив изображений
            return
        }
        let currentDate = Date() // Дата
        let index = RealmManager.shared.loadProjects().count + 1 // индекс для имени проекта
        let videoDuration = (videoInfo?.duration) ?? 10 // Длительность видео

        RealmManager.shared.saveProject(images: images,
                                        name: "project",  // задать имя
                                        date: currentDate,
                                        index: index,
                                        duration: videoDuration)

        /// Создаем видео
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
}

extension SlideEditorViewController: VideoInfoDelegateProtocol {
    func updateVideoInfo(_ userInfo: VideoInfo) {
        self.videoInfo = userInfo
    }
}

// MARK: - Constraints
private extension SlideEditorViewController {
    func setConstraint() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width

        goHomeButton.snp.makeConstraints { make in
            make.width.equalTo(29)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(screenHeight * 0.1)
            make.leading.equalToSuperview().offset(screenHeight * 0.02)
        }

        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(goHomeButton.snp.centerY)
            make.trailing.equalToSuperview().offset(-(screenHeight * 0.02))
            make.width.equalTo(120)
            make.height.equalTo(50)
        }

        tipsView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(screenHeight * 0.33)
            make.leading.equalToSuperview().offset(35)
        }

        selectedImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(screenHeight * 0.17)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(screenHeight * 0.5)
        }

        binImageButton.snp.makeConstraints { make in
            make.centerX.equalTo(selectedImageView)
            make.bottom.equalTo(selectedImageView).offset(-10)
            make.width.height.equalTo(44)
        }

        addImageButton.snp.makeConstraints { make in
            make.top.equalTo(selectedImageView.snp.bottom).offset(screenWidth * 0.09)
            make.leading.equalToSuperview().offset(19)
            make.width.height.equalTo(65)
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
            selectedImageIndex = images.count - 1
            selectedImageView.image = image
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

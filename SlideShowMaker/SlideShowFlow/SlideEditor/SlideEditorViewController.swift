//
//  SlideEditorViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 5.12.23.
//

import UIKit

final class SlideEditorViewController: UIViewController {
    weak var coordinator: Coordinator?

    private var images: [UIImage] = []

    private var isDeleteButtonEnabled = false {
        didSet {
            deleteImage.isEnabled = isDeleteButtonEnabled
            deleteImage.backgroundColor = isDeleteButtonEnabled ? .grayForDemo : .clear
        }
    }

    // MARK: - UI Components
    private let backToHome: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.backgroundColor = .grayForDemo
        button.tintColor = .white
        button.setTitle("<", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: MyCell.identifier)
        return collectionView
    }()

    private let addImage: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .grayForDemo
        button.tintColor = .white
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grayForDemo
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let deleteImage: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
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

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(backToHome)
        view.addSubview(collectionView)
        view.addSubview(addImage)
        view.addSubview(selectedImageView)
        view.addSubview(deleteImage)

        backToHome.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        addImage.addTarget(self, action: #selector(openPhotoPicker), for: .touchUpInside)
        deleteImage.addTarget(self, action: #selector(deleteSelectedPhoto), for: .touchUpInside)

        if let firstImage = images.first {
            selectedImageView.image = firstImage
        }
    }

    // MARK: - Selectors
    @objc
    private func backButtonTapped() {
        coordinator?.navigateBack()
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
        if let firstImage = images.first {
            selectedImageView.image = firstImage
        }
        else {
            selectedImageView.image = nil
        }

        // Disable deleteButton if the collection is empty
        isDeleteButtonEnabled = !images.isEmpty
    }
}

// MARK: - Constraints
extension SlideEditorViewController {
    private func setConstraint() {
        NSLayoutConstraint.activate([
            backToHome.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            backToHome.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),

            selectedImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 142),
            selectedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedImageView.heightAnchor.constraint(equalToConstant: 348),

            deleteImage.topAnchor.constraint(equalTo: selectedImageView.bottomAnchor, constant: 20),
            deleteImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 175),

            addImage.topAnchor.constraint(equalTo: deleteImage.bottomAnchor, constant: 20),
            addImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            addImage.trailingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: -5),
            addImage.widthAnchor.constraint(equalToConstant: 74),
            addImage.heightAnchor.constraint(equalToConstant: 74),

            collectionView.topAnchor.constraint(equalTo: deleteImage.bottomAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 74),
        ])
    }
}

// MARK: - CollectionView DataSource
extension SlideEditorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCell.identifier, for: indexPath) as? MyCell else {
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

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        isDeleteButtonEnabled = false
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

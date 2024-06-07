//
//  SettingsViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 7.06.24.
//

import RealmSwift
import SnapKit
import UIKit

final class SettingsViewController: UIViewController {
    weak var coordinator: Coordinator?

    // MARK: - UI Components
    private let goHomeButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.backward")
        view.tintColor = .button1
        view.isUserInteractionEnabled = true
        return view
    }()

    private let settingsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.text = String(localized: "Settings")
        return label
    }()

    private let shareButton: AnimatedGradientButton = {
        let button = AnimatedGradientButton()
        button.setTitle(String(localized: "  Share our app"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true

        let image = UIImage(systemName: "square.and.arrow.up.fill")
        button.setImage(image)
        return button
    }()

    private let rateButton: AnimatedGradientButton = {
        let button = AnimatedGradientButton()
        button.setTitle(String(localized: "  Rate app"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true

        let image = UIImage(systemName: "star.fill")
        button.setImage(image)
        return button
    }()

    private let usageButton: AnimatedGradientButton = {
        let button = AnimatedGradientButton()
        button.setTitle(String(localized: "  Usage Policy"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true

        let image = UIImage(systemName: "bubble.right.fill")
        button.setImage(image)
        return button
    }()

    private let clearAllDataButton: UIButton = {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .lightGray.withAlphaComponent(0.1)
        $0.setTitleColor(.red, for: .normal)
        $0.setTitle(String(localized: "Clear and reset all data"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18)
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

        setupViews()
        setConstraint()
    }

    // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .mainBackground

        view.addSubview(goHomeButton)
        view.addSubview(settingsLabel)
        view.addSubview(shareButton)
        view.addSubview(rateButton)
        view.addSubview(usageButton)
        view.addSubview(clearAllDataButton)

        let goHomeButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(goHomeButtonTapped))
        goHomeButton.addGestureRecognizer(goHomeButtonTapGesture)

        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        rateButton.addTarget(self, action: #selector(rateButtonTapped), for: .touchUpInside)
        usageButton.addTarget(self, action: #selector(usageButtonTapped), for: .touchUpInside)
        clearAllDataButton.addTarget(self, action: #selector(clearAllDataButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors
    @objc
    private func goHomeButtonTapped() {
        coordinator?.navigateBack()
    }

    @objc
    private func shareButtonTapped() {
        // Ссылка на ваше приложение в App Store
        let appStoreLink = "https://apps.apple.com/app"
        // Текст для общего доступа
        let textToShare = "Check out this awesome app: \(appStoreLink)"
        // Активности для общего доступа
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        // Для iPad (предотвращение сбоев на iPad)
        activityViewController.popoverPresentationController?.sourceView = self.view
        // Представьте Activity View Controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    @objc
    private func rateButtonTapped() {
        guard let appID = Bundle.main.object(forInfoDictionaryKey: "APP_STORE_ID") as? String,
              let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)?action=write-review") else {
            print("Unable to construct App Store URL for rating.")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)

            /*
             Чтобы добавить ключ APP_STORE_ID в файл Info.plist вашего проекта, вам нужно выполнить следующие шаги:

                 Откройте проект в Xcode.
                 В навигаторе проекта выберите файл Info.plist.
                 Нажмите на "+" в любом свободном месте, чтобы добавить новый элемент в plist.
                 Введите APP_STORE_ID в поле "Key".
                 Введите идентификатор вашего приложения в App Store в поле "Value".
                 Нажмите клавишу Enter, чтобы сохранить значение.

             После этого ваш ключ APP_STORE_ID будет добавлен в файл Info.plist, и вы сможете использовать его в коде для получения идентификатора вашего приложения при отправке пользователя на страницу оценки приложения в App Store.
             */
    }

    @objc
    private func usageButtonTapped() {
        guard let url = URL(string: "https://github.com/ThugiOS/SlideShowMaker") else {
            print("Unable to construct URL for Usage Policy.")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @objc
    private func clearAllDataButtonTapped() {
        let alert = UIAlertController(title: String(localized: "Clear and reset all data"),
                                      message: String(localized: "Are you sure you want to delete all projects and reset settings?"),
                                      preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: String(localized: "Yes"), style: .destructive) { _ in
            RealmManager.shared.deleteAllProjects()
            Settings.isOnboardingCompleted = false
        }

        let cancelAction = UIAlertAction(title: String(localized: "Cancel"), style: .default, handler: nil)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Constraints
private extension SettingsViewController {
    func setConstraint() {
        let screenHeight = UIScreen.main.bounds.height

        goHomeButton.snp.makeConstraints { make in
            make.width.equalTo(29)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(screenHeight * 0.1)
            make.leading.equalToSuperview().offset(screenHeight * 0.02)
        }

        settingsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(goHomeButton)
            make.centerX.equalToSuperview()
        }

        shareButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(60)
        }

        rateButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(shareButton.snp.bottom).offset(20)
            make.width.equalTo(250)
            make.height.equalTo(60)
        }

        usageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rateButton.snp.bottom).offset(20)
            make.width.equalTo(250)
            make.height.equalTo(60)
        }

        clearAllDataButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usageButton.snp.bottom).offset(50)
            make.width.equalTo(250)
            make.height.equalTo(60)
        }
    }
}

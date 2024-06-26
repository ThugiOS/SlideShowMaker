//
//  CanvasViewController.swift
//  ToolBar
//
//  Created by Никитин Артем on 26.12.23.
//

 import SnapKit
 import UIKit

 final class CanvasViewController: UIViewController {
// MARK: - Public Properties
    weak var delegate: VideoInfoDelegateProtocol?
    var videoCanvasInfo: VideoInfo?

 // MARK: - Private Properties
    private var resolution: VideoResolution = .canvas5x8
    private let resolutions: [VideoResolution] = [.canvas1x1, .canvas9x16, .canvas4x5, .canvas5x8, .canvas4x3, .canvas3x4]

    // MARK: - UI Components

    private let doneButton: AnimatedGradientButton = {
        let button = AnimatedGradientButton()
        button.setTitle(String(localized: "Done"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()

    private let nameScreenLabel: UILabel = {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.text = String(localized: "Aspect Ratio")
        return $0
    }(UILabel())

    private lazy var gradientButtons: [CustomCanvasGradientButton] = {
        let titles = ["1:1", "9:16", "4:5", "5:8", "4:3", "3:4"]
        return titles.map { CustomCanvasGradientButton(title: $0) }
    }()

 // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneButton.restartAnimation()
    }

 // MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .mainBackground

        view.addSubview(nameScreenLabel)
        view.addSubview(doneButton)

        for (index, button) in gradientButtons.enumerated() {
            view.addSubview(button)
            button.addTarget(self, action: #selector(gradientButtonTapped(_:)), for: .touchUpInside)
            button.alpha = (index == 0) ? 1.0 : 0.2
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(doneButtonTapped))
        doneButton.addGestureRecognizer(tap)
    }

 // MARK: - Selectors
    @objc
    private func doneButtonTapped() {
        videoCanvasInfo?.resolution = resolution
        delegate?.updateVideoInfo(videoCanvasInfo ?? VideoInfo(resolution: .canvas1x1, duration: TimeInterval(5)))
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func gradientButtonTapped(_ sender: CustomCanvasGradientButton) {
        guard let index = gradientButtons.firstIndex(of: sender) else {
            return
        }
        resolution = resolutions[index]

        for (i, button) in gradientButtons.enumerated() {
            button.alpha = (i == index) ? 1.0 : 0.2
        }
    }
 }

 // MARK: - Constraints
 private extension CanvasViewController {
    func setConstraints() {
        let hui = (UIScreen.main.bounds.width - 326) / 2

        nameScreenLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }

        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameScreenLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(91)
            make.height.equalTo(43)
        }

        for (index, button) in gradientButtons.enumerated() {
            button.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-70)
                make.width.equalTo(46)
                make.height.equalTo(buttonHeight(for: index))

                if index == 0 {
                    make.leading.equalToSuperview().offset(hui)
                }
                else {
                    make.leading.equalTo(gradientButtons[index - 1].snp.trailing).offset(10)
                }
            }
        }
    }

    func buttonHeight(for index: Int) -> CGFloat {
        switch resolutions[index] {
        case .canvas9x16:
            return 82

        case .canvas4x5:
            return 56

        case .canvas5x8:
            return 74

        case .canvas4x3:
            return 35

        case .canvas3x4:
            return 61

        default:
            return 46
        }
    }
 }

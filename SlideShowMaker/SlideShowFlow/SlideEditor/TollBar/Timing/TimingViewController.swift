//
//  TimingViewController.swift
//  ToolBar
//
//  Created by Никитин Артем on 26.12.23.
//

import SnapKit
import UIKit

final class TimingViewController: UIViewController {
// MARK: - Public Properties
    var numberOfImages: Int = 0
    weak var delegate: VideoInfoDelegateProtocol?
    var videoTimeInfo: VideoInfo?

// MARK: - Private Properties
    private var slideshowDuration: Double = 0.0 {
        didSet {
            slideshowDurationTimerLabel.text = ("\(String(format: "%.1f", slideshowDuration))s")
        }
    }

// MARK: - UI Components
    private let customDoneDone: AnimatedGradientButton = {
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
        $0.text = String(localized: "Timing")
        return $0
    }(UILabel())

    private let setDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = String(localized: "Set duration, %")
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.alpha = 0.5
        return label
    }()

    private let slowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = String(localized: "Slow")
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.alpha = 1
        return label
    }()

    private let photosDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = String(localized: "Photos duration")
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.alpha = 0.5
        return label
    }()

    private let slideShowDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = String(localized: "Slideshow duration")
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.alpha = 0.5
        return label
    }()

    private let fastLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = String(localized: "Fast")
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.alpha = 1
        return label
    }()

    private let photosDurationTimerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 33, weight: .semibold)
        label.alpha = 1
        return label
    }()

    private let slideshowDurationTimerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 33, weight: .semibold)
        label.alpha = 1
        return label
    }()

    private let durationSlider: CustomIconSlider = {
        let slider = CustomIconSlider()
        slider.minimumValue = 10
        slider.maximumValue = 100
        slider.value = Float(50)
        return slider
    }()

    private let sliderFieldView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sliderField")
        return imageView
    }()

    private let simpleSlider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(named: "sliderPoint"), for: .normal)
        slider.minimumValue = 10
        slider.minimumTrackTintColor = .mainBackground
        slider.maximumValue = 100
        slider.value = Float(50)
        return slider
    }()

// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setupSliderObservers()
        sliderValueChanged()
    }

// MARK: - UI Setup
    private func setupViews() {
        view.backgroundColor = .mainBackground

        view.addSubview(nameScreenLabel)
        view.addSubview(customDoneDone)
        view.addSubview(setDurationLabel)
        view.addSubview(durationSlider)
        view.addSubview(sliderFieldView)
        view.addSubview(simpleSlider)
        view.addSubview(slowLabel)
        view.addSubview(fastLabel)
        view.addSubview(photosDurationTimerLabel)
        view.addSubview(photosDurationLabel)
        view.addSubview(slideshowDurationTimerLabel)
        view.addSubview(slideShowDurationLabel)

        let tapDoneButton = UITapGestureRecognizer(target: self, action: #selector(doneButtonTapped))
        customDoneDone.addGestureRecognizer(tapDoneButton)

        durationSlider.addTarget(self, action: #selector(sliderAMoved), for: .valueChanged)
        simpleSlider.addTarget(self, action: #selector(sliderBMoved), for: .valueChanged)
    }

// MARK: - Private Methods
    private func setupSliderObservers() {
        durationSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }

    private func updateLabelsAndDuration() {
        let sliderValue = Double(durationSlider.value)
        photosDurationTimerLabel.text = ("\(String(format: "%.1f", sliderValue / 10.0))s")
        slideshowDuration = sliderValue / 10.0 * Double(numberOfImages)
    }

// MARK: - Selectors
    @objc
    func sliderValueChanged() {
        updateLabelsAndDuration()
    }

    @objc
    func sliderAMoved() {
        simpleSlider.setValue(durationSlider.value, animated: false)
        updateLabelsAndDuration()
    }

    @objc
    func sliderBMoved() {
        durationSlider.value = simpleSlider.value
        updateLabelsAndDuration()
    }

    @objc
    func doneButtonTapped() {
        videoTimeInfo?.duration = TimeInterval(slideshowDuration)
        delegate?.updateVideoInfo(videoTimeInfo ?? VideoInfo(resolution: .canvas1x1, duration: TimeInterval(5)))
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Constraints
private extension TimingViewController {
    func setConstraints() {
        nameScreenLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(14)
        }

        customDoneDone.snp.makeConstraints { make in
            make.centerY.equalTo(nameScreenLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-14)
            make.width.equalTo(91)
            make.height.equalTo(43)
        }

        durationSlider.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(sliderFieldView.snp.top).offset(-5)
            make.width.equalTo(250)
        }

        setDurationLabel.snp.makeConstraints { make in
            make.leading.equalTo(sliderFieldView).offset(11)
            make.bottom.equalTo(sliderFieldView.snp.top).offset(-5)
        }

        sliderFieldView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }

        simpleSlider.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.centerY.centerX.equalTo(sliderFieldView)
        }

        slowLabel.snp.makeConstraints { make in
            make.centerY.equalTo(simpleSlider)
            make.leading.equalTo(simpleSlider.snp.trailing).offset(5)
        }

        fastLabel.snp.makeConstraints { make in
            make.centerY.equalTo(simpleSlider)
            make.trailing.equalTo(simpleSlider.snp.leading).offset(-5)
        }

        photosDurationTimerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(23)
            make.top.equalTo(sliderFieldView.snp.bottom).offset(UIScreen.main.bounds.height * 0.05)
        }

        photosDurationLabel.snp.makeConstraints { make in
            make.leading.equalTo(photosDurationTimerLabel)
            make.bottom.equalTo(photosDurationTimerLabel.snp.top).offset(-6)
        }

        slideshowDurationTimerLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-23)
            make.centerY.equalTo(photosDurationTimerLabel)
        }

        slideShowDurationLabel.snp.makeConstraints { make in
            make.trailing.equalTo(slideshowDurationTimerLabel)
            make.bottom.equalTo(slideshowDurationTimerLabel.snp.top).offset(-6)
        }
    }
}

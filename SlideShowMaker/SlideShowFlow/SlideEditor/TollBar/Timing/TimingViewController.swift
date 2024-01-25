//
//  TimingViewController.swift
//  ToolBar
//
//  Created by Никитин Артем on 26.12.23.
//

import SnapKit
import UIKit

final class TimingViewController: UIViewController {
    var numberOfImages: Int = 0

    private var slideshowDuration: Double = 0.0 {
        didSet {
            slideshowDurationTimerLabel.text = ("\(String(format: "%.1f", slideshowDuration))s")
        }
    }

    private let nameScreenLabel = CustomLabel(title: String(localized: "Timing"), size: 22, alpha: 1, fontType: .bold)
    private let setDurationLabel = CustomLabel(title: String(localized: "Set duration, %"), size: 13, alpha: 0.5, fontType: .medium)
    private let slowLabel = CustomLabel(title: String(localized: "Slow"), size: 10, alpha: 1, fontType: .medium)
    private let photosDurationLabel = CustomLabel(title: String(localized: "Photos duration"), size: 13, alpha: 0.5, fontType: .medium)
    private let slideShowDurationLabel = CustomLabel(title: String(localized: "Slideshow duration"), size: 13, alpha: 0.5, fontType: .medium)
    private let fastLabel = CustomLabel(title: String(localized: "Fast"), size: 10, alpha: 1, fontType: .medium)
    private let photosDurationTimerLabel = CustomLabel(title: nil, size: 33, alpha: 1, fontType: .semiBold)
    private let slideshowDurationTimerLabel = CustomLabel(title: nil, size: 33, alpha: 1, fontType: .semiBold)
    private let buttonDone = CustomButton(text: String(localized: "Done"), fontSize: 20)

    private let durationSlider: CustomSlider = {
        let slider = CustomSlider()
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
        slider.minimumTrackTintColor = .labelBlack
        slider.maximumValue = 100
        slider.value = Float(50)
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setupSliderObservers()
        sliderValueChanged()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(nameScreenLabel)
        view.addSubview(buttonDone)
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
        buttonDone.addGestureRecognizer(tapDoneButton)

        durationSlider.addTarget(self, action: #selector(sliderAMoved), for: .valueChanged)
        simpleSlider.addTarget(self, action: #selector(sliderBMoved), for: .valueChanged)
    }

    private func setupSliderObservers() {
        durationSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }

    private func updateLabelsAndDuration() {
        let sliderValue = Double(durationSlider.value)
        photosDurationTimerLabel.text = ("\(String(format: "%.1f", sliderValue / 10.0))s")
        slideshowDuration = sliderValue / 10.0 * Double(numberOfImages)
    }

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
        dismiss(animated: true, completion: nil)
        print(TimeInterval(slideshowDuration))
    }
}

private extension TimingViewController {
    func setConstraints() {
        nameScreenLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(14)
        }

        buttonDone.snp.makeConstraints { make in
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
            make.trailing.equalTo(simpleSlider.snp.leading).offset(-5)
        }

        fastLabel.snp.makeConstraints { make in
            make.centerY.equalTo(simpleSlider)
            make.leading.equalTo(simpleSlider.snp.trailing).offset(5)
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

//
//  CanvasViewController.swift
//  ToolBar
//
//  Created by Никитин Артем on 26.12.23.
//

// import SnapKit
// import UIKit
//
// final class CanvasViewController: UIViewController {
//    private let buttonDone = CustomButton(text: String(localized: "Done"), fontSize: 20)
//    private let nameScreenLabel = CustomLabel(title: String(localized: "Canvas"), size: 22, alpha: 1, fontType: .bold)
//
//    private let gradientButton1 = CustomGradientButton(title: "OK", hasBackground: true, fontSize: .medium)
//    private let gradientButton2 = CustomGradientButton(title: "OK", hasBackground: true, fontSize: .medium)
//    private let gradientButton3 = CustomGradientButton(title: "OK", hasBackground: true, fontSize: .medium)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        setConstraints()
//    }
//
//    private func setupViews() {
//        view.backgroundColor = .systemBackground
//
//        view.addSubview(gradientButton1)
//        view.addSubview(gradientButton2)
//        view.addSubview(gradientButton3)
//
//        view.addSubview(nameScreenLabel)
//        view.addSubview(buttonDone)
//
//        gradientButton1.addTarget(self, action: #selector(buttonTapped1), for: .touchUpInside)
//        gradientButton2.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
//        gradientButton3.addTarget(self, action: #selector(buttonTapped3), for: .touchUpInside)
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(doneButtonTapped))
//        buttonDone.addGestureRecognizer(tap)
//    }
//
//    @objc
//    func doneButtonTapped() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    @objc func buttonTapped1() {
//        print("Кнопка 1 была нажата")
//    }
//    
//    @objc func buttonTapped2() {
//        print("Кнопка 2 была нажата")
//    }
//    
//    @objc func buttonTapped3() {
//        print("Кнопка 3 была нажата")
//    }
// }
//
// private extension CanvasViewController {
//    func setConstraints() {
//        gradientButton1.snp.makeConstraints { make in
//            make.centerY.centerX.equalToSuperview()
//            make.width.equalTo(50)
//            make.height.equalTo(50)
//        }
//        gradientButton2.snp.makeConstraints { make in
//            make.centerY.equalTo(gradientButton1)
//            make.trailing.equalTo(gradientButton1.snp.leading).offset(-20)
//            make.width.equalTo(50)
//            make.height.equalTo(50)
//        }
//        gradientButton3.snp.makeConstraints { make in
//            make.centerY.equalTo(gradientButton1)
//            make.leading.equalTo(gradientButton1.snp.trailing).offset(20)
//            make.width.equalTo(50)
//            make.height.equalTo(50)
//        }
//
//        nameScreenLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(20)
//        }
//
//        buttonDone.snp.makeConstraints { make in
//            make.centerY.equalTo(nameScreenLabel.snp.centerY)
//            make.trailing.equalToSuperview().offset(-20)
//            make.width.equalTo(91)
//            make.height.equalTo(43)
//        }
//    }
// }

import SnapKit
import UIKit

final class CanvasViewController: UIViewController {
    private let gradientButton1 = CustomGradientButton(title: "1:1")
    private let gradientButton2 = CustomGradientButton(title: "9:16")
    private let gradientButton3 = CustomGradientButton(title: "4:5")
    private let gradientButton4 = CustomGradientButton(title: "5:8")
    private let gradientButton5 = CustomGradientButton(title: "4:3")
    private let gradientButton6 = CustomGradientButton(title: "3:4")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(gradientButton1)
        view.addSubview(gradientButton2)
        view.addSubview(gradientButton3)
        view.addSubview(gradientButton4)
        view.addSubview(gradientButton5)
        view.addSubview(gradientButton6)


        gradientButton1.addTarget(self, action: #selector(buttonTapped1), for: .touchUpInside)
        gradientButton2.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
        gradientButton3.addTarget(self, action: #selector(buttonTapped3), for: .touchUpInside)
        gradientButton4.addTarget(self, action: #selector(buttonTapped4), for: .touchUpInside)
        gradientButton5.addTarget(self, action: #selector(buttonTapped5), for: .touchUpInside)
        gradientButton6.addTarget(self, action: #selector(buttonTapped6), for: .touchUpInside)

        // Начальная настройка прозрачности кнопок
        gradientButton2.alpha = 0.1
        gradientButton3.alpha = 0.1
        gradientButton4.alpha = 0.1
        gradientButton5.alpha = 0.1
        gradientButton6.alpha = 0.1
    }

    @objc func buttonTapped1() {
        print("Кнопка 1 была нажата")
        gradientButton1.alpha = 1
        gradientButton2.alpha = 0.1
        gradientButton3.alpha = 0.1
        gradientButton4.alpha = 0.1
        gradientButton5.alpha = 0.1
        gradientButton6.alpha = 0.1
    }

    @objc func buttonTapped2() {
        print("Кнопка 2 была нажата")
        gradientButton1.alpha = 0.1
        gradientButton2.alpha = 1
        gradientButton3.alpha = 0.1
        gradientButton4.alpha = 0.1
        gradientButton5.alpha = 0.1
        gradientButton6.alpha = 0.1
    }

    @objc func buttonTapped3() {
        print("Кнопка 3 была нажата")
        gradientButton1.alpha = 0.1
        gradientButton2.alpha = 0.1
        gradientButton3.alpha = 1
        gradientButton4.alpha = 0.1
        gradientButton5.alpha = 0.1
        gradientButton6.alpha = 0.1
    }
    
    @objc func buttonTapped4() {
        print("Кнопка 4 была нажата")
        gradientButton1.alpha = 0.1
        gradientButton2.alpha = 0.1
        gradientButton3.alpha = 0.1
        gradientButton4.alpha = 1
        gradientButton5.alpha = 0.1
        gradientButton6.alpha = 0.1
    }

    @objc func buttonTapped5() {
        print("Кнопка 5 была нажата")
        gradientButton1.alpha = 0.1
        gradientButton2.alpha = 0.1
        gradientButton3.alpha = 0.1
        gradientButton4.alpha = 0.1
        gradientButton5.alpha = 1
        gradientButton6.alpha = 0.1
    }

    @objc func buttonTapped6() {
        print("Кнопка 6 была нажата")
        gradientButton1.alpha = 0.1
        gradientButton2.alpha = 0.1
        gradientButton3.alpha = 0.1
        gradientButton4.alpha = 0.1
        gradientButton5.alpha = 0.1
        gradientButton6.alpha = 1
    }
}

private extension CanvasViewController {
    func setConstraints() {
        gradientButton1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.bottom.equalToSuperview().offset(-70)
            make.width.equalTo(46)
            make.height.equalTo(46)
        }
        gradientButton2.snp.makeConstraints { make in
            make.leading.equalTo(gradientButton1.snp.trailing).offset(10)
            make.bottom.equalToSuperview().offset(-70)
            make.width.equalTo(46)
            make.height.equalTo(82)
        }
        gradientButton3.snp.makeConstraints { make in
            make.leading.equalTo(gradientButton2.snp.trailing).offset(10)
            make.bottom.equalToSuperview().offset(-70)
            make.width.equalTo(46)
            make.height.equalTo(56)
        }
        gradientButton4.snp.makeConstraints { make in
            make.leading.equalTo(gradientButton3.snp.trailing).offset(10)
            make.bottom.equalToSuperview().offset(-70)
            make.width.equalTo(46)
            make.height.equalTo(74)
        }
        gradientButton5.snp.makeConstraints { make in
            make.leading.equalTo(gradientButton4.snp.trailing).offset(10)
            make.bottom.equalToSuperview().offset(-70)
            make.width.equalTo(46)
            make.height.equalTo(35)
        }
        gradientButton6.snp.makeConstraints { make in
            make.leading.equalTo(gradientButton5.snp.trailing).offset(10)
            make.bottom.equalToSuperview().offset(-70)
            make.width.equalTo(46)
            make.height.equalTo(61)
        }
        
    }
}

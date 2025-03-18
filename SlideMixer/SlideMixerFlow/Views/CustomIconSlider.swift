//
//  CustomIconSlider.swift
//  SlideMixer
//
//  Created by Никитин Артем on 22.01.24.
//

import UIKit

final class CustomIconSlider: UISlider {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSlider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupSlider() {
        minimumTrackTintColor = .clear
        maximumTrackTintColor = .clear

        setThumbImage(createThumbImage(), for: .normal)
    }

    private func createThumbImage() -> UIImage {
        let thumbSize = CGSize(width: 33, height: 33)
        let cornerRadius: CGFloat = 10

        let renderer = UIGraphicsImageRenderer(size: thumbSize)

        let thumbImage = renderer.image { context in
            let rect = CGRect(x: 0, y: 0, width: thumbSize.width, height: thumbSize.height)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

            context.cgContext.setFillColor(UIColor.black.cgColor)
            context.cgContext.addPath(path.cgPath)
            context.cgContext.fillPath()

            let valueText = String(format: "%.f", value)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.white
            ]
            let textSize = valueText.size(withAttributes: attributes)
            let textOrigin = CGPoint(x: (thumbSize.width - textSize.width) / 2, y: (thumbSize.height - textSize.height) / 2)
            valueText.draw(at: textOrigin, withAttributes: attributes)
        }

        return thumbImage.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }

    override var value: Float {
        didSet {
            updateThumbImage()
        }
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let beganTracking = super.beginTracking(touch, with: event)
        updateThumbImage()
        return beganTracking
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let continuedTracking = super.continueTracking(touch, with: event)
        updateThumbImage()
        return continuedTracking
    }

    private func updateThumbImage() {
        setThumbImage(createThumbImage(), for: .normal)
    }
}

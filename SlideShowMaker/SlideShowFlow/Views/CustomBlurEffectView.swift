//
//  CustomBlurEffectView.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 14.03.25.
//

import UIKit

final class CustomBlurEffectView: UIVisualEffectView {
    private let theEffect: UIVisualEffect
    private let fractionComplete: CGFloat
    private var animator: UIViewPropertyAnimator?
    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - fractionComplete: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(effect: UIVisualEffect, fractionComplete: CGFloat) {
        theEffect = effect
        self.fractionComplete = fractionComplete
        super.init(effect: nil)
    }

    required init?(coder aDecoder: NSCoder) { nil }

    deinit {
        animator?.stopAnimation(true)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = theEffect
        }
        animator?.fractionComplete = fractionComplete
    }
}

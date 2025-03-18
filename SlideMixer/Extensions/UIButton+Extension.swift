//
//  UIButton+Extension.swift
//  AkimTest
//
//  Created by Никитин Артем on 16.05.24.
//

import UIKit

extension UIButton {
    func animateButton() {
        UIView.animate(withDuration: 0.08, animations: {
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }) { _ in
            UIView.animate(withDuration: 0.08) {
                self.transform = .identity
            }
        }
    }
}

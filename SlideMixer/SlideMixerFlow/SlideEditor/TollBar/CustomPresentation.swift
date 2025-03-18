//
//  CustomPresentation.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 27.12.23.
//

import UIKit

final class CustomPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }

        let height = containerView.frame.height * 0.32
        let width = containerView.frame.width
        return CGRect(x: 0, y: containerView.frame.height - height, width: width, height: height)
    }
}

//
//  CustomPresentation.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 27.12.23.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }
        let height = containerView.frame.height / 3
        let width = containerView.frame.width
        return CGRect(x: 0, y: containerView.frame.height - height, width: width, height: height)
    }
}

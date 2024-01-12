//
//  VideoInfo.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 12.01.24.
//

import Foundation

struct VideoInfo {
    var resolution: VideoResolution
    var duration: TimeInterval
    var frameRate: Int
}

enum VideoResolution {
    case canvas1x1
    case canvas9x16
    case canvas3x4

    var size: CGSize {
        switch self {
        case .canvas1x1:
            return CGSize(width: 3024, height: 3024)

        case .canvas9x16:
            return CGSize(width: 2268, height: 4032)

        case .canvas3x4:
            return CGSize(width: 3024, height: 4032)
        }
    }
}

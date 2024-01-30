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
}

enum VideoResolution {
    case canvas1x1
    case canvas9x16
    case canvas3x4
    case canvas4x3
    case canvas4x5
    case canvas5x8

    var size: CGSize {
        switch self {
        case .canvas1x1:
            return CGSize(width: 3024, height: 3024)

        case .canvas9x16:
            return CGSize(width: 2268, height: 4032)

        case .canvas3x4:
            return CGSize(width: 2420, height: 3226)

        case .canvas4x3:
            return CGSize(width: 3226, height: 2420)

        case .canvas4x5:
            return CGSize(width: 2580, height: 3226)

        case .canvas5x8:
            return CGSize(width: 2016, height: 3226)
        }
    }
}

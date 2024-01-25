//
//  VideoCreator.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 11.01.24.
//

import AVFoundation
import Photos
import UIKit

final class VideoCreator {
    private var images: [UIImage]
    private let frameRate = 5

    init(images: [UIImage]) {
        self.images = images
    }

    func createVideo(videoInfo: VideoInfo, completion: @escaping (URL?) -> Void) {
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")

        guard let videoWriter = try? AVAssetWriter(outputURL: outputURL, fileType: .mov) else {
            completion(nil)
            return
        }

        let totalFrames = Int(videoInfo.duration * Double(self.frameRate))
        let framesPerImage = max(1, totalFrames / images.count)

        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: videoInfo.resolution.size.width as NSNumber,
            AVVideoHeightKey: videoInfo.resolution.size.height as NSNumber
        ]

        guard let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings) as AVAssetWriterInput?,
              videoWriter.canAdd(videoWriterInput) else {
            completion(nil)
            return
        }

        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: nil)

        videoWriter.add(videoWriterInput)

        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: .zero)

        let queue = DispatchQueue(label: "VideoQueue", qos: .default, attributes: .concurrent)

        videoWriterInput.requestMediaDataWhenReady(on: queue) {
            var frameCount = 0

            while videoWriterInput.isReadyForMoreMediaData, frameCount < totalFrames {
                let imageIndex = min(frameCount / framesPerImage, self.images.count - 1)
                let presentationTime = CMTimeMake(value: Int64(frameCount), timescale: Int32(self.frameRate))

                guard let buffer = self.pixelBuffer(from: self.images[imageIndex], resolution: videoInfo.resolution) else {
                    completion(nil)
                    return
                }

                if !adaptor.append(buffer, withPresentationTime: presentationTime) {
                    completion(nil)
                    return
                }

                frameCount += 1
            }

            videoWriterInput.markAsFinished()

            videoWriter.finishWriting {
                if videoWriter.status == .failed || videoWriter.status == .unknown {
                    completion(nil)
                }
                else {
                    self.saveVideoToGallery(outputURL, completion: completion)
                }
            }
        }
    }

    private func pixelBuffer(from image: UIImage, resolution: VideoResolution) -> CVPixelBuffer? {
        let options: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(resolution.size.width), Int(resolution.size.height), kCVPixelFormatType_32ARGB, options as CFDictionary, &pixelBuffer)

        guard status == kCVReturnSuccess, let pixelBuffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let context = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer), width: Int(resolution.size.width), height: Int(resolution.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        let aspectRatio = image.size.width / image.size.height
        let targetWidth: CGFloat
        let targetHeight: CGFloat

        if aspectRatio > resolution.size.width / resolution.size.height {
            targetWidth = resolution.size.width
            targetHeight = resolution.size.width / aspectRatio
        }
        else {
            targetWidth = resolution.size.height * aspectRatio
            targetHeight = resolution.size.height
        }

        let xOffset = (resolution.size.width - targetWidth) / 2
        let yOffset = (resolution.size.height - targetHeight) / 2

        context?.translateBy(x: resolution.size.width / 2, y: resolution.size.height / 2)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: -resolution.size.width / 2, y: -resolution.size.height / 2)
        context?.translateBy(x: xOffset, y: yOffset)
        context?.scaleBy(x: targetWidth / image.size.width, y: targetHeight / image.size.height)

        if let context = context {
            UIGraphicsPushContext(context)
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            UIGraphicsPopContext()
        }

        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }

    private func saveVideoToGallery(_ url: URL, completion: @escaping (URL?) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }, completionHandler: { success, _ in
            if success {
                DispatchQueue.main.async {
                    completion(url)
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        })
    }
}

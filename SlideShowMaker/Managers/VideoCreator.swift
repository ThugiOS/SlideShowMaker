//
//  VideoCreator.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 11.01.24.
//

import AVFoundation
import Photos
import UIKit

/// The `VideoCreator` class facilitates the creation of a video by combining a sequence of images.
final class VideoCreator {
    private var images: [UIImage]   // Array of UIImage objects representing frames of the video
    private let frameRate = 5       // Frames per second

    /// Initializes a `VideoCreator` object with an array of UIImage objects.
    ///
    /// - Parameter images: An array of UIImage objects representing frames of the video.
    init(images: [UIImage]) {
        self.images = images
    }

    /// Generates a video by combining provided images with specified video parameters.
    ///
    /// - Parameters:
    ///   - videoInfo: An object of type `VideoInfo` containing information about the video.
    ///   - completion: A closure called upon completion of video generation, providing a URL to the generated video file or `nil` if an error occurs.
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

        videoWriterInput.requestMediaDataWhenReady(on: queue) { [weak self] in
            guard let self else {
                return
            }

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

    /// Converts a UIImage object into a CVPixelBuffer with the specified resolution.
    ///
    /// - Parameters:
    ///   - image: The UIImage object to be converted into a pixel buffer.
    ///   - resolution: An object of type `VideoResolution` specifying the resolution of the video.
    /// - Returns: A CVPixelBuffer representing the image in the specified resolution.
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

        // Lock the pixel buffer and create a CGContext for drawing.
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let context = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer), width: Int(resolution.size.width), height: Int(resolution.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        // Calculate aspect ratio and target dimensions for drawing.
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

        // Calculate offsets and scaling for centering and resizing.
        let xOffset = (resolution.size.width - targetWidth) / 2
        let yOffset = (resolution.size.height - targetHeight) / 2

        context?.translateBy(x: resolution.size.width / 2, y: resolution.size.height / 2)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: -resolution.size.width / 2, y: -resolution.size.height / 2)
        context?.translateBy(x: xOffset, y: yOffset)
        context?.scaleBy(x: targetWidth / image.size.width, y: targetHeight / image.size.height)

        // Draw the image onto the pixel buffer.
        if let context = context {
            UIGraphicsPushContext(context)
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            UIGraphicsPopContext()
        }

        // Unlock the pixel buffer before returning.
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }

    /// Saves the generated video to the device's photo gallery using the Photos framework.
    ///
    /// - Parameters:
    ///   - url: The URL of the generated video file.
    ///   - completion: A closure called upon completion of the save operation, providing a URL to the saved video file or `nil` if the operation fails.
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

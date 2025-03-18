//
//  VideoCreator.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 11.01.24.
//

import AVFoundation
import Photos
import UIKit

/// Класс `VideoCreator` облегчает создание видео путем объединения последовательности изображений.
final class VideoCreator {
    private var images: [UIImage]   // Массив объектов UIImage, представляющих кадры видео
    private let frameRate = 5       // Кадров в секунду

    /// Инициализирует объект `VideoCreator` с массивом объектов UIImage.
    ///
    /// - Parameter images: Массив объектов UIImage, представляющих кадры видео.
    init(images: [UIImage]) {
        self.images = images
    }

    /// Генерирует видео путем объединения предоставленных изображений с указанными параметрами видео.
    ///
    /// - Parameters:
    ///   - videoInfo: Объект типа `VideoInfo`, содержащий информацию о видео.
    ///   - completion: Замыкание, вызываемое по завершении создания видео, предоставляющее URL сгенерированного видеофайла или `nil` в случае ошибки.
    func createVideo(videoInfo: VideoInfo, completion: @escaping (URL?) -> Void) {
        // Создаем временный путь для сохранения видеофайла
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")

        // Создаем объект AVAssetWriter для записи видеофайла
        guard let videoWriter = try? AVAssetWriter(outputURL: outputURL, fileType: .mov) else {
            completion(nil)
            return
        }

        // Рассчитываем общее количество кадров и количество кадров для каждого изображения
        let totalFrames = Int(videoInfo.duration * Double(self.frameRate))
        let framesPerImage = max(1, totalFrames / images.count)

        // Устанавливаем параметры видео
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: videoInfo.resolution.size.width as NSNumber,
            AVVideoHeightKey: videoInfo.resolution.size.height as NSNumber
        ]

        // Создаем объект AVAssetWriterInput для записи видео
        guard let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings) as AVAssetWriterInput?,
              videoWriter.canAdd(videoWriterInput) else {
            completion(nil)
            return
        }

        // Создаем адаптер для записи пиксельных буферов в видео
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: nil)

        // Добавляем видеоинпут в AVAssetWriter
        videoWriter.add(videoWriterInput)

        // Начинаем запись видео
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: .zero)

        // Создаем очередь для обработки данных видео
        let queue = DispatchQueue(label: "VideoQueue", qos: .default, attributes: .concurrent)

        // Запрашиваем данные для записи, когда видеоинпут готов принять их
        videoWriterInput.requestMediaDataWhenReady(on: queue) { [weak self] in
            guard let self = self else {
                return
            }

            var frameCount = 0

            // Пока видеоинпут готов принять данные и количество кадров меньше общего количества кадров
            while videoWriterInput.isReadyForMoreMediaData, frameCount < totalFrames {
                // Определяем индекс текущего изображения
                let imageIndex = min(frameCount / framesPerImage, self.images.count - 1)
                // Определяем время показа текущего кадра
                let presentationTime = CMTimeMake(value: Int64(frameCount), timescale: Int32(self.frameRate))

                // Преобразуем изображение в пиксельный буфер
                guard let buffer = self.pixelBuffer(from: self.images[imageIndex], resolution: videoInfo.resolution) else {
                    completion(nil)
                    return
                }

                // Добавляем пиксельный буфер в видео с указанием времени показа
                if !adaptor.append(buffer, withPresentationTime: presentationTime) {
                    completion(nil)
                    return
                }

                // Увеличиваем счетчик кадров
                frameCount += 1
            }

            // Помечаем видеоинпут как завершенный
            videoWriterInput.markAsFinished()

            // Завершаем запись видео
            videoWriter.finishWriting {
                if videoWriter.status == .failed || videoWriter.status == .unknown {
                    completion(nil)
                }
                else {
                    // Сохраняем видео в фотогалерею
                    self.saveVideoToGallery(outputURL, completion: completion)
                }
            }
        }
    }

    /// Преобразует объект UIImage в CVPixelBuffer с указанным разрешением.
    ///
    /// - Parameters:
    ///   - image: Объект UIImage для преобразования в пиксельный буфер.
    ///   - resolution: Объект типа `VideoResolution`, указывающий разрешение видео.
    /// - Returns: CVPixelBuffer, представляющий изображение с указанным разрешением.
    private func pixelBuffer(from image: UIImage, resolution: VideoResolution) -> CVPixelBuffer? {
        // Устанавливаем опции для создания пиксельного буфера
        let options: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]

        // Создаем пиксельный буфер
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(resolution.size.width), Int(resolution.size.height), kCVPixelFormatType_32ARGB, options as CFDictionary, &pixelBuffer)

        // Проверяем успешность создания пиксельного буфера
        guard status == kCVReturnSuccess, let pixelBuffer = pixelBuffer else {
            return nil
        }

        // Блокируем пиксельный буфер и создаем CGContext для рисования
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let context = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer), width: Int(resolution.size.width), height: Int(resolution.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        // Рассчитываем соотношение сторон и целевые размеры для рисования
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

        // Рассчитываем смещения и масштабирование для центрирования и изменения размера
        let xOffset = (resolution.size.width - targetWidth) / 2
        let yOffset = (resolution.size.height - targetHeight) / 2

        context?.translateBy(x: resolution.size.width / 2, y: resolution.size.height / 2)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: -resolution.size.width / 2, y: -resolution.size.height / 2)
        context?.translateBy(x: xOffset, y: yOffset)
        context?.scaleBy(x: targetWidth / image.size.width, y: targetHeight / image.size.height)

        // Рисуем изображение на пиксельный буфер
        if let context = context {
            UIGraphicsPushContext(context)
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            UIGraphicsPopContext()
        }

        // Разблокируем пиксельный буфер перед возвратом
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }

    /// Сохраняет сгенерированное видео в фотогалерею устройства с использованием фреймворка Photos.
    ///
    /// - Parameters:
    ///   - url: URL сгенерированного видеофайла.
    ///   - completion: Замыкание, вызываемое по завершении сохранения, предоставляющее URL сохраненного видеофайла или `nil` в случае неудачи.
    private func saveVideoToGallery(_ url: URL, completion: @escaping (URL?) -> Void) {
        // Выполняем изменения в фотогалерее
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }, completionHandler: { success, _ in
            // Проверяем успешность сохранения
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

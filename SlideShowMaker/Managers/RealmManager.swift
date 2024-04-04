//
//  RealmManager.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 14.03.24.
//

import Foundation
import RealmSwift
import UIKit

final class RealmManager {
    static let shared = RealmManager()

    private let realm: Realm

    private init() {
        // Use a failable initializer for Realm
        do {
            self.realm = try Realm()
        }
        catch {
            fatalError("Error initializing Realm: \(error.localizedDescription)")
        }
    }

    func saveProject(images: [UIImage], date: Date, index: Int) {
        do {
            try realm.write {
                let project = Project()
                let imagePaths = saveImagesToDisk(images: images, projectIndex: index)
                project.imagePaths.append(objectsIn: imagePaths)
                project.date = date
                project.name = "Project \(index)"
                realm.add(project)
            }
        }
        catch {
            print("Error saving project: \(error.localizedDescription)")
        }
    }

    private func saveImagesToDisk(images: [UIImage], projectIndex: Int) -> List<String> {
        let imagePaths = List<String>()

        for (index, image) in images.enumerated() {
            guard let imageData = image.pngData() else { continue }

            let fileName = "image_\(projectIndex)_\(index).png"
            let imagePath = FileManager.documentsDirectoryURL.appendingPathComponent(fileName)

            do {
                try imageData.write(to: imagePath)
                imagePaths.append(fileName)
            }
            catch {
                print("Error saving image: \(error.localizedDescription)")
            }
        }

        return imagePaths
    }

    func loadProjects() -> Results<Project> {
        return realm.objects(Project.self)
    }
}

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
        do {
            self.realm = try Realm()
        }
        catch {
            fatalError("Error initializing Realm: \(error.localizedDescription)")
        }
    }

    // MARK: - Save Project
    func saveProject(images: [UIImage], name: String, date: Date, index: Int, duration: TimeInterval) {
        do {
            try realm.write {
                let project = Project()
                let imagePaths = saveImagesToDisk(images: images, projectIndex: index)
                project.imagePaths.append(objectsIn: imagePaths)
                project.date = date
                project.name = name
                project.archive = false
                project.duration = duration
                realm.add(project)
            }
        }
        catch {
            print("Error saving project: \(error.localizedDescription)")
        }
    }

    // MARK: - Send to archive
    func sendToArchive(project: Project) {
        do {
            try realm.write {
                project.archive = true
            }
        }
        catch {
            print("Error archiving project: \(error.localizedDescription)")
        }
    }

    // MARK: - Return from archive
    func returnFromArchive(project: Project) {
        do {
            try realm.write {
                project.archive = false
            }
        }
        catch {
            print("Error unarchiving project: \(error.localizedDescription)")
        }
    }

    // MARK: - Save duration
    func saveDuration(project: Project, duration: TimeInterval) {
        do {
            try realm.write {
                project.duration = duration
            }
        }
        catch {
            print("Error saving duration: \(error.localizedDescription)")
        }
    }

    // MARK: - Load projects
    func loadProjects() -> Results<Project> {
        return realm.objects(Project.self).filter("archive == false")
    }

    // MARK: - Load archive
    func loadArchiveProjects() -> Results<Project> {
        return realm.objects(Project.self).filter("archive == true")
    }

    // MARK: - Clear archive
    func deleteAllArchivedProjects() {
        do {
            let archivedProjects = loadArchiveProjects()
            try realm.write {
                realm.delete(archivedProjects)
            }
        }
        catch {
            print("Error deleting archived projects: \(error.localizedDescription)")
        }
    }

    func deleteAllProjects() {
        do {
            let allProjects = loadProjects()
            let archiveProjects = loadArchiveProjects()
            try realm.write {
                realm.delete(allProjects)
                realm.delete(archiveProjects)
            }
        }
        catch {
            print("Error deleting projects: \(error.localizedDescription)")
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
}

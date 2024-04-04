//
//  FileManager.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 14.03.24.
//

import Foundation

extension FileManager {
    static var documentsDirectoryURL: URL {
        // Use optional binding to safely unwrap the documents directory URL
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Documents directory URL not found.")
        }
        return documentsDirectoryURL
    }
}

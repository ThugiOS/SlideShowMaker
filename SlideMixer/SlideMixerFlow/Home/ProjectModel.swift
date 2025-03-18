//
//  ProjectModel.swift
//  SlideMixer
//
//  Created by Никитин Артем on 14.03.24.
//

import Foundation
import RealmSwift

class Project: Object {
    @Persisted var imagePaths = List<String>()
    @Persisted var date = Date()
    @Persisted var name = ""
    @Persisted var archive = false
    @Persisted var duration = TimeInterval()
}

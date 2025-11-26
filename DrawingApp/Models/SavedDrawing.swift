//
//  SavedDrawing.swift
//  DrawingApp
//
//  Created on 2025-11-26.
//

import Foundation

struct SavedDrawing: Identifiable, Codable {

    let id: UUID
    let name: String
    let date: Date
    let paths: [DrawingPath]
    
    init(id: UUID = UUID(), name: String, date: Date = Date(), paths: [DrawingPath]) {
        self.id = id
        self.name = name
        self.date = date
        self.paths = paths
    }

}


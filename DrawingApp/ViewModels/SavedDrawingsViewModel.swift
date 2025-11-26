//
//  SavedDrawingsViewModel.swift
//  DrawingApp
//
//  Created on 2025-11-26.
//

import SwiftUI
import Foundation

class SavedDrawingsViewModel: ObservableObject {

    @Published var savedDrawings: [SavedDrawing] = []
    
    private let documentsDirectory: URL
    private let drawingsDirectory: URL
    
    init() {
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        drawingsDirectory = documentsDirectory.appendingPathComponent("Drawings", isDirectory: true)
        
        // Drawingsディレクトリを作成
        try? FileManager.default.createDirectory(at: drawingsDirectory, withIntermediateDirectories: true)
        
        loadSavedDrawings()
    }
    
    @discardableResult
    func saveDrawing(name: String, paths: [DrawingPath]) -> SavedDrawing {
        let drawing = SavedDrawing(name: name, paths: paths)
        savedDrawings.append(drawing)
        
        let fileURL = drawingsDirectory.appendingPathComponent("\(drawing.id.uuidString).json")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(drawing)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save drawing: \(error)")
        }
        
        return drawing
    }
    
    func updateDrawing(_ drawing: SavedDrawing, with paths: [DrawingPath]) {
        guard let index = savedDrawings.firstIndex(where: { $0.id == drawing.id }) else { return }
        
        let updatedDrawing = SavedDrawing(id: drawing.id, name: drawing.name, date: Date(), paths: paths)
        savedDrawings[index] = updatedDrawing
        
        let fileURL = drawingsDirectory.appendingPathComponent("\(drawing.id.uuidString).json")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(updatedDrawing)
            try data.write(to: fileURL)
        } catch {
            print("Failed to update drawing: \(error)")
        }
    }
    
    func deleteDrawing(_ drawing: SavedDrawing) {
        savedDrawings.removeAll { $0.id == drawing.id }
        
        let fileURL = drawingsDirectory.appendingPathComponent("\(drawing.id.uuidString).json")
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    func loadDrawing(_ drawing: SavedDrawing) -> [DrawingPath] {
        return drawing.paths
    }
    
    private func loadSavedDrawings() {
        guard let files = try? FileManager.default.contentsOfDirectory(at: drawingsDirectory, includingPropertiesForKeys: nil) else {
            return
        }
        
        let jsonFiles = files.filter { $0.pathExtension == "json" }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        savedDrawings = jsonFiles.compactMap { fileURL in
            guard let data = try? Data(contentsOf: fileURL),
                  let drawing = try? decoder.decode(SavedDrawing.self, from: data) else {
                return nil
            }
            return drawing
        }.sorted { $0.date > $1.date }
    }

}


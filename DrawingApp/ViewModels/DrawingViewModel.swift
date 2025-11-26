//
//  DrawingViewModel.swift
//  DrawingApp
//
//  Created on 2025-11-26.
//

import SwiftUI
import Combine
import Foundation

class DrawingViewModel: ObservableObject {

    @Published var paths: [DrawingPath] = []
    @Published var currentColor: Color = .black
    @Published var currentLineWidth: CGFloat = 5.0
    @Published var isEraserMode: Bool = false
    
    private var undoStack: [[DrawingPath]] = []
    private var redoStack: [[DrawingPath]] = []
    
    var canUndo: Bool {
        !undoStack.isEmpty
    }
    
    var canRedo: Bool {
        !redoStack.isEmpty
    }
    
    func addPath(_ path: DrawingPath) {
        saveState()
        paths.append(path)
    }
    
    func undo() {
        guard !undoStack.isEmpty else { return }
        redoStack.append(paths)
        paths = undoStack.removeLast()
    }
    
    func redo() {
        guard !redoStack.isEmpty else { return }
        undoStack.append(paths)
        paths = redoStack.removeLast()
    }
    
    func clear() {
        saveState()
        paths.removeAll()
    }
    
    func loadPaths(_ loadedPaths: [DrawingPath]) {
        saveState()
        paths = loadedPaths
    }
    
    private func saveState() {
        undoStack.append(paths)
        redoStack.removeAll()
        // メモリ使用量を制限（最大50ステップ）
        if undoStack.count > 50 {
            undoStack.removeFirst()
        }
    }

}


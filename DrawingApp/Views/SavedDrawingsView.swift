//
//  SavedDrawingsView.swift
//  DrawingApp
//
//  Created on 2025-11-26.
//

import SwiftUI

struct SavedDrawingsView: View {

    @ObservedObject var savedDrawingsViewModel: SavedDrawingsViewModel
    @Environment(\.dismiss) var dismiss
    let onSelect: (SavedDrawing) -> Void
    let onDelete: (SavedDrawing) -> Void
    
    @State private var drawingToDelete: SavedDrawing?
    @State private var showDeleteAlert = false
    @State private var isEditMode = false
    
    var body: some View {
        NavigationView {
            List {
                if savedDrawingsViewModel.savedDrawings.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "folder")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("保存された描画がありません")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(savedDrawingsViewModel.savedDrawings) { drawing in
                        SavedDrawingRow(
                            drawing: drawing,
                            isEditMode: isEditMode,
                            onSelect: {
                                if !isEditMode {
                                    onSelect(drawing)
                                }
                            },
                            onDelete: {
                                drawingToDelete = drawing
                                showDeleteAlert = true
                            }
                        )
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                drawingToDelete = drawing
                                showDeleteAlert = true
                            } label: {
                                Label("削除", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .navigationTitle("保存された描画")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditMode ? "完了" : "編集") {
                        isEditMode.toggle()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") {
                        dismiss()
                    }
                }
            }
            .alert("削除", isPresented: $showDeleteAlert) {
                Button("削除", role: .destructive) {
                    if let drawing = drawingToDelete {
                        onDelete(drawing)
                        drawingToDelete = nil
                    }
                }
                Button("キャンセル", role: .cancel) {
                    drawingToDelete = nil
                }
            } message: {
                Text("この描画を削除しますか？")
            }
        }
    }

}

#Preview {
    SavedDrawingsView(
        savedDrawingsViewModel: SavedDrawingsViewModel(),
        onSelect: { _ in },
        onDelete: { _ in }
    )
}


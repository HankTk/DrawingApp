//
//  SavedDrawingRow.swift
//  DrawingApp
//
//  Created on 2025-11-26.
//

import SwiftUI

struct SavedDrawingRow: View {

    let drawing: SavedDrawing
    let isEditMode: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(drawing.name)
                    .font(.headline)
                Text(dateFormatter.string(from: drawing.date))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            if isEditMode {
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
    }

}

#Preview("Drawing Row") {
    List {
        SavedDrawingRow(
            drawing: SavedDrawing(name: "テスト描画", paths: []),
            isEditMode: false,
            onSelect: {},
            onDelete: {}
        )
        SavedDrawingRow(
            drawing: SavedDrawing(name: "テスト描画2", paths: []),
            isEditMode: true,
            onSelect: {},
            onDelete: {}
        )
    }
}


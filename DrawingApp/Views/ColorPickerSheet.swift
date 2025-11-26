//
//  ColorPickerSheet.swift
//  DrawingApp
//
//  Created on 2025-11-26.
//

import SwiftUI

struct ColorPickerSheet: View {

    @Binding var selectedColor: Color
    @Environment(\.dismiss) var dismiss
    let onColorSelected: (Color) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // カラーピッカー
                ColorPicker("色を選択", selection: $selectedColor, supportsOpacity: false)
                    .padding()
                
                // プレビュー
                VStack(spacing: 12) {
                    Text("プレビュー")
                        .font(.headline)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedColor)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // 選択された色の情報
                    Text(colorDescription(selectedColor))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(white: 0.95))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("カスタムカラー")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("適用") {
                        onColorSelected(selectedColor)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func colorDescription(_ color: Color) -> String {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return String(format: "RGB: %d, %d, %d",
                     Int(red * 255),
                     Int(green * 255),
                     Int(blue * 255))
    }

}

#Preview {
    ColorPickerSheet(
        selectedColor: .constant(.blue),
        onColorSelected: { _ in }
    )
}


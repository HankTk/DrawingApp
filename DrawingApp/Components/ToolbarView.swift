//
//  ToolbarView.swift
//  DrawingApp
//
//  Created on 2025-11-26.
//

import SwiftUI

struct ToolbarView: View {

    @ObservedObject var viewModel: DrawingViewModel
    @Binding var showColorPicker: Bool
    @Binding var customColor: Color
    
    let onNewAction: () -> Void
    let onSaveAction: () -> Void
    let onLoadAction: () -> Void
    let saveButtonTitle: String
    
    let colors: [Color] = [
        .black, .red, .blue, .green, .yellow, .orange, .purple, .pink, .brown, .gray
    ]
    
    let lineWidths: [CGFloat] = [1, 3, 5, 8, 12, 16, 20]
    
    // カスタムカラーが選択されているかチェック
    private var isCustomColorSelected: Bool {
        let currentUIColor = UIColor(viewModel.currentColor)
        return !colors.contains { color in
            UIColor(color).isEqual(currentUIColor)
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // 色選択
            colorSelectionView
            
            // ペンの太さ選択
            lineWidthSelectionView
            
            // ツールボタン
            toolButtonsView
            
            // 保存・読み込み・新規ボタン
            fileActionButtonsView
        }
    }
    
    private var colorSelectionView: some View {
        HStack {
            Text("色:")
                .font(.headline)
                .frame(width: 40, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(colors, id: \.self) { color in
                        ColorButton(
                            color: color,
                            isSelected: viewModel.currentColor == color && !isCustomColorSelected,
                            action: {
                                viewModel.currentColor = color
                                viewModel.isEraserMode = false
                            }
                        )
                    }
                    
                    // カスタムカラーボタン
                    customColorButton
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var customColorButton: some View {
        Button(action: {
            customColor = viewModel.currentColor
            showColorPicker = true
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .red, .orange, .yellow, .green,
                                .blue, .purple, .pink, .red
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                if isCustomColorSelected {
                    Circle()
                        .strokeBorder(Color.blue, lineWidth: 3)
                        .frame(width: 40, height: 40)
                }
                
                Circle()
                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                    .frame(width: 40, height: 40)
                
                Image(systemName: "paintpalette.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1)
            }
        }
    }
    
    private var lineWidthSelectionView: some View {
        HStack {
            Text("太さ:")
                .font(.headline)
                .frame(width: 40, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(lineWidths, id: \.self) { width in
                        LineWidthButton(
                            width: width,
                            isSelected: abs(viewModel.currentLineWidth - width) < 0.1,
                            action: {
                                viewModel.currentLineWidth = width
                            }
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var toolButtonsView: some View {
        HStack(spacing: 16) {
            // 消しゴム
            Button(action: {
                viewModel.isEraserMode.toggle()
            }) {
                HStack {
                    Image(systemName: "eraser.fill")
                    Text("消しゴム")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(viewModel.isEraserMode ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(viewModel.isEraserMode ? .white : .primary)
                .cornerRadius(8)
            }
            
            // Undo
            Button(action: {
                viewModel.undo()
            }) {
                HStack {
                    Image(systemName: "arrow.uturn.backward")
                    Text("Undo")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(viewModel.canUndo ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(viewModel.canUndo ? .white : .gray)
                .cornerRadius(8)
            }
            .disabled(!viewModel.canUndo)
            
            // Redo
            Button(action: {
                viewModel.redo()
            }) {
                HStack {
                    Image(systemName: "arrow.uturn.forward")
                    Text("Redo")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(viewModel.canRedo ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(viewModel.canRedo ? .white : .gray)
                .cornerRadius(8)
            }
            .disabled(!viewModel.canRedo)
            
            // クリア
            Button(action: {
                viewModel.clear()
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("クリア")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }
    
    private var fileActionButtonsView: some View {
        HStack(spacing: 16) {
            // 新規
            Button(action: onNewAction) {
                HStack {
                    Image(systemName: "plus.square")
                    Text("新規")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            // 保存
            Button(action: onSaveAction) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text(saveButtonTitle)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(viewModel.paths.isEmpty ? Color.gray.opacity(0.2) : Color.green.opacity(0.8))
                .foregroundColor(viewModel.paths.isEmpty ? .gray : .white)
                .cornerRadius(8)
            }
            .disabled(viewModel.paths.isEmpty)
            
            // 読み込み
            Button(action: onLoadAction) {
                HStack {
                    Image(systemName: "folder")
                    Text("読み込み")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }

}


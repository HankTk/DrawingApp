//
//  ContentView.swift
//  DrawingApp
//
//  Created on 2025-11-26.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = DrawingViewModel()
    @StateObject private var savedDrawingsViewModel = SavedDrawingsViewModel()
    @State private var showSavedDrawings = false
    @State private var showSaveAlert = false
    @State private var saveName = ""
    @State private var selectedDrawing: SavedDrawing?
    @State private var showColorPicker = false
    @State private var customColor: Color = .black
    @State private var hasUnsavedChanges = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // ファイル名表示
                FileNameView(
                    fileName: currentFileName,
                    hasUnsavedChanges: hasUnsavedChanges && selectedDrawing != nil,
                    isSaved: selectedDrawing != nil
                )
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(white: 0.98))
                
                Divider()
                
                // ツールバー
                ToolbarView(
                    viewModel: viewModel,
                    showColorPicker: $showColorPicker,
                    customColor: $customColor,
                    onNewAction: {
                        selectedDrawing = nil
                        saveName = ""
                        hasUnsavedChanges = false
                        viewModel.clear()
                    },
                    onSaveAction: {
                        if let selected = selectedDrawing {
                            saveName = selected.name
                        }
                        showSaveAlert = true
                    },
                    onLoadAction: {
                        showSavedDrawings = true
                    },
                    saveButtonTitle: selectedDrawing != nil ? "上書き保存" : "保存"
                )
                .padding()
                .background(Color(white: 0.95))
                
                Divider()
                
                // キャンバス
                DrawingCanvas(viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showSavedDrawings) {
            SavedDrawingsView(
                savedDrawingsViewModel: savedDrawingsViewModel,
                onSelect: { drawing in
                    selectedDrawing = drawing
                    saveName = drawing.name
                    viewModel.loadPaths(drawing.paths)
                    hasUnsavedChanges = false
                    showSavedDrawings = false
                },
                onDelete: { drawing in
                    savedDrawingsViewModel.deleteDrawing(drawing)
                    // 削除された描画が現在選択されている場合、選択を解除してキャンバスをクリア
                    if selectedDrawing?.id == drawing.id {
                        selectedDrawing = nil
                        saveName = ""
                        hasUnsavedChanges = false
                        viewModel.clear()
                    }
                }
            )
        }
        .alert(selectedDrawing != nil ? "上書き保存" : "保存", isPresented: $showSaveAlert) {
            TextField("名前", text: $saveName)
            Button(selectedDrawing != nil ? "上書き保存" : "保存") {
                if !saveName.isEmpty {
                    if let selected = selectedDrawing {
                        savedDrawingsViewModel.updateDrawing(selected, with: viewModel.paths)
                        hasUnsavedChanges = false
                    } else {
                        let savedDrawing = savedDrawingsViewModel.saveDrawing(name: saveName, paths: viewModel.paths)
                        selectedDrawing = savedDrawing
                        hasUnsavedChanges = false
                    }
                    saveName = ""
                }
            }
            Button("キャンセル", role: .cancel) {
                if selectedDrawing == nil {
                    saveName = ""
                }
            }
        } message: {
            Text(selectedDrawing != nil ? "描画を上書き保存しますか？" : "描画の名前を入力してください")
        }
        .sheet(isPresented: $showColorPicker) {
            ColorPickerSheet(
                selectedColor: $customColor,
                onColorSelected: { color in
                    viewModel.currentColor = color
                    viewModel.isEraserMode = false
                }
            )
        }
        .onChange(of: viewModel.paths.count) { _ in
            if selectedDrawing != nil && !viewModel.paths.isEmpty {
                hasUnsavedChanges = true
            }
        }
    }
    
    private var currentFileName: String {
        if let selected = selectedDrawing {
            return selected.name
        } else if !viewModel.paths.isEmpty {
            return "新規描画（未保存）"
        } else {
            return "新規描画"
        }
    }

}

#Preview {
    ContentView()
}


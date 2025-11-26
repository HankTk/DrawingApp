//
//  FileNameView.swift
//  DrawingApp
//
//  Created on 2025-11-26.
//

import SwiftUI

struct FileNameView: View {

    let fileName: String
    let hasUnsavedChanges: Bool
    let isSaved: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            HStack(spacing: 8) {
                Image(systemName: "doc.text")
                    .foregroundColor(.gray)
                Text(fileName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if hasUnsavedChanges {
                    Text("（未保存の変更）")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                
                if isSaved && !hasUnsavedChanges {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            
            Spacer()
        }
    }

}


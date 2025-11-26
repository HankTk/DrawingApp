//
//  ToolbarComponents.swift
//  DrawingApp
//
//  Created on 2025-11-26.
//

import SwiftUI

struct ColorButton: View {

    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .strokeBorder(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                )
                .overlay(
                    Circle()
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }

}

struct LineWidthButton: View {

    let width: CGFloat
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Circle()
                    .fill(Color.black)
                    .frame(width: width, height: width)
                
                Text("\(Int(width))")
                    .font(.caption2)
                    .foregroundColor(.primary)
            }
            .padding(8)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
    }

}


//
//  DrawingModels.swift
//  DrawingApp
//
//  Created on 2025-11-26.
//

import SwiftUI
import Foundation

struct DrawingPath: Identifiable, Codable {

    let id: UUID
    var points: [PointData]
    var colorData: ColorData
    var lineWidth: CGFloat
    var isEraser: Bool
    
    var color: Color {
        Color(red: colorData.red, green: colorData.green, blue: colorData.blue, opacity: colorData.alpha)
    }
    
    init(points: [CGPoint] = [], color: Color = .black, lineWidth: CGFloat = 5.0, isEraser: Bool = false) {
        self.id = UUID()
        self.points = points.map { PointData(x: $0.x, y: $0.y) }
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.colorData = ColorData(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
        self.lineWidth = lineWidth
        self.isEraser = isEraser
    }
    
    var cgPoints: [CGPoint] {
        points.map { CGPoint(x: $0.x, y: $0.y) }
    }

}

struct PointData: Codable {
    let x: CGFloat
    let y: CGFloat
}

struct ColorData: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}


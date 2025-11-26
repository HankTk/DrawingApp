// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DrawingApp",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "DrawingApp",
            targets: ["DrawingApp"]
        ),
    ],
    targets: [
        .target(
            name: "DrawingApp",
            dependencies: [],
            path: "DrawingApp",
            sources: [
                "DrawingApp.swift",
                "ContentView.swift",
                "DrawingViewModel.swift",
                "DrawingCanvas.swift"
            ],
            exclude: [
                "Assets.xcassets"
            ]
        ),
    ]
)


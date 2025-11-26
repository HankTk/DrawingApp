#!/bin/bash

# DrawingApp - Run script for command line
# This script builds and runs the app in the iOS simulator

set -e

echo "🎨 DrawingApp - Building and Running..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: xcodebuild not found. Please install Xcode from the App Store."
    exit 1
fi

# Create a temporary Xcode project if it doesn't exist
if [ ! -d "DrawingApp.xcodeproj" ]; then
    echo "📦 Creating Xcode project..."
    
    # Create project structure
    mkdir -p DrawingApp.xcodeproj/project.xcworkspace
    mkdir -p DrawingApp.xcodeproj/xcshareddata/xcschemes
    
    # This is a simplified approach - for full functionality, you may want to use Xcode GUI
    echo "⚠️  Note: Full Xcode project creation requires Xcode GUI."
    echo "   Please open Xcode and create a new project, then add the Swift files."
    echo ""
    echo "   Alternatively, you can use:"
    echo "   swift package generate-xcodeproj"
    exit 1
fi

# Get available simulators
echo "📱 Available iPad simulators:"
xcrun simctl list devices available | grep -i ipad || echo "No iPad simulators found"

# Build the project
echo ""
echo "🔨 Building project..."
xcodebuild -project DrawingApp.xcodeproj \
           -scheme DrawingApp \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch) (6th generation)' \
           clean build

echo ""
echo "✅ Build successful!"
echo ""
echo "To run the app, you can:"
echo "1. Open DrawingApp.xcodeproj in Xcode and press Cmd+R"
echo "2. Or use: xcodebuild test -project DrawingApp.xcodeproj -scheme DrawingApp -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch) (6th generation)'"


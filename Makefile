.PHONY: help build run clean setup

help:
	@echo "DrawingApp - Command Line Build & Run"
	@echo ""
	@echo "Available commands:"
	@echo "  make setup    - Set up Xcode project (requires Xcode)"
	@echo "  make build    - Build the app"
	@echo "  make run      - Build and run in simulator"
	@echo "  make clean    - Clean build artifacts"
	@echo ""
	@echo "Note: iOS apps require Xcode to run. This Makefile helps automate the process."

setup:
	@echo "📦 Setting up Xcode project..."
	@if [ -f "DrawingApp.xcodeproj/project.pbxproj" ]; then \
		echo "✅ Xcode project already exists."; \
	elif command -v xcodegen > /dev/null; then \
		echo "Using xcodegen to create project..."; \
		xcodegen generate; \
		echo "✅ Project created successfully!"; \
	else \
		echo "⚠️  xcodegen not found."; \
		echo ""; \
		echo "Option 1: Install xcodegen (recommended)"; \
		echo "   brew install xcodegen"; \
		echo "   make setup"; \
		echo ""; \
		echo "Option 2: Create project manually in Xcode"; \
		echo "   1. Open Xcode"; \
		echo "   2. File → New → Project"; \
		echo "   3. iOS → App → Next"; \
		echo "   4. Product Name: DrawingApp"; \
		echo "   5. Interface: SwiftUI, Language: Swift"; \
		echo "   6. Save in: $(PWD)"; \
		echo "   7. Replace default files with existing .swift files"; \
		echo "   8. Set Deployment Target to iOS 16.0"; \
		echo "   9. Set Supported Devices to iPad only"; \
		exit 1; \
	fi

build:
	@echo "🔨 Building DrawingApp..."
	@if [ -f "DrawingApp.xcodeproj/project.pbxproj" ]; then \
		xcodebuild -project DrawingApp.xcodeproj \
		           -scheme DrawingApp \
		           -sdk iphonesimulator \
		           -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch) (6th generation)' \
		           clean build; \
	else \
		echo "❌ Xcode project not found. Run 'make setup' first or create project in Xcode."; \
		exit 1; \
	fi

run: build
	@echo "🚀 Launching app in simulator..."
	@if [ -f "DrawingApp.xcodeproj/project.pbxproj" ]; then \
		xcodebuild -project DrawingApp.xcodeproj \
		           -scheme DrawingApp \
		           -sdk iphonesimulator \
		           -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch) (6th generation)' \
		           build; \
		echo "✅ Build complete. Open Xcode and press Cmd+R to run, or:"; \
		echo "   xcrun simctl boot 'iPad Pro (12.9-inch) (6th generation)' 2>/dev/null || true"; \
		echo "   open -a Simulator"; \
	else \
		echo "❌ Xcode project not found. Run 'make setup' first."; \
		exit 1; \
	fi

clean:
	@echo "🧹 Cleaning build artifacts..."
	@if [ -f "DrawingApp.xcodeproj/project.pbxproj" ]; then \
		xcodebuild -project DrawingApp.xcodeproj \
		           -scheme DrawingApp \
		           clean; \
	fi
	@rm -rf build
	@rm -rf .build
	@echo "✅ Clean complete"


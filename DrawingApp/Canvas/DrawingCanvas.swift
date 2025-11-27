//
//  DrawingCanvas.swift
//  DrawingApp
//
//  Created on 2025-11-26.
//

import SwiftUI
import UIKit

struct DrawingCanvas: UIViewRepresentable {
    @ObservedObject var viewModel: DrawingViewModel
    
    func makeUIView(context: Context) -> CanvasView {
        let view = CanvasView()
        view.viewModel = viewModel
        return view
    }
    
    func updateUIView(_ uiView: CanvasView, context: Context) {
        let wasEraserMode = uiView.viewModel?.isEraserMode ?? false
        uiView.viewModel = viewModel
        // 消しゴムモードが変更された時にカーソルアイコンを更新
        if wasEraserMode != viewModel.isEraserMode {
            uiView.setupCursorIcon()
        }
    }
    
    // SwiftUIのonHoverモディファイアを使用してホバーイベントを処理
    static func dismantleUIView(_ uiView: CanvasView, coordinator: ()) {
        // クリーンアップ
    }
}

class CanvasView: UIView {

    var viewModel: DrawingViewModel? {
        didSet {
            setNeedsDisplay()
            setupCursorIcon()
        }
    }
    
    
    private var currentPath: DrawingPath?
    private var currentPoints: [CGPoint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        isOpaque = true
        isMultipleTouchEnabled = false
    }
    
    // カーソル位置に表示する消しゴムアイコンのビュー
    private var cursorIconView: UIImageView?
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupCursorIcon()
    }
    
    func setupCursorIcon() {
        // 既存のカーソルアイコンを削除
        cursorIconView?.removeFromSuperview()
        cursorIconView = nil
        
        // 消しゴムモードの時のみカーソルアイコンを追加
        if let viewModel = viewModel, viewModel.isEraserMode {
            createCursorIcon()
            setupHoverGesture()
        } else {
            removeHoverGesture()
        }
    }
    
    private func createCursorIcon() {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        imageView.alpha = 0.8
        
        let size: CGFloat = 32
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: .medium)
        if let eraserImage = UIImage(systemName: "eraser.fill", withConfiguration: config) {
            imageView.image = eraserImage
        } else {
            // SF Symbolsが利用できない場合は、カスタムイメージを作成
            imageView.image = createCustomEraserImage(size: size)
        }
        
        imageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        imageView.isHidden = true
        // レイヤーを最前面に表示
        addSubview(imageView)
        bringSubviewToFront(imageView)
        cursorIconView = imageView
        
        // デバッグ: 一時的にアイコンを表示して確認（後で削除可能）
        // imageView.isHidden = false
        // imageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private var hoverGesture: UIHoverGestureRecognizer?
    
    private func setupHoverGesture() {
        removeHoverGesture()
        
        if #available(iOS 13.0, *) {
            let gesture = UIHoverGestureRecognizer(target: self, action: #selector(handleHover(_:)))
            addGestureRecognizer(gesture)
            hoverGesture = gesture
        }
    }
    
    private func removeHoverGesture() {
        if let gesture = hoverGesture {
            removeGestureRecognizer(gesture)
            hoverGesture = nil
        }
        cursorIconView?.isHidden = true
    }
    
    @available(iOS 13.0, *)
    @objc private func handleHover(_ gesture: UIHoverGestureRecognizer) {
        guard let iconView = cursorIconView,
              let viewModel = viewModel,
              viewModel.isEraserMode else {
            cursorIconView?.isHidden = true
            return
        }
        
        let location = gesture.location(in: self)
        
        // ビューの範囲内かチェック
        guard bounds.contains(location) else {
            iconView.isHidden = true
            return
        }
        
        switch gesture.state {
        case .began:
            iconView.isHidden = false
            iconView.center = location
            bringSubviewToFront(iconView)
        case .changed:
            iconView.isHidden = false
            // アイコンの位置を更新（アニメーションなしで即座に）
            UIView.performWithoutAnimation {
                iconView.center = location
            }
            bringSubviewToFront(iconView)
        case .ended, .cancelled, .failed:
            // ビューから出た時は非表示
            iconView.isHidden = true
        default:
            break
        }
    }
    
    private func createCustomEraserImage(size: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { context in
            let cgContext = context.cgContext
            
            // 消しゴムの形状を描画（シンプルな矩形）
            cgContext.setFillColor(UIColor.gray.cgColor)
            cgContext.setStrokeColor(UIColor.darkGray.cgColor)
            cgContext.setLineWidth(1.5)
            
            // 消しゴムの本体（矩形）
            let rect = CGRect(x: size * 0.1, y: size * 0.3, width: size * 0.6, height: size * 0.4)
            cgContext.fill(rect)
            cgContext.stroke(rect)
            
            // 消しゴムのハンドル部分
            let handleRect = CGRect(x: size * 0.35, y: size * 0.1, width: size * 0.1, height: size * 0.2)
            cgContext.fill(handleRect)
            cgContext.stroke(handleRect)
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 背景を白で塗りつぶし
        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect)
        
        // すべてのパスを時系列順に描画（消しゴムパスと通常のパスを区別せずに）
        // これにより、消しゴムパスが正しく機能し、消しゴムで消した部分の上に再度描画も可能
        if let viewModel = viewModel {
            for path in viewModel.paths {
                if path.isEraser {
                    drawEraserPath(path, in: context)
                } else {
                    drawPath(path, in: context)
                }
            }
        }
        
        // 現在描画中のパスを描画
        if let currentPath = currentPath {
            if currentPath.isEraser {
                drawEraserPath(currentPath, in: context)
            } else {
                drawPath(currentPath, in: context)
            }
        }
    }
    
    private func drawPath(_ path: DrawingPath, in context: CGContext) {
        guard !path.cgPoints.isEmpty else { return }
        
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(path.lineWidth)
        context.setBlendMode(.normal)
        
        let uiColor = UIColor(path.color)
        context.setStrokeColor(uiColor.cgColor)
        context.setFillColor(uiColor.cgColor)
        
        let points = path.cgPoints
        if points.count == 1 {
            // 単一点の場合は円を描画
            let point = points[0]
            let rect = CGRect(
                x: point.x - path.lineWidth / 2,
                y: point.y - path.lineWidth / 2,
                width: path.lineWidth,
                height: path.lineWidth
            )
            context.fillEllipse(in: rect)
        } else {
            // 複数点の場合は線を描画
            context.move(to: points[0])
            for i in 1..<points.count {
                context.addLine(to: points[i])
            }
            context.strokePath()
        }
    }
    
    private func drawEraserPath(_ path: DrawingPath, in context: CGContext) {
        guard !path.cgPoints.isEmpty else { return }
        
        // 消しゴムモード：背景色（白）で上書きして消去
        context.setBlendMode(.normal)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setStrokeColor(UIColor.white.cgColor)
        context.setFillColor(UIColor.white.cgColor)
        
        let points = path.cgPoints
        let eraserWidth = path.lineWidth * 1.2  // 消しゴムは少し太めに
        
        if points.count == 1 {
            // 単一点の場合は円を描画
            let point = points[0]
            let rect = CGRect(
                x: point.x - eraserWidth / 2,
                y: point.y - eraserWidth / 2,
                width: eraserWidth,
                height: eraserWidth
            )
            context.fillEllipse(in: rect)
        } else {
            // 複数点の場合は線を描画
            context.setLineWidth(eraserWidth)
            context.move(to: points[0])
            for i in 1..<points.count {
                context.addLine(to: points[i])
            }
            context.strokePath()
            
            // 線の端を確実に消去するために各点に円を描画
            for point in points {
                let rect = CGRect(
                    x: point.x - eraserWidth / 2,
                    y: point.y - eraserWidth / 2,
                    width: eraserWidth,
                    height: eraserWidth
                )
                context.fillEllipse(in: rect)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let viewModel = viewModel else { return }
        
        // タッチ時はカーソルアイコンを非表示
        cursorIconView?.isHidden = true
        
        let point = touch.location(in: self)
        currentPoints = [point]
        
        currentPath = DrawingPath(
            points: currentPoints,
            color: viewModel.currentColor,
            lineWidth: viewModel.currentLineWidth,
            isEraser: viewModel.isEraserMode
        )
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let viewModel = viewModel else { return }
        
        let point = touch.location(in: self)
        currentPoints.append(point)
        
        currentPath = DrawingPath(
            points: currentPoints,
            color: viewModel.currentColor,
            lineWidth: viewModel.currentLineWidth,
            isEraser: viewModel.isEraserMode
        )
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let viewModel = viewModel,
              let path = currentPath else { return }
        
        let point = touch.location(in: self)
        currentPoints.append(point)
        
        let finalPath = DrawingPath(
            points: currentPoints,
            color: path.color,
            lineWidth: path.lineWidth,
            isEraser: path.isEraser
        )
        
        viewModel.addPath(finalPath)
        currentPath = nil
        currentPoints = []
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPath = nil
        currentPoints = []
        setNeedsDisplay()
    }
    
}


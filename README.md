# DrawingApp - iPadお絵描きアプリ

SwiftUIを使用したiPad向けのお絵描きアプリケーションです。

## 機能

- **ペンの太さ選択**: 1pxから20pxまで7段階で選択可能
- **色選択**: 10色のカラーパレットから選択可能、カスタムカラーも選択可能
- **Undo/Redo機能**: 描画の取り消しとやり直しが可能（最大50ステップ）
- **消しゴム機能**: 描画を消去する消しゴムモード
- **クリア機能**: キャンバス全体をクリア
- **保存・読み込み機能**: 描画を保存して後で読み込むことが可能
- **新規作成**: 新しい描画を開始

## プロジェクト構造

```
DrawingApp/
├── DrawingApp/
│   ├── App/
│   │   └── DrawingApp.swift          # アプリのエントリーポイント
│   ├── Views/                        # メインのビューコンポーネント
│   │   ├── ContentView.swift         # メインUI
│   │   ├── SavedDrawingsView.swift   # 保存された描画のリストビュー
│   │   └── ColorPickerSheet.swift    # カラーピッカーシート
│   ├── Components/                   # 再利用可能な小さなコンポーネント
│   │   ├── ToolbarView.swift         # ツールバー全体
│   │   ├── ToolbarComponents.swift    # ツールバーのコンポーネント
│   │   ├── FileNameView.swift        # ファイル名表示
│   │   └── SavedDrawingRow.swift     # 保存された描画の行ビュー
│   ├── ViewModels/                   # ビューモデル
│   │   ├── DrawingViewModel.swift    # 描画状態管理
│   │   └── SavedDrawingsViewModel.swift  # 保存された描画の状態管理
│   ├── Models/                       # データモデル
│   │   ├── DrawingModels.swift       # 描画関連モデル
│   │   └── SavedDrawing.swift       # 保存された描画のモデル
│   ├── Canvas/                       # キャンバス関連
│   │   └── DrawingCanvas.swift      # 描画キャンバス（UIViewRepresentable）
│   └── Assets.xcassets/             # アセット
└── README.md
```

### アーキテクチャ

このプロジェクトは**MVVM（Model-View-ViewModel）パターン**に基づいて設計されています：

- **Models**: データ構造とビジネスロジックの基本単位
- **Views**: ユーザーインターフェース（SwiftUIビュー）
- **ViewModels**: ビューとモデルを橋渡しする状態管理層
- **Components**: 再利用可能なUIコンポーネント

## セットアップ方法

### 方法1: コマンドラインから実行（推奨）

1. **Xcodeプロジェクトを作成**（初回のみ）
   ```bash
   # Xcodeでプロジェクトを作成するか、以下のコマンドで確認
   make setup
   ```
   
   または、Xcodeで手動でプロジェクトを作成：
   - テンプレート: iOS App
   - Interface: SwiftUI
   - Language: Swift
   - デバイス: iPad
   - プロジェクト名: `DrawingApp`
   - このプロジェクトのSwiftファイルを追加

2. **ビルドと実行**
   ```bash
   # ビルドのみ
   make build
   
   # ビルドして実行（シミュレーターで）
   make run
   ```

3. **その他のコマンド**
   ```bash
   # ヘルプを表示
   make help
   
   # ビルド成果物をクリーン
   make clean
   ```

### 方法2: Xcode GUIから実行

1. Xcodeで新しいプロジェクトを作成
   - テンプレート: iOS App
   - Interface: SwiftUI
   - Language: Swift
   - デバイス: iPad

2. このプロジェクトのファイルをXcodeプロジェクトに追加
   - すべてのSwiftファイルを適切なフォルダー構造で追加
   - または、`DrawingApp`フォルダー全体をXcodeプロジェクトにドラッグ&ドロップ

3. プロジェクト設定
   - Deployment Target: iOS 16.0以上
   - Supported Devices: iPad

4. ビルドして実行（Cmd+R）

## 使用方法

### 描画機能

1. **描画**: キャンバス上で指やApple Pencilで描画
2. **色の変更**: ツールバーの色パレットから選択、またはカスタムカラーボタンで詳細な色を選択
3. **太さの変更**: ツールバーの太さ選択から選択（1px〜20px）
4. **消しゴム**: 消しゴムボタンをタップして消去モードに切り替え
5. **Undo**: 直前の操作を取り消し
6. **Redo**: 取り消した操作をやり直し
7. **クリア**: キャンバス全体をクリア

### 保存・読み込み機能

1. **保存**: 「保存」ボタンをタップして描画に名前を付けて保存
2. **上書き保存**: 既存の描画を編集した場合、「上書き保存」で更新
3. **読み込み**: 「読み込み」ボタンで保存された描画のリストを表示し、選択して読み込み
4. **新規作成**: 「新規」ボタンで新しい描画を開始

## 技術的な詳細

- **描画エンジン**: UIKitの`UIView`を`UIViewRepresentable`でラップ
- **状態管理**: `ObservableObject`を使用したMVVMパターン
- **Undo/Redo**: 配列スタックを使用した実装（最大50ステップ）
- **消しゴム**: 背景色（白）で上書きして消去
- **データ永続化**: JSON形式でファイルシステムに保存
- **アーキテクチャ**: 機能単位でファイルを分割し、保守性と再利用性を向上

## 要件

- iOS 16.0以上
- iPad専用（iPhoneでも動作しますが、iPad向けに最適化されています）
- Xcode（コマンドライン実行には `xcodebuild` が必要）

## コマンドライン実行について

このプロジェクトには `Package.swift` と `Makefile` が含まれています。

- **Package.swift**: Swift Package Manager用の設定ファイル
- **Makefile**: ビルドと実行を自動化するためのMakefile
- **run.sh**: 実行用のシェルスクリプト

コマンドラインから実行する場合：
1. Xcodeプロジェクト（`.xcodeproj`）が必要です
2. `make run` でビルドと実行が可能です
3. シミュレーターが自動的に起動します


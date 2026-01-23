# Shampagne Cellar

## プロジェクト概要
作品情報を一覧・詳細で閲覧するための Flutter Web アプリ。`assets/data/works_manifest.json` と
`assets/data/works/*.json` にある作品データを読み込み、Top / Works / Detail / Contact を表示する。

## デプロイ手順（Firebase Hosting）
1. `flutter build web`
2. `firebase deploy`

`firebase.json` は `build/web` を Hosting の公開先に設定済み。`/.firebaserc` の `default` プロジェクトを使用。

## コンテンツの追加方法
### 1) 作品データ JSON を追加
`assets/data/works/` に新規 JSON を追加し、`assets/data/works_manifest.json` にファイルパスを追記する。

JSON 例:
```json
{
  "id": "category-2025-example",
  "title": "Example Title",
  "category": "Category",
  "description": ["1行目", "2行目"],
  "year": 2025,
  "tags": ["Tag1", "Tag2"],
  "thumbnail": "assets/images/example.webp",
  "heroOrder": 1,
  "videoUrl": "https://youtu.be/xxxx",
  "images": ["assets/images/example_detail.webp"]
}
```

補足:
- `description` は文字列または配列。配列の場合は改行で結合して表示される。
- `heroOrder` / `videoUrl` / `videoId` は任意。
- `year` は数値推奨（文字列でも読み込み可）。

### 2) 画像を追加
画像は `assets/images/` に配置し、JSON 内のパスを指定する。
新しいフォルダを作る場合は `pubspec.yaml` の `assets:` に追加。
WebP 変換例:
```bash
cwebp -q 85 input.png -o assets/images/output.webp
```

### 3) 反映確認
`flutter run -d chrome` でローカル確認。

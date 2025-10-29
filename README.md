# SimpleBlog - シンプルなブログシステム

## 概要
Ruby on Railsで構築されたシンプルなブログシステムです。管理画面からMarkdown形式で記事を投稿・削除でき、トップ画面で記事一覧を表示できます。

## 機能一覧
- ✅ 管理画面ログイン機能（ユーザー認証）
- ✅ 管理画面でMarkdown形式でブログを投稿
- ✅ 管理画面で投稿ブログを削除
- ✅ トップ画面でタイトルを投稿順で表示
- ✅ トップ画面でタイトルをクリックして該当ブログに遷移
- ✅ 該当ブログをMarkdown形式で表示
- ✅ 該当ブログからトップ画面に戻る

## 技術スタック
- **バックエンド**: Ruby on Rails 7.0
- **データベース**: MySQL 8.0
- **Webサーバー**: nginx
- **コンテナ**: Docker & Docker Compose
- **認証**: Devise
- **Markdown**: Redcarpet + Rouge

## アーキテクチャ
MVC（Model-View-Controller）パターン

## セットアップ手順

### 前提条件
- Docker
- Docker Compose

### 初回セットアップ

1. リポジトリのクローン
```bash
cd c:\Users\user\Documents\SimpleBlog
```

2. Dockerイメージのビルドとコンテナの起動
```bash
docker-compose build
docker-compose up -d
```

3. データベースのセットアップ
```bash
docker-compose exec app rails db:create
docker-compose exec app rails db:migrate
```

4. 初期管理ユーザーの作成
```bash
docker-compose exec app rails console
# Railsコンソール内で以下を実行
User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
exit
```

5. ブラウザでアクセス
- トップ画面: http://localhost
- 管理画面ログイン: http://localhost/users/sign_in

### 起動・停止コマンド

```bash
# 起動
docker-compose up -d

# 停止
docker-compose down

# ログ確認
docker-compose logs -f app
```

## ディレクトリ構造
```
SimpleBlog/
├── app/
│   ├── controllers/     # コントローラー
│   ├── models/          # モデル
│   ├── views/           # ビュー
│   └── helpers/         # ヘルパー
├── config/              # 設定ファイル
├── db/                  # データベース関連
├── docker-compose.yml   # Docker Compose設定
├── Dockerfile          # Dockerイメージ定義
├── nginx/              # nginx設定
└── docs/               # 設計書
```

## ライセンス
MIT License

# SimpleBlog システム設計書

## 目次
1. [システム概要](#1-システム概要)
2. [システム構成](#2-システム構成)
3. [データベース設計](#3-データベース設計)
4. [画面設計](#4-画面設計)
5. [API設計](#5-api設計)
6. [セキュリティ設計](#6-セキュリティ設計)
7. [運用設計](#7-運用設計)

---

## 1. システム概要

### 1.1 システム名
SimpleBlog - シンプルなブログシステム

### 1.2 目的
Markdown形式で記事を投稿・管理できるシンプルなブログシステムを提供する。

### 1.3 主要機能
- 管理画面ログイン機能（ユーザー認証）
- 管理画面でのMarkdown形式ブログ投稿機能
- 管理画面での投稿編集・削除機能
- トップ画面での投稿一覧表示機能（投稿順）
- 記事詳細表示機能（Markdownレンダリング）
- トップ画面への戻る機能

### 1.4 技術スタック
- **言語**: Ruby 3.2.2
- **フレームワーク**: Ruby on Rails 7.0.8
- **アーキテクチャ**: MVC（Model-View-Controller）
- **データベース**: MySQL 8.0
- **Webサーバー**: nginx
- **アプリケーションサーバー**: Puma
- **コンテナ**: Docker & Docker Compose
- **認証**: Devise
- **Markdownパーサー**: Redcarpet
- **シンタックスハイライト**: Rouge

---

## 2. システム構成

### 2.1 システム構成図

```
┌─────────────────┐
│   クライアント   │ (Webブラウザ)
│  (ユーザー)     │
└────────┬────────┘
         │ HTTP/HTTPS
         │ Port 80
         ↓
┌─────────────────┐
│     nginx       │ (Webサーバー)
│  Port 80        │ - 静的ファイル配信
└────────┬────────┘ - リバースプロキシ
         │
         │ Port 3000
         ↓
┌─────────────────┐
│  Rails App      │ (アプリケーションサーバー)
│  (Puma)         │ - MVCロジック
│  Port 3000      │ - ビジネスロジック
└────────┬────────┘
         │
         │ Port 3306
         ↓
┌─────────────────┐
│    MySQL        │ (データベース)
│  Port 3306      │ - データ永続化
└─────────────────┘
```

### 2.2 コンテナ構成
- **dbコンテナ**: MySQL 8.0データベース
- **appコンテナ**: Rails アプリケーション
- **nginxコンテナ**: Webサーバー

### 2.3 ディレクトリ構造
```
SimpleBlog/
├── app/
│   ├── controllers/          # コントローラー
│   │   ├── application_controller.rb
│   │   ├── posts_controller.rb
│   │   └── admin/
│   │       ├── base_controller.rb
│   │       └── posts_controller.rb
│   ├── models/               # モデル
│   │   ├── application_record.rb
│   │   ├── user.rb
│   │   └── post.rb
│   ├── views/                # ビュー
│   │   ├── layouts/
│   │   │   ├── application.html.erb
│   │   │   └── admin.html.erb
│   │   ├── posts/
│   │   │   ├── index.html.erb
│   │   │   └── show.html.erb
│   │   ├── admin/
│   │   │   └── posts/
│   │   │       ├── index.html.erb
│   │   │       ├── new.html.erb
│   │   │       └── edit.html.erb
│   │   └── devise/
│   │       └── sessions/
│   │           └── new.html.erb
│   └── helpers/              # ヘルパー
│       └── application_helper.rb
├── config/                   # 設定ファイル
│   ├── application.rb
│   ├── database.yml
│   ├── routes.rb
│   ├── environments/
│   └── locales/
├── db/                       # データベース関連
│   ├── migrate/              # マイグレーション
│   └── seeds.rb              # 初期データ
├── docker-compose.yml        # Docker Compose設定
├── Dockerfile               # Dockerイメージ定義
├── nginx/                   # nginx設定
│   └── nginx.conf
└── docs/                    # ドキュメント
    └── DESIGN.md
```

---

## 3. データベース設計

### 3.1 ER図

```
┌─────────────────┐          ┌─────────────────┐
│     users       │          │     posts       │
├─────────────────┤          ├─────────────────┤
│ id (PK)         │ 1     ∞ │ id (PK)         │
│ email           │──────────│ user_id (FK)    │
│ encrypted_pwd   │          │ title           │
│ created_at      │          │ content         │
│ updated_at      │          │ created_at      │
└─────────────────┘          │ updated_at      │
                             └─────────────────┘
```

### 3.2 テーブル定義

#### 3.2.1 usersテーブル（管理ユーザー）

| カラム名 | データ型 | NOT NULL | デフォルト | 説明 |
|---------|---------|----------|-----------|------|
| id | BIGINT | ✓ | AUTO_INCREMENT | 主キー |
| email | VARCHAR(255) | ✓ | '' | メールアドレス（ユニーク） |
| encrypted_password | VARCHAR(255) | ✓ | '' | 暗号化パスワード |
| reset_password_token | VARCHAR(255) | | NULL | パスワードリセットトークン |
| reset_password_sent_at | DATETIME | | NULL | パスワードリセット送信日時 |
| remember_created_at | DATETIME | | NULL | ログイン記憶日時 |
| created_at | DATETIME | ✓ | | 作成日時 |
| updated_at | DATETIME | ✓ | | 更新日時 |

**インデックス:**
- PRIMARY KEY (id)
- UNIQUE INDEX (email)
- INDEX (reset_password_token)

#### 3.2.2 postsテーブル（ブログ投稿）

| カラム名 | データ型 | NOT NULL | デフォルト | 説明 |
|---------|---------|----------|-----------|------|
| id | BIGINT | ✓ | AUTO_INCREMENT | 主キー |
| user_id | BIGINT | ✓ | | ユーザーID（外部キー） |
| title | VARCHAR(200) | ✓ | | タイトル |
| content | TEXT | ✓ | | 本文（Markdown形式） |
| created_at | DATETIME | ✓ | | 投稿日時 |
| updated_at | DATETIME | ✓ | | 更新日時 |

**インデックス:**
- PRIMARY KEY (id)
- FOREIGN KEY (user_id) REFERENCES users(id)
- INDEX (user_id)
- INDEX (created_at)

### 3.3 リレーション
- User has_many Posts（1ユーザーは複数の投稿を持つ）
- Post belongs_to User（1投稿は1ユーザーに属する）

---

## 4. 画面設計

### 4.1 画面遷移図

```
┌──────────────────┐
│  トップ画面       │
│  (投稿一覧)      │ ← ルート画面
│  GET /           │
└────┬─────────┬───┘
     │         │
     │         │ クリック
     │         ↓
     │    ┌──────────────────┐
     │    │  記事詳細画面     │
     │    │  GET /posts/:id  │
     │    └────────┬─────────┘
     │             │
     │             │ 戻るボタン
     │             │
     ↓             ↓
┌──────────────────┐
│  ログイン画面     │
│  GET /users/     │
│  sign_in         │
└────────┬─────────┘
         │ 認証成功
         ↓
┌──────────────────┐
│  管理画面         │
│  (投稿一覧)      │
│  GET /admin/     │
│  posts           │
└────┬──────┬──────┘
     │      │
     │      │ 新規投稿
     │      ↓
     │  ┌──────────────────┐
     │  │  新規投稿画面     │
     │  │  GET /admin/     │
     │  │  posts/new       │
     │  └──────────────────┘
     │
     │ 編集
     ↓
┌──────────────────┐
│  編集画面         │
│  GET /admin/     │
│  posts/:id/edit  │
└──────────────────┘
```

### 4.2 画面一覧

#### 4.2.1 公開画面

| 画面名 | URL | 説明 |
|-------|-----|------|
| トップ画面 | GET / | 投稿一覧を表示 |
| 記事詳細画面 | GET /posts/:id | 記事の詳細を表示（Markdownレンダリング） |
| ログイン画面 | GET /users/sign_in | 管理画面へのログイン |

#### 4.2.2 管理画面（認証必須）

| 画面名 | URL | 説明 |
|-------|-----|------|
| 投稿一覧画面 | GET /admin/posts | 投稿の管理画面 |
| 新規投稿画面 | GET /admin/posts/new | 新規投稿フォーム |
| 投稿編集画面 | GET /admin/posts/:id/edit | 投稿編集フォーム |

### 4.3 画面詳細

#### 4.3.1 トップ画面
**目的**: 投稿一覧を表示し、記事へアクセスする入口

**表示項目**:
- サイトタイトル
- ログインボタン（未ログイン時）/ 管理画面ボタン（ログイン時）
- 投稿カード（タイトル、投稿日時、本文プレビュー）
- フッター

**機能**:
- 投稿を作成日時の降順で表示
- 投稿カードクリックで記事詳細へ遷移

#### 4.3.2 記事詳細画面
**目的**: Markdown形式で書かれた記事を表示

**表示項目**:
- 記事タイトル
- 投稿日時、投稿者
- 本文（Markdownレンダリング済み）
- トップページへ戻るボタン
- 編集ボタン（ログイン時のみ）

**機能**:
- Markdownを HTMLに変換して表示
- シンタックスハイライト対応

#### 4.3.3 ログイン画面
**目的**: 管理画面へのアクセス認証

**入力項目**:
- メールアドレス
- パスワード
- ログイン状態を保持するチェックボックス

**機能**:
- Deviseによる認証処理
- 認証成功時は管理画面へ遷移

#### 4.3.4 管理画面：投稿一覧
**目的**: 投稿を管理（編集・削除）

**表示項目**:
- ナビゲーションバー（トップページ、新規投稿、ログアウト）
- 投稿テーブル（ID、タイトル、投稿者、投稿日時、操作ボタン）

**機能**:
- 編集ボタン: 投稿編集画面へ遷移
- 削除ボタン: 確認ダイアログ後に削除

#### 4.3.5 管理画面：新規投稿/編集
**目的**: 記事の作成・編集

**入力項目**:
- タイトル（必須、200文字以内）
- 本文（必須、Markdown形式）

**機能**:
- バリデーションエラー表示
- Markdown記法のヘルプ表示
- プレビューボタン（編集時）

---

## 5. API設計

### 5.1 ルーティング

#### 5.1.1 公開エンドポイント

| HTTPメソッド | パス | コントローラー#アクション | 説明 |
|-------------|------|------------------------|------|
| GET | / | posts#index | トップページ（投稿一覧） |
| GET | /posts/:id | posts#show | 記事詳細 |
| GET | /users/sign_in | devise/sessions#new | ログイン画面 |
| POST | /users/sign_in | devise/sessions#create | ログイン処理 |
| DELETE | /users/sign_out | devise/sessions#destroy | ログアウト処理 |

#### 5.1.2 管理画面エンドポイント（認証必須）

| HTTPメソッド | パス | コントローラー#アクション | 説明 |
|-------------|------|------------------------|------|
| GET | /admin/posts | admin/posts#index | 投稿一覧 |
| GET | /admin/posts/new | admin/posts#new | 新規投稿フォーム |
| POST | /admin/posts | admin/posts#create | 投稿作成 |
| GET | /admin/posts/:id/edit | admin/posts#edit | 投稿編集フォーム |
| PATCH | /admin/posts/:id | admin/posts#update | 投稿更新 |
| DELETE | /admin/posts/:id | admin/posts#destroy | 投稿削除 |

### 5.2 パラメータ仕様

#### 5.2.1 投稿作成・更新

**リクエスト**:
```ruby
{
  post: {
    title: "記事のタイトル",
    content: "Markdown形式の本文"
  }
}
```

**バリデーション**:
- title: 必須、最大200文字
- content: 必須

**レスポンス（成功時）**:
- リダイレクト: /admin/posts
- フラッシュメッセージ: "投稿を作成しました。"

**レスポンス（失敗時）**:
- ステータス: 422 Unprocessable Entity
- エラーメッセージを含むフォーム再表示

---

## 6. セキュリティ設計

### 6.1 認証・認可
- **認証機構**: Devise
- **セッション管理**: Cookieベース
- **パスワード**: BCryptによる暗号化
- **CSRF対策**: Rails標準のCSRFトークン検証

### 6.2 アクセス制御
- 管理画面は `authenticate_user!` による認証必須
- 公開画面は認証不要

### 6.3 入力検証
- Strong Parametersによるパラメータホワイトリスト
- ActiveRecord バリデーション
- XSS対策: ERBの自動エスケープ

### 6.4 セキュリティヘッダー
- Content Security Policy（CSP）
- X-Frame-Options
- X-Content-Type-Options

---

## 7. 運用設計

### 7.1 環境構成

| 環境 | 用途 | データベース |
|-----|------|------------|
| development | 開発環境 | simple_blog_development |
| test | テスト環境 | simple_blog_test |
| production | 本番環境 | simple_blog_production |

### 7.2 ログ管理
- **アプリケーションログ**: log/development.log, log/production.log
- **アクセスログ**: nginx ログ
- **エラーログ**: Rails ログ、nginx エラーログ

### 7.3 バックアップ
- **データベース**: mysqldumpによる定期バックアップ推奨
- **アップロードファイル**: 現状なし

### 7.4 デプロイ
- Dockerコンテナベースのデプロイ
- docker-compose.ymlによる一括起動

### 7.5 監視項目
- アプリケーションサーバーの稼働状態
- データベースサーバーの稼働状態
- ディスク使用量
- レスポンスタイム

---

## 付録

### A. 初期セットアップ手順

```bash
# 1. リポジトリのクローン

# 2. Dockerイメージのビルドとコンテナ起動
docker-compose build
docker-compose up -d

# 3. データベースのセットアップ
docker-compose exec app rails db:create
docker-compose exec app rails db:migrate
docker-compose exec app rails db:seed

# 4. アクセス
# トップ画面: http://localhost
# 管理画面: http://localhost/users/sign_in
# デフォルトログイン情報:
#   Email: admin@example.com
#   Password: password
```

### B. 開発コマンド

```bash
# コンテナ起動
docker-compose up -d

# コンテナ停止
docker-compose down

# ログ確認
docker-compose logs -f app

# Railsコンソール
docker-compose exec app rails console

# マイグレーション実行
docker-compose exec app rails db:migrate

# テストデータ投入
docker-compose exec app rails db:seed
```

### C. トラブルシューティング

**Q: データベース接続エラーが発生する**
A: dbコンテナの起動を確認し、`docker-compose logs db` でログを確認してください。

**Q: ポート3000が既に使用されている**
A: docker-compose.ymlのポート設定を変更してください。

**Q: ログインできない**
A: db:seedが実行されているか確認し、デフォルトユーザーが作成されているか確認してください。

---

**作成日**: 2025年10月29日  
**バージョン**: 1.0  
**作成者**: SimpleBlog Development Team

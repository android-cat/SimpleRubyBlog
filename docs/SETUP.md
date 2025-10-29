# SimpleBlog セットアップガイド

## 目次
1. [前提条件](#前提条件)
2. [初期セットアップ](#初期セットアップ)
3. [開発環境での起動](#開発環境での起動)
4. [使い方](#使い方)
5. [トラブルシューティング](#トラブルシューティング)

---

## 前提条件

以下のソフトウェアがインストールされている必要があります：

- **Docker Desktop** (Windows版)
- **Docker Compose**

### Docker Desktopのインストール確認

```bash
docker --version
docker-compose --version
```

---

## 初期セットアップ

### 1. プロジェクトディレクトリへ移動

```bash
cd c:\Users\user\Documents\SimpleBlog
```

### 2. Dockerイメージのビルド

初回のみ実行します。時間がかかる場合があります（5-10分程度）。

```bash
docker-compose build
```

### 3. コンテナの起動

```bash
docker-compose up -d
```

以下の3つのコンテナが起動します：
- `simple_blog_db` (MySQL)
- `simple_blog_app` (Rails)
- `simple_blog_nginx` (nginx)

### 4. データベースのセットアップ

```bash
docker-compose exec app rails db:create
docker-compose exec app rails db:migrate
docker-compose exec app rails db:seed
```

これで初期データ（管理ユーザーとサンプル投稿）が投入されます。

---

## 開発環境での起動

### コンテナの起動

```bash
docker-compose up -d
```

### コンテナの停止

```bash
docker-compose down
```

### ログの確認

```bash
# すべてのコンテナのログ
docker-compose logs -f

# 特定のコンテナのログ
docker-compose logs -f app
docker-compose logs -f db
docker-compose logs -f nginx
```

---

## 使い方

### アクセスURL

| URL | 説明 |
|-----|------|
| http://localhost | トップページ（投稿一覧） |
| http://localhost/users/sign_in | 管理画面ログイン |
| http://localhost/admin/posts | 管理画面（投稿一覧） |

### デフォルトログイン情報

**管理画面へのログイン:**
- **メールアドレス**: admin@example.com
- **パスワード**: password

### 基本操作

#### 1. 管理画面にログイン
1. ブラウザで `http://localhost/users/sign_in` にアクセス
2. メールアドレスとパスワードを入力
3. 「ログイン」をクリック

#### 2. 新規投稿を作成
1. 管理画面で「新規投稿」をクリック
2. タイトルと本文（Markdown形式）を入力
3. 「投稿する」をクリック

#### 3. 投稿を編集
1. 管理画面の投稿一覧から編集したい投稿の「編集」をクリック
2. 内容を修正
3. 「更新する」をクリック

#### 4. 投稿を削除
1. 管理画面の投稿一覧から削除したい投稿の「削除」をクリック
2. 確認ダイアログで「OK」をクリック

#### 5. 投稿を閲覧
1. トップページ（http://localhost）にアクセス
2. 投稿カードをクリックして詳細を表示
3. 「トップページに戻る」で一覧に戻る

---

## 開発者向けコマンド

### Railsコンソール

```bash
docker-compose exec app rails console
```

Railsコンソール内での操作例：

```ruby
# 全ユーザーを表示
User.all

# 全投稿を表示
Post.all

# 新しいユーザーを作成
User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password')

# 投稿数を確認
Post.count
```

### データベースのリセット

```bash
docker-compose exec app rails db:reset
```

これにより、データベースが削除され、マイグレーションとシードが再実行されます。

### マイグレーションの実行

```bash
docker-compose exec app rails db:migrate
```

### テストデータの再投入

```bash
docker-compose exec app rails db:seed
```

### Gemのインストール

Gemfileを変更した場合：

```bash
docker-compose exec app bundle install
docker-compose restart app
```

---

## トラブルシューティング

### Q1: データベース接続エラーが発生する

**症状**: `ActiveRecord::ConnectionNotEstablished` エラー

**解決方法**:
```bash
# dbコンテナの状態を確認
docker-compose ps

# dbコンテナのログを確認
docker-compose logs db

# dbコンテナを再起動
docker-compose restart db

# 少し待ってからappコンテナを再起動
docker-compose restart app
```

### Q2: ポート80が既に使用されている

**症状**: `port is already allocated` エラー

**解決方法**:
docker-compose.ymlのnginxのポート設定を変更：

```yaml
nginx:
  ports:
    - "8080:80"  # 80を8080に変更
```

その後、`http://localhost:8080` でアクセス

### Q3: ログインできない

**症状**: ログイン情報が正しいのにログインできない

**解決方法**:
```bash
# シードデータが投入されているか確認
docker-compose exec app rails console

# Railsコンソール内で
User.count  # 0の場合はシードデータを投入
exit

# シードデータの投入
docker-compose exec app rails db:seed
```

### Q4: 画面が表示されない・白い画面が表示される

**症状**: ページにアクセスできるがコンテンツが表示されない

**解決方法**:
```bash
# アプリケーションログを確認
docker-compose logs -f app

# アセットのプリコンパイル（必要な場合）
docker-compose exec app rails assets:precompile

# appコンテナを再起動
docker-compose restart app
```

### Q5: Dockerコンテナが起動しない

**症状**: `docker-compose up` が失敗する

**解決方法**:
```bash
# 既存のコンテナとボリュームを削除
docker-compose down -v

# イメージを再ビルド
docker-compose build --no-cache

# 再度起動
docker-compose up -d
```

### Q6: Markdownが正しく表示されない

**症状**: Markdown記法が反映されず、プレーンテキストで表示される

**解決方法**:
```bash
# redcarpetとrougeがインストールされているか確認
docker-compose exec app bundle list | grep redcarpet
docker-compose exec app bundle list | grep rouge

# インストールされていない場合
docker-compose exec app bundle install
docker-compose restart app
```

---

## コンテナの完全クリーンアップ

開発環境を完全にリセットしたい場合：

```bash
# すべてのコンテナを停止
docker-compose down

# ボリュームも含めてすべて削除
docker-compose down -v

# イメージの削除（任意）
docker rmi simple_blog_app simple_blog_nginx

# 再構築
docker-compose build
docker-compose up -d
docker-compose exec app rails db:create db:migrate db:seed
```

---

## 補足情報

### ファイル構造

```
SimpleBlog/
├── app/                    # アプリケーションコード
├── config/                 # 設定ファイル
├── db/                     # データベース関連
├── docker-compose.yml      # Docker Compose設定
├── Dockerfile             # Dockerイメージ定義
├── Gemfile                # Ruby gem依存関係
├── nginx/                 # nginx設定
├── public/                # 静的ファイル
├── docs/                  # ドキュメント
└── README.md              # プロジェクト概要
```

### 主要なGem

- **rails**: Webアプリケーションフレームワーク
- **mysql2**: MySQLアダプター
- **devise**: ユーザー認証
- **redcarpet**: Markdownパーサー
- **rouge**: シンタックスハイライト
- **puma**: アプリケーションサーバー

---

## サポート

問題が解決しない場合は、以下を確認してください：

1. Docker Desktopが起動しているか
2. 十分なディスクスペースがあるか（最低5GB推奨）
3. ファイアウォールやアンチウイルスがDockerをブロックしていないか
4. Windows環境の場合、WSL2が有効になっているか

---

**最終更新**: 2025年10月29日

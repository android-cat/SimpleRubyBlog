# Ruby 3.2をベースイメージとして使用
FROM ruby:3.2

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y nodejs npm default-mysql-client build-essential && \
    rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# アプリケーションのコードをすべてコピー
COPY . .

# Bundlerをインストール
RUN gem install bundler:2.4.10

# Bundleインストール
RUN bundle install --jobs=4 --retry=3

# ポート3000を公開
EXPOSE 3000

# デフォルトコマンド
CMD ["rails", "server", "-b", "0.0.0.0"]

# db/seeds.rb
# 初期データの投入

# 管理ユーザーの作成
user = User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.password = 'password'
  u.password_confirmation = 'password'
end

puts "管理ユーザーを作成しました: #{user.email}"

# サンプル投稿の作成
if Post.count == 0
  Post.create!([
    {
      title: 'SimpleBlogへようこそ',
      content: <<~MARKDOWN,
        # SimpleBlogへようこそ！

        これはRuby on Railsで構築されたシンプルなブログシステムです。

        ## 主な機能

        - Markdown形式での記事投稿
        - 記事の一覧表示
        - 記事の詳細表示
        - 記事の削除

        ## Markdownの例

        ### コードブロック

        ```ruby
        def hello
          puts "Hello, World!"
        end
        ```

        ### リスト

        - 項目1
        - 項目2
        - 項目3

        ### 強調

        **太字** と *イタリック* が使えます。

        ---

        それでは、ブログをお楽しみください！
      MARKDOWN
      user: user
    },
    {
      title: 'Markdownの書き方',
      content: <<~MARKDOWN,
        # Markdownの書き方ガイド

        Markdownは軽量マークアップ言語で、プレーンテキストで簡単に文書を記述できます。

        ## 見出し

        ```
        # 見出し1
        ## 見出し2
        ### 見出し3
        ```

        ## リンク

        [Google](https://www.google.com)のようにリンクを作成できます。

        ## 画像

        ![代替テキスト](画像のURL)

        ## テーブル

        | 列1 | 列2 | 列3 |
        |-----|-----|-----|
        | A   | B   | C   |
        | D   | E   | F   |

        ## 引用

        > これは引用です。
        > 複数行にわたって記述できます。

        Markdownを使って、美しい記事を作成しましょう！
      MARKDOWN
      user: user
    },
    {
      title: 'ブログの使い方',
      content: <<~MARKDOWN,
        # ブログの使い方

        このブログシステムの使い方を説明します。

        ## 記事の投稿

        1. 管理画面にログイン
        2. 「新規投稿」をクリック
        3. タイトルと本文を入力
        4. 「投稿する」をクリック

        ## 記事の編集

        1. 管理画面の投稿一覧から編集したい記事を選択
        2. 「編集」をクリック
        3. 内容を修正
        4. 「更新する」をクリック

        ## 記事の削除

        1. 管理画面の投稿一覧から削除したい記事を選択
        2. 「削除」をクリック
        3. 確認ダイアログで「OK」をクリック

        ## 注意事項

        - 削除した記事は復元できません
        - Markdown形式で記述してください
        - 画像をアップロードする機能は現在ありません

        以上が基本的な使い方です。
      MARKDOWN
      user: user
    }
  ])
  puts "サンプル投稿を#{Post.count}件作成しました"
end

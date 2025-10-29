// app/javascript/application.js
// アプリケーションのJavaScriptエントリーポイント

// Turboの設定
import "@hotwired/turbo-rails"
Turbo.session.drive = true

// Stimulusの設定  
import "controllers"

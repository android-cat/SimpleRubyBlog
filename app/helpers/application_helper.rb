# app/helpers/application_helper.rb
# 全てのビューで使用できるヘルパーメソッド

module ApplicationHelper
  # ページタイトルを生成
  def full_title(page_title = '')
    base_title = "SimpleBlog"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
  
  # フラッシュメッセージのBootstrapクラスを返す
  def flash_class(level)
    case level
    when 'notice' then 'alert-info'
    when 'success' then 'alert-success'
    when 'error' then 'alert-danger'
    when 'alert' then 'alert-warning'
    else 'alert-info'
    end
  end
end

module ApplicationHelper

  def full_title(page_name = "")
    base_title = "Sample"
    if page_name.empty?
      base_title
    else
      page_name + " | " + base_title
    end
  end

  # テキスト内のURLを自動的にリンクに変換する
  def auto_link_urls(text)
    return "" if text.blank?

    # URL検出用の正規表現（http, https, ftp対応）
    url_regex = %r{
      (https?://[^\s<>"]+|ftp://[^\s<>"]+)
    }xi

    # URLをリンクに置換
    linked_text = text.gsub(url_regex) do |url|
      link_to(url, url)
    end

    # HTMLセーフな文字列として返す
    simple_format(linked_text).html_safe
  end

  # テキストを切り詰めてからURLリンク化する（一覧表示用）
  def auto_link_urls_truncated(text, length: 100)
    return "" if text.blank?

    # 先にテキストを切り詰める
    truncated_text = truncate(text, length: length)

    # URLをリンクに変換
    url_regex = %r{
      (https?://[^\s<>"]+|ftp://[^\s<>"]+)
    }xi

    linked_text = truncated_text.gsub(url_regex) do |url|
      link_to(url, url)
    end

    # simple_formatは適用せず、そのまま返す（一覧では改行不要）
    linked_text.html_safe
  end
end
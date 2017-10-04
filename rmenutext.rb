# coding: UTF-8

require 'rubygems'
require 'rack'
require 'RmenuConfig'                                                           # Rmenu環境設定クラス
require 'RmenuLoggerMixin'                                                      # Logファイル Debug用

class RmenuText
  include RmenuLoggerMixin                                                      # Logファイル Debug用

  def initialize()
    # controller用ログを作成する
    $Rlog               = createLogger("rack")                                  # Logファイル Debug用

    # controller用ログを作成する
    $Rlog.debug("Html Rack") {"initialize start"}                               # Logファイル Debug用

    $Rlog.debug("Html Rack") {"initialize end"}                                 # Logファイル Debug用
  end

  def call(env)
    begin
      $Rlog.debug("Text Rack") {"call start"}                                   # Logファイル Debug用

      # ブラウザからリクエストデータを受信する
      req      = Rack::Request.new(env)
      req_data = req.params["gamen"]
      $Rlog.debug("Text Rack") {"request data : #{req_data}"}

      url = $Rconfig["base_application"] + req_data
      $Rlog.debug("Text Rack") {"Textファイルパス: #{url}"}                     # Logファイル Debug用

      content = readHtml(url)

      # マルチユーザ環境の場合、ページ埋め込みのリンクを書き換える
      # リンク先頭の ../ (たくさん) を /ユーザ名/ に書き換え
      if $Rconfig["multi_user_name"] != ""
        conv_pattern = /"(\.\.\/)*(System|Application)(\/.*")/
        conv_replace = '"/' + $Rconfig["multi_user_name"] + '/\2\3'
        content.gsub!(conv_pattern, conv_replace)
      end

      $Rlog.debug("Text Rack") {"call normal end"}
    rescue
      # エラーログを出力する
      $Rlog.debug("Text Rack") {"exception: #{$!}"}                             # Logファイル Debug用
      $Rlog.debug("Text Rack") {"exception: #{$@}"}                             # Logファイル Debug用

      # エラーメッセージを作成する
      content = setErrorMesssage()
      $Rlog.debug("Text Rack") {"call abnormal end"}
    end
    
    # ブラウザへレスポンスデータを送信する
    res = Rack::Response.new { |r|
      r.status          = 200
      r['Content-Type'] = 'text/plain;charset=utf-8'
      r.write content
    }
    res.finish
  end
end

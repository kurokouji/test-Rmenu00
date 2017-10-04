# coding: UTF-8

require 'rubygems'
require 'rack'

require 'RmenuConfig'                                                           # Rmenu環境設定クラス
require 'RmenuLoggerMixin'                                                      # Logファイル Debug用

class RmenuDocs
  include RmenuLoggerMixin                                                      # Logファイル Debug用

  def initialize()
    # controller用ログを作成する
    $Rlog               = createLogger("rack")                                  # Logファイル Debug用

    # controller用ログを作成する
    $Rlog.debug("Docs Rack") {"initialize start"}                               # Logファイル Debug用

    $Rlog.debug("Docs Rack") {"initialize end"}                                 # Logファイル Debug用
  end

  def call(env)
    begin
      $Rlog.debug("Docs Rack") {"call start"}                                   # Logファイル Debug用

      # ブラウザからリクエストデータを受信する
      req      = Rack::Request.new(env)
      req_data = req.params["data"]

      url = $Rconfig["docs_path"] + "/" + req_data + ".html"
      #url = $Rconfig["base_application"] + "/" + req_data + ".html"
      $Rlog.debug("Docs Rack") {"Docsファイルパス: #{url}"}                     # Logファイル Debug用

      content = readHtml(url)
			
			if $Rconfig["base_url"] == "http://127.0.0.1:9292/"
			  strReplace = $Rconfig["base_url"] + "Application"
			else
			  strReplace =  "http://125.206.227.78/rmenu/Application"
			end
			
			contentx = content.gsub(/(src=")/, '\1' + strReplace)
			contenty = contentx.gsub(/(data=")/, '\1' + strReplace)
    
      $Rlog.debug("Docs Rack") {"call normal end"}
    rescue
      # エラーログを出力する
      $Rlog.debug("Docs Rack") {"exception: #{$!}"}                             # Logファイル Debug用
      $Rlog.debug("Docs Rack") {"exception: #{$@}"}                             # Logファイル Debug用

      # エラーメッセージを作成する
      contenty = setErrorMesssage()
      $Rlog.debug("Docs Rack") {"call abnormal end"}
    end
    
    # ブラウザへレスポンスデータを送信する
    res = Rack::Response.new { |r|
      r.status          = 200
      r['Content-Type'] = 'text/html;charset=utf-8'
      r.write contenty
    }
    res.finish
  end
end

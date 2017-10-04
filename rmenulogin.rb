# coding: UTF-8

require 'rubygems'
require 'rack'
require 'json'
require 'drb'                                                                   # dRubyライブラリ
require 'RmenuConfig'                                                           # Rmenu環境設定クラス
require 'RmenuLoggerMixin'                                                      # Logファイル Debug用

class RmenuLogin
  include RmenuLoggerMixin                                                      # Logファイル Debug用

  def initialize()
    # controller用ログを作成する
    $Rlog               = createLogger("rack")                                  # Logファイル Debug用

    # controller用ログを作成する
    $Rlog.debug("Login Rack") {"initialize start"}                               # Logファイル Debug用

    # コントローラオブジェクトを参照する
    @rmenu_controller = DRbObject.new_with_uri($Rconfig["controller_uri"])
    
    $Rlog.debug("Login Rack") {"initialize end"}                                # Logファイル Debug用
  end

  def call(env)
    begin
      $Rlog.debug("Login Rack") {"call start"}                                   # Logファイル Debug用

      # ブラウザからリクエストデータを受信する
      req      = Rack::Request.new(env)
      req_data = req.params["data"]

      # json文字列をHashに変換する
      request_data = JSON.load(req_data)
      loginid      = request_data["records"][0]["record"]["ログインＩＤ"]["value"][0]

      
      # 開発支援プロジェクトはログを出力しない
      $Rlog = changeLoggerMode($Rlog, request_data)
      

      $Rlog.debug("Login Rack") {"request data : #{req_data}"}
      $Rlog.debug("Login Rack") {"ログインＩＤ : #{loginid}"}
      
      
      request_data["records"][0]["record"]["リモート_アドレス"]["value"][0]   = env['REMOTE_ADDR'].to_s
      request_data["records"][0]["record"]["リモート_ホスト名"]["value"][0]   = env['REMOTE_HOST'].to_s

      
      # コントローラオブジェクトのcallメソッドを実行する
      response_data = @rmenu_controller.call(request_data)

      # レスポンスデータ（hashオブジェクト）をJSON文字列に変換する
      content = JSON.dump(response_data)
      $Rlog.debug("Login Rack") {"response data : #{content}"}
    
      $Rlog.debug("Login Rack") {"normal end"}
    rescue
      # エラーログを出力する
      $Rlog.debug("Login Rack") {"exception: #{$!}"}                             # Logファイル Debug用
      $Rlog.debug("Login Rack") {"exception: #{$@}"}                             # Logファイル Debug用

      # エラーメッセージを作成する
      error_data = setErrorMesssage()
      
      # エラーデータ（hashオブジェクト）をJSON文字列に変換する
      content = JSON.dump(error_data)
      $Rlog.debug("Login Rack") {"abnormal end"}
    end
    
    # ブラウザへレスポンスデータを送信する
    res = Rack::Response.new { |r|
      r.status          = 200
      r['Content-Type'] = 'application/json;charset=utf-8'
      r.write content
    }
    res.finish
  end
end

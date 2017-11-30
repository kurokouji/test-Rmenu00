# coding: UTF-8

require 'rubygems'
require 'rack'
require 'json'
require 'drb'                                                                   # dRubyライブラリ
require 'RmenuConfig'                                                           # Rmenu環境設定クラス
require 'RmenuLoggerMixin'                                                      # Logファイル Debug用

class RmenuMain
  include RmenuLoggerMixin                                                      # Logファイル Debug用

  def initialize()
    # controller用ログを作成する
    $Rlog               = createLogger("rack")                                  # Logファイル Debug用
    $Tlog               = createResponseLogger("responselog")                   # Logファイル Debug用

    # controller用ログを作成する
    $Rlog.debug("Main Rack") {"initialize start"}                               # Logファイル Debug用

    # コントローラオブジェクトを参照する
    @rmenu_controller = DRbObject.new_with_uri($Rconfig["controller_uri"])
    
    $Rlog.debug("Main Rack") {"initialize end"}                                # Logファイル Debug用
  end

  def call(env)
    begin
      $Rlog.debug("Main Rack") {"call start"}                                   # Logファイル Debug用

      # ブラウザからリクエストデータを受信する
      req      = Rack::Request.new(env)
      req_data = req.params["data"]

      # json文字列をHashに変換する
      request_data = JSON.load(req_data)
      
      # レスポンスログの開始ログ取得
      startSecond = Time.now
      responseLogStart($Tlog, "Main Rack", env['REMOTE_ADDR'].to_s, request_data)
    
      # 開発支援プロジェクトはログを出力しない
      $Rlog = changeLoggerMode($Rlog, request_data)

      $Rlog.debug("Main Rack") {"request data : #{req_data}"}
    
      # コントローラオブジェクトのcallメソッドを実行する
      response_data = @rmenu_controller.call(request_data)

      # レスポンスログの終了ログ取得
      responseLogEnd($Tlog, "Main Rack", env['REMOTE_ADDR'].to_s, response_data)
      endSecond = Time.now
      if (endSecond - startSecond) > $Rconfig['responselog_time']
        responseLogTimeOver($Tlog, "Time Over", env['REMOTE_ADDR'].to_s, request_data)
      end


      # レスポンスデータ（hashオブジェクト）をJSON文字列に変換する
      content = JSON.dump(response_data)
      $Rlog.debug("Main Rack") {"response data : #{content}"}
    
      $Rlog.debug("Main Rack") {"normal end"}
    rescue
      # エラーログを出力する
      $Rlog.debug("Main Rack") {"exception: #{$!}"}                             # Logファイル Debug用
      $Rlog.debug("Main Rack") {"exception: #{$@}"}                             # Logファイル Debug用

      # エラーメッセージを作成する
      error_data = setErrorMesssage()
      
      # エラーデータ（hashオブジェクト）をJSON文字列に変換する
      content = JSON.dump(error_data)
      $Rlog.debug("Main Rack") {"abnormal end"}
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

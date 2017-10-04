# coding: UTF-8

require 'rubygems'
require 'rack'
require 'RmenuConfig'                                                           # Rmenu環境設定クラス
require 'RmenuLoggerMixin'                                                      # Logファイル Debug用

class RmenuUpload
  include RmenuLoggerMixin                                                      # Logファイル Debug用

  def initialize()
    # controller用ログを作成する
    $Rlog               = createLogger("rack")                                  # Logファイル Debug用

    # controller用ログを作成する
    $Rlog.debug("Upload Rack") {"initialize start"}                             # Logファイル Debug用

    $Rlog.debug("Upload Rack") {"initialize end"}                               # Logファイル Debug用
  end

  def call(env)
    begin
      $Rlog.debug("Upload Rack") {"call start"}                                 # Logファイル Debug用

      # ブラウザからリクエストデータを受信する"
      req      = Rack::Request.new(env)

      $Rlog.debug("Upload Rack") {"req.params: #{req.params}"}                  # Logファイル Debug用

      reqData  = req.params["data"].split("#")
      $Rlog.debug("Upload Rack") {"request reqData    : #{reqData}"}
      $Rlog.debug("Upload Rack") {"request dir        : #{reqData[0]}"}         # 格納先ディレクトリー
      $Rlog.debug("Upload Rack") {"request nuwName    : #{reqData[1]}"}         # 格納ファイル名

      # テンポラリー情報
      if reqData[2]
        $Rlog.debug("Upload Rack") {"request paramName  : #{reqData[2]}"}
      else 
        $Rlog.debug("Upload Rack") {"request paramName  : none"}
      end

      if reqData[2]
        upload   = req.params[reqData[2]]
      else 
        upload   = req.params["upload"]
      end

      fileName = upload[:filename]                                              # テンポラリー情報：アップロードファイル名
      tempFile = upload[:tempfile]                                              # テンポラリー情報：テンポラリーファイル名

      $Rlog.debug("Upload Rack") {"request fileName : #{fileName}"}
      $Rlog.debug("Upload Rack") {"request tempFile : #{tempFile}"}

      # テンプファイルを読み込む
      data = readBinFile(tempFile)

      # 格納先ディレクトリ＋ファイル名を設定
      url = $Rconfig["apps_path"] + "/" + reqData[0] + "/" + reqData[1]
      $Rlog.debug("Upload Rack") {"ファイルパス: #{url}"}                       # Logファイル Debug用


      # ディレクトリが無ければ作成し、データを出力する
      createDir($Rconfig["apps_path"] + "/" + reqData[0])
      writeBinFile(url, data)

      response_data = Hash.new()
      response_data["message"] = {}
      response_data["message"]["status"] = "OK"
      response_data["message"]["msg"]    = "ファイルアップロードは正常に終了しました。"
      content = JSON.dump(response_data)
      $Rlog.debug("Upload Rack") {"response data : #{content}"}

      $Rlog.debug("Upload Rack") {"call normal end"}
    rescue
      # エラーログを出力する
      $Rlog.debug("Upload Rack") {"exception: #{$!}"}                           # Logファイル Debug用
      $Rlog.debug("Upload Rack") {"exception: #{$@}"}                           # Logファイル Debug用

      # エラーメッセージを作成する
      content = setErrorMesssage()
      $Rlog.debug("Upload Rack") {"call abnormal end"}
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

# coding: UTF-8

require 'RmenuConfig'                                                                               # 設定情報を読みこむ
require 'RmenuMVCMixin'                                                                             # before after 動的メソッド実行Mixin
require 'json'
require 'ValidationMixin'                                                                           # Validationチェック用Mixin

class RmenuPrintServerController
  include RmenuMVCMixin
  include ValidationMixin

  def initialize(printparam, keyparamHash)
    begin
      # initialize 開始ログを出力する
      $PRClog.debug("PrintServerController") {"initialize start"}                                   # Logファイル Debug用

      @printparam     = printparam                                                                  # リクエストデータ
      @keyparamHash   = keyparamHash                                                                # リクエストデータ
      
      # initialize 終了ログを出力する
      $PRClog.debug("PrintServerController") {"initialize normal end"}                              # Logファイル Debug用
    rescue
      # エラーログを出力する
      $PRClog.error("PrintServerController") {"initialize exception: #{$!}"}                        # Logファイル Debug用
    end
  end

  # パラメーダデータからリクエストデータを設定する
  def createRequestData(request_data, temp_object)
    # リクエストデータの有無を判定
    return unless request_data.has_key?("records")
    
    request_data["records"].each do |record_info|
      result = createRecord(record_info, temp_object)
      if result == "ERROR"
        return
      end
    end
  end
	
  # パラメーダデータを設定する
  def createRecord(record_info, temp_object)
    # beforeメソッド処理
    result = doBeforeAfterMethod("before", record_info, temp_object)                                # RmenuMVCMixin

    if result == "OK"
      record_data = record_info["record"]
      @keyparamHash.each{|key, value|
        if record_data.has_key?(key)
          record_data[key]["value"][0] = value
        end
      }

      # afterメソッド処理
      result = doBeforeAfterMethod("after", record_info, temp_object)                               # RmenuMVCMixin
      return result
    end
  end

  # メイン処理
  def call(def_cache, app_cache)
    begin
      # メイン処理 開始ログを出力する
      $PRClog.debug("PrintServerController") {"call start"}                                           # Logファイル Debug用

      # リクエストデータを取得
      $PRClog.debug("PrintServerController") {"def_cache.getJsonData start"}                          # Logファイル Debug用
      tran_data     = def_cache.getJsonData(@printparam)
      request_data  = tran_data["request"]
      $PRClog.debug("PrintServerController") {"def_cache.getJsonData normal end"}                     # Logファイル Debug用

      # コントローラオブジェクトを動的生成
      $PRClog.debug("PrintServerController") {"app_cache.getPrintServerControllerObject start"}       # Logファイル Debug用
      temp_object = app_cache.getPrintServerControllerObject(request_data)
      $PRClog.debug("PrintServerController") {"app_cache.getPrintServerControllerObject normal end"}  # Logファイル Debug用

      # パラメータデータからリクエストデータに値を設定する
      $PRClog.debug("PrintServerController") {"createRequestData start"}                              # Logファイル Debug用
      createRequestData(request_data, temp_object)
      $PRClog.debug("PrintServerController") {"createRequestData normal end"}                         # Logファイル Debug用

      # メイン処理 終了ログを出力する
      $PRClog.debug("PrintServerController") {"call normal end"}                                      # Logファイル Debug用

      # リクエストデータをリターン
      return request_data
    rescue
      # メイン処理 エラーログを出力する
      $PRClog.error("PrintServerController") {"call exception: #{$!}"}                                # Logファイル Debug用

      @request_data['message']['status'] = "ERROR"
      @request_data['message']['msg']    = "#{$!}"
      return @request_data
    end
  end
end

# coding: UTF-8

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'RmenuMVCMixin'                                                         # before after 動的メソッド実行Mixin
require 'json'

require 'ValidationMixin'                                                       # Validationチェック用Mixin

class RmenuController
  include RmenuMVCMixin
  include ValidationMixin

  def initialize(cgi_request)
    begin
      # initialize 開始ログを出力する
      $Clog.debug("Controller") {"initialize start"}                            # Logファイル Debug用

      @request_data   = cgi_request                                             # リクエストデータ
      
      # initialize 終了ログを出力する
      $Clog.debug("Controller") {"initialize normal end"}                       # Logファイル Debug用
    rescue
      # エラーログを出力する
       $Clog.error("Controller") {"initialize exception: #{$!}"}                # Logファイル Debug用
       raise
    end
  end

  # データチェック処理１
  # （リクエストデータからレコード配列を取り出す）
  def checkRequestData(validation_data, temp_object)
    # リクエストデータの有無を判定
    return unless @request_data.has_key?("records")
    
    @request_data["records"].each do |record_info|
      $Clog.debug("Controller") {"チェックするリクエスト情報 : #{JSON.dump(record_info)}"}
      result = checkRecord(record_info, validation_data, temp_object)
      if result == "ERROR"
        return
      end
    end
  end
	
  # データチェック処理２
  # （リクエストレコードと同じIDをdatasetレコード配列から取り出す）
  def checkRecord(record_info, validation_data, temp_object)
    # beforeメソッド処理
    result = doBeforeAfterMethod("before", record_info, temp_object)            # RmenuMVCMixin

    if result == "OK"
      validation_data["records"].each do |validation_info|
        if record_info["id"] == validation_info["id"]
          $Clog.debug("Controller") {"チェックに使うバリデーション情報 : #{JSON.dump(validation_info)}"}
          result = checkRecordItem(record_info["record"], validation_info["record"])  # ValidMixin
          if result == "ERROR"
            return
          end
          
          break
        end
      end

      # afterメソッド処理
      result = doBeforeAfterMethod("after", record_info, temp_object)           # RmenuMVCMixin
      return result
    end
  end

  # メイン処理
  def call(def_cache, app_cache)
    begin
      # メイン処理 開始ログを出力する
      $Clog.debug("Controller") {"call start"}                                  # Logファイル Debug用

      # 画面定義項目を取得
      $Clog.debug("Controller") {"def_cache.getJsonData start"}                 # Logファイル Debug用
      validation_data = def_cache.getJsonData(@request_data)
      $Clog.debug("Controller") {"def_cache.getJsonData normal end"}            # Logファイル Debug用

      # コントローラオブジェクトを動的生成
      $Clog.debug("Controller") {"app_cache.getControllerObject start"}         # Logファイル Debug用
      temp_object = app_cache.getControllerObject(@request_data, validation_data)
      $Clog.debug("Controller") {"app_cache.getControllerObject normal end"}    # Logファイル Debug用

      # リクエストデータをチェック
      $Clog.debug("Controller") {"checkRequestData start"}                      # Logファイル Debug用
      checkRequestData(validation_data, temp_object)
      $Clog.debug("Controller") {"checkRequestData normal end"}                 # Logファイル Debug用

      # メイン処理 終了ログを出力する
      $Clog.debug("Controller") {"call normal end"}                             # Logファイル Debug用

      # リクエストデータをリターン
      return @request_data
    rescue
      # メイン処理 エラーログを出力する
      $Clog.error("Controller") {"call exception: #{$!}"}                       # Logファイル Debug用

      @request_data['message']['status'] = "ERROR"
      @request_data['message']['msg']    = "#{$!}"
      return @request_data
    end
  end
end

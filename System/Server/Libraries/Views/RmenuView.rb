# coding: UTF-8

require 'RmenuMVCMixin'                                                         # before after 動的メソッド実行Mixin
require 'json'

class RmenuView
  include RmenuMVCMixin

  def initialize(request_data, sql_data)
    begin
      # initialize 開始ログを出力する
      $Vlog.debug("View") {"initialize start"}                                  # Logファイル Debug用

      @request_data   = request_data
      @sql_data       = sql_data
      
      # initialize 終了ログを出力する
      $Vlog.debug("View") {"initialize normal end"}                             # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Vlog.error("View") {"initialize exception: #{$!}"}                       # Logファイル Debug用
      raise
    end
  end

  # sql実行結果データからレスポンスデータを編集する
  def fromSqlToResponse(response_data, temp_object)
    # レスポンスデータからレコード配列を取り出す
    if response_data.key?('records')
      response_data["records"].each do |response_info|
        $Vlog.debug("View") {"編集前レスポンス情報 : #{JSON.dump(response_info)}"}  # Logファイル Debug用
        editResponse(response_info, temp_object)
        $Vlog.debug("View") {"編集後レスポンス情報 : #{JSON.dump(response_info)}"}  # Logファイル Debug用
      end
    end
  end

  # レスポンスデータの編集
  def editResponse(response_info, temp_object)
    # beforeメソッド処理
    result = doBeforeAfterMethod("before", response_info, temp_object)          # RmenuMVCMixin

    if result == "OK"
      editResponseRecord(response_info["record"], response_info)

      # afterメソッド処理
      doBeforeAfterMethod("after", response_info, temp_object)                  # RmenuMVCMixin
    end
  end

  # レスポンスデータの行編集
  def editResponseRecord(response_record, response_info)
    response_record.each do |name, value|
      # fromtype 処理
      if value.has_key?("fromtype")
        if value["fromtype"] != ""
          if value["fromtype"] == "request"
            # 違うidのrequestから編集する
            fromRequestEditValue(value, @request_data)                            # RmenuMVCMixin
            next
          end
          
          if value["fromio"] == "input"
            # sql_dataのinputから編集する
            fromSqlInputEditValue(value, @sql_data)                               # RmenuMVCMixin
          else
            # sql_dataのoutputから編集する
            fromSqlOutputEditValue(value, @sql_data)                              # RmenuMVCMixin
          end
          next
        end
      end

      # 同じidのsql_dataから編集する
      @sql_data["sqls"].each do |sql_info|
        if response_info["id"] != sql_info["id"]
          next
        end
        
        sql_record = sql_info["output"]["record"]
        if sql_record.key?(name)
          value["value"] = sql_record[name]["value"]
        end
        break
      end
    end
  end

  # リクエストエラーを設定する
  def setRequestError(response_data)
     response_data["message"]     = @request_data["message"]     
     return response_data
  end

  # SQLエラーを設定する
  def setSqlError(response_data)
     response_data["message"]     = @sql_data["message"]
     return response_data
  end


  # メイン処理
  def call(def_cache, app_cache)
    begin
      # メイン処理 開始ログを出力する
      $Vlog.debug("View") {"call start"}                                        # Logファイル Debug用

      # レスポンスデータを設定
      $Vlog.debug("View") {"def_cache.getJsonData start"}                       # Logファイル Debug用
      tran_data = def_cache.getJsonData(@request_data)
      response_data  = tran_data["response"]
      $Vlog.debug("View") {"Json レスポンスデータ : #{JSON.dump(response_data)}"}
      $Vlog.debug("View") {"def_cache.getJsonData normal end"}                  # Logファイル Debug用

      # ビューオブジェクトを動的生成
      $Vlog.debug("View") {"app_cache.getViewObject start"}                     # Logファイル Debug用
      temp_object = app_cache.getViewObject(response_data, @sql_data, @request_data)
      $Vlog.debug("View") {"app_cache.getViewObject normal end"}                # Logファイル Debug用

      # リクエスト　エラー
      if @request_data["message"]["status"] != "OK"
        $Vlog.debug("View") {"call normal end (request error)"}                 # Logファイル Debug用
        return setRequestError(response_data)
      end

      # ＳＱＬ　エラー
      if @sql_data["message"]["status"] != "OK"
        $Vlog.debug("View") {"call normal end (sql error)"}                     # Logファイル Debug用
        return setSqlError(response_data)
      end

      # SQLデータからレスポンスデータを設定する
      $Vlog.debug("View") {"fromSqlToResponse start"}                           # Logファイル Debug用
      fromSqlToResponse(response_data, temp_object)
      $Vlog.debug("View") {"fromSqlToResponse normal end"}                      # Logファイル Debug用

      # メイン処理 終了ログを出力する
      $Vlog.debug("View") {"call normal end"}                                   # Logファイル Debug用

      return response_data
    rescue
      # メイン処理 エラーログを出力する
      $Vlog.error("View") {"call exception: #{$!}"}                             # Logファイル Debug用

      response_data['message']['status'] = "ERROR"
      response_data['message']['msg']    = "#{$!}"
      return response_data
    end
  end
end

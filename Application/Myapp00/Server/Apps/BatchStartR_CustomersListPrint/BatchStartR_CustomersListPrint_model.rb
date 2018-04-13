# coding: UTF-8

require 'Myapp00/Server/Modules/Myapp00OfMasterMainteOfModelMixin'
require 'Myapp00/Server/Modules/Myapp00OfBatchStartUpOfModelMixin'

class BatchStartR_CustomersListPrint_model
  include Myapp00OfMasterMainteOfModelMixin
  include Myapp00OfBatchStartUpOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("BatchStartR_CustomersListPrint_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_db       = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data
      $Mlog.debug("BatchStartMainteContractPrint_model") {"@rmenu_db: #{@rmenu_db}"}

      # initialize 終了ログを出力する
      $Mlog.debug("BatchStartR_CustomersListPrint_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("BatchStartR_CustomersListPrint_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # キーデータが空の時パス
  def isEmptyPassForキーデータOfBatchStartR_CustomersList(sqlID, itemName)
    $Mlog.debug("BatchDailyReportProc") {"isEmptyPassForキーデータOfBatchStartR_CustomersList start"}
    
    status    = "OK"
    sqlRecord = getJsonChunkById(@sql_data, "sqls", sqlID, "input", "record")
    
    if sqlRecord[itemName]["value"][0] == ""
      status = "PASS"
    end

    $Mlog.debug("BatchDailyReportProc") {"isEmptyPassForキーデータOfBatchStartR_CustomersList status = #{status}"}
    $Mlog.debug("BatchDailyReportProc") {"isEmptyPassForキーデータOfBatchStartR_CustomersList normal end"}
    return status
  end


end

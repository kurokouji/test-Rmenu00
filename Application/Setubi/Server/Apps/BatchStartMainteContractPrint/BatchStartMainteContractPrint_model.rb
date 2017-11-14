# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfMasterMainteOfModelMixin'
require 'Setubi/Server/Modules/SetubiOfBatchStartUpOfModelMixin'

class BatchStartMainteContractPrint_model
  include SetubiOfMasterMainteOfModelMixin
  include SetubiOfBatchStartUpOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("BatchStartMainteContractPrint_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_db       = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("BatchStartMainteContractPrint_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("BatchStartMainteContractPrint_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # キーデータが空の時パス
  def isEmptyPassForキーデータOfBatchStartMainteContractPrint(sqlID, itemName)
    $Mlog.debug("BatchDailyReportProc") {"isEmptyPassForキーデータOfBatchStartMainteContractPrint start"}
    
    status    = "OK"
    sqlRecord = getJsonChunkById(@sql_data, "sqls", sqlID, "input", "record")
    
    if sqlRecord[itemName]["value"][0] == ""
      status = "PASS"
    end

    $Mlog.debug("BatchDailyReportProc") {"isEmptyPassForキーデータOfBatchStartMainteContractPrint status = #{status}"}
    $Mlog.debug("BatchDailyReportProc") {"isEmptyPassForキーデータOfBatchStartMainteContractPrint normal end"}
    return status
  end


end

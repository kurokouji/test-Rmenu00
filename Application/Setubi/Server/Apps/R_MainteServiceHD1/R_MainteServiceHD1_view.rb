# coding: UTF-8

require 'date'
require 'RmenuFilePathMixin'                                                    # セッション処理用
require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する

class R_MainteServiceHD1_view
  include RmenuFilePathMixin                                                    # Logファイル Debug用
  include RmenuJsonMixin

  def initialize(response_data, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Vlog.debug("R_MainteServiceHD1_view") {"initialize start"}                    # Logファイル Debug用

      @response_data  = response_data
      @sql_data       = sql_data
      @request_data   = request_data
      
      # initialize 終了ログを出力する
      $Vlog.debug("R_MainteServiceHD1_view") {"initialize normal end"}               # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Vlog.error("R_MainteServiceHD1_view") {"initialize exception: #{$!}"}         # Logファイル Debug用
      raise
    end
  end

  # 契約保守作業明細データを設定する
  def set契約保守作業明細データOfR_MainteServiceHD1OfSetubi()
    $Vlog.debug("R_MainteServiceHD1_view") {"set契約保守作業明細データOfR_MainteServiceHD1OfSetubi start"}

    sqlRecord1     = getJsonChunkById(@sql_data,      "sqls",     "detail",  "output", "record")
    sqlRecord2     = getJsonChunkById(@sql_data,      "sqls",     "detail2", "output", "record")
    responseRecord = getJsonChunkById(@response_data, "records",  "detail",            "record")
    
    status = "OK"
    if sqlRecord1["作業区分"]["value"][0] != ""
      $Vlog.debug("R_MainteServiceHD1_view") {"set契約保守作業明細データOfR_MainteServiceHD1OfSetubi end"}
      return status
    end
    
    maxSize = sqlRecord2["作業区分"]["value"].length - 1
    for i in 0..maxSize do
      responseRecord["作業区分"]["value"][i]         = sqlRecord2["作業区分"]["value"][i]
      responseRecord["作業区分摘要"]["value"][i]     = sqlRecord2["作業区分摘要"]["value"][i]
      responseRecord["摘要"]["value"][i]             = ""
      responseRecord["標準インターバル"]["value"][i] = ""
    end

    $Vlog.debug("R_MainteServiceHD1_view") {"set契約保守作業明細データOfR_MainteServiceHD1OfSetubi end"}
    return status
  end


end

# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfBaseNameMainteOfModelMixin'


class Sample_ParentChildMainte_model
  include SetubiOfBaseNameMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("Sample_ParentChildMainte_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("Sample_ParentChildMainte_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("Sample_ParentChildMainte_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # サンプル_明細の明細行番号を設定する（登録・訂正処理用）
  def set明細行番号OfSample_ParentChildMainteOfSetubi()
    $Mlog.debug("Sample_ParentChildMainte_model") {"set明細行番号OfSample_ParentChildMainteOfSetubi start"}

    requestRecord = getJsonChunkById(@request_data, "records", "detail",                  "record")
    sqlRecord     = getJsonChunkById(@sql_data,     "sqls",    "detail_insert", "input",  "record")

    maxSize = requestRecord["サンプル_明細項目１"]["value"].length - 1
    emptySW = "PASS"
    
    for i in 0..maxSize do
      sqlRecord["サンプル_明細行番号"]["value"][i] = i + 1
      
      emptySW = "OK"
    end

    $Mlog.debug("Sample_ParentChildMainte_model") {"set明細行番号OfSample_ParentChildMainteOfSetubi end status = #{emptySW}"}
    return emptySW
  end


end

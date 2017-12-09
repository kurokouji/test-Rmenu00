# coding: UTF-8

require 'Myapp00/Server/Modules/Myapp00OfBaseNameMainteOfModelMixin'


class T_Sample_ChildMainte_model
  include Myapp00OfBaseNameMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("T_Sample_ChildMainte_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("T_Sample_ChildMainte_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("T_Sample_ChildMainte_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # Ｔサンプル_明細の明細行番号を設定する（登録・訂正処理用）
  def set明細行番号OfT_Sample_ChildMainteOfMyapp00()
    $Mlog.debug("T_Sample_ChildMainte_model") {"set明細行番号OfT_Sample_ChildMainteOfMyapp00 start"}

    requestRecord = getJsonChunkById(@request_data, "records", "detail",                  "record")
    sqlRecord     = getJsonChunkById(@sql_data,     "sqls",    "detail_insert", "input",  "record")

    maxSize = requestRecord["Ｔサンプル_明細項目０１"]["value"].length - 1
    emptySW = "PASS"
    
    for i in 0..maxSize do
      sqlRecord["Ｔサンプル_明細行番号"]["value"][i] = i + 1
      
      emptySW = "OK"
    end

    $Mlog.debug("T_Sample_ChildMainte_model") {"set明細行番号OfT_Sample_ChildMainteOfMyapp00 end status = #{emptySW}"}
    return emptySW
  end


end

# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfBaseNameMainteOfModelMixin'


class R_MainteContractHD2_model
  include SetubiOfBaseNameMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("R_MainteContractHD2_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("R_MainteContractHD2_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("R_MainteContractHD2_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # 契約設備明細の登録データを設定する（登録処理用）
  def set明細登録データOfR_MainteContractHD2OfSetubi()
    $Mlog.debug("R_MainteContractHD2_model") {"set明細登録データOfR_MainteContractHD2OfSetubi start"}

    requestHRecord = getJsonChunkById(@request_data, "records", "header",          "record")
    requestDRecord = getJsonChunkById(@request_data, "records", "detail",          "record")
    sqlRecord      = getJsonChunkById(@sql_data,     "sqls",    "detail_insert", "input", "record")

    maxSize = requestDRecord["削除"]["value"].length - 1
    k       = 0
    emptySW = "PASS"
    
    for i in 0..maxSize do
      # 削除データは処理対象外
      if requestDRecord["削除"]["value"][i] == "9"
        next
      end
      
      sqlRecord["契約ＮＯ"]["value"][k]   = requestHRecord["契約ＮＯ"]["value"][0]
      sqlRecord["設備行番"]["value"][k]   = requestHRecord["設備行番"]["value"][0]
      sqlRecord["作業区分"]["value"][k]   = requestHRecord["作業区分"]["value"][0]

      sqlRecord["諸掛行番"]["value"][k]   = k + 1
      sqlRecord["標準単価"]["value"][k]   = requestDRecord["標準単価"]["value"][i]
      sqlRecord["標準数量"]["value"][k]   = requestDRecord["標準数量"]["value"][i]
      sqlRecord["摘要"]["value"][k]       = requestDRecord["摘要"]["value"][i]
      
      if requestDRecord["請求対象フラグ"]["value"][i] == ""
        sqlRecord["請求対象フラグ"]["value"][k] = "0"
      else
        sqlRecord["請求対象フラグ"]["value"][k] = requestDRecord["請求対象フラグ"]["value"][i]
      end
      
      k = k + 1
      emptySW = "OK"
    end

    $Mlog.debug("R_MainteContractHD2_model") {"set明細登録データOfR_MainteContractHD2OfSetubi end status = #{emptySW}"}
    return emptySW
  end


end

# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfBaseNameMainteOfModelMixin'


class R_MainteServiceHD1_model
  include SetubiOfBaseNameMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("R_MainteServiceHD1_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("R_MainteServiceHD1_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("R_MainteServiceHD1_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # 契約設備明細の登録データを設定する（登録処理用）
  def set明細登録データOfR_MainteServiceHD1OfSetubi()
    $Mlog.debug("R_MainteServiceHD1_model") {"set明細登録データOfR_MainteServiceHD1OfSetubi start"}

    requestRecord = getJsonChunkById(@request_data, "records", "detail",                 "record")
    sqlRecord     = getJsonChunkById(@sql_data,     "sqls",    "detail_insert", "input", "record")

    maxSize = requestRecord["設備タイプ"]["value"].length - 1
    k       = 0
    emptySW = "PASS"
    
    for i in 0..maxSize do
      # 削除データは処理対象外
      if requestRecord["削除"]["value"][i] == "9"
        next
      end
      
      # 設備タイプ未入力は処理対象外
      if requestRecord["設備タイプ"]["value"][i] == ""
        next
      end
      
      sqlRecord["設備行番"]["value"][k]   = k + 1
      sqlRecord["設備タイプ"]["value"][k] = requestRecord["設備タイプ"]["value"][i]
      sqlRecord["設備名"]["value"][k]     = requestRecord["設備名"]["value"][i]
      sqlRecord["契約単価"]["value"][k]   = requestRecord["契約単価"]["value"][i]
      sqlRecord["業者ＩＤ"]["value"][k]   = requestRecord["業者ＩＤ"]["value"][i]
      
      k = k + 1
      emptySW = "OK"
    end

    $Mlog.debug("R_MainteServiceHD1_model") {"set明細登録データOfR_MainteServiceHD1OfSetubi end status = #{emptySW}"}
    return emptySW
  end

  # 契約保守諸掛明細・契約保守作業明細・契約設備明細の削除データを設定する
  def set明細削除データOfR_MainteServiceHD1OfSetubi(sqlID)
    $Mlog.debug("R_MainteServiceHD1_model") {"set明細削除データOfR_MainteServiceHD1OfSetubi start"}

    requestHRecord = getJsonChunkById(@request_data, "records", "header",          "record")
    requestDRecord = getJsonChunkById(@request_data, "records", "detail",          "record")
    sqlRecord      = getJsonChunkById(@sql_data,     "sqls",     sqlID,  "input",  "record")

    maxSize = requestDRecord["削除"]["value"].length - 1
    k       = 0
    emptySW = "PASS"
    
    for i in 0..maxSize do
      # 削除データ以外は処理対象外
      if requestDRecord["削除"]["value"][i] != "9"
        next
      end
      
      # 設備行番未入力は処理対象外
      if requestDRecord["設備行番"]["value"][i] == ""
        next
      end
      
      sqlRecord["契約ＮＯ"]["value"][k] = requestHRecord["契約ＮＯ"]["value"][0]
      sqlRecord["設備行番"]["value"][k] = requestDRecord["設備行番"]["value"][i]
      
      k = k + 1
      emptySW = "OK"
    end

    $Mlog.debug("R_MainteServiceHD1_model") {"set明細削除データOfR_MainteServiceHD1OfSetubi end status = #{emptySW}"}
    return emptySW
  end

  # 契約設備明細の訂正データを設定する
  def set明細訂正データOfR_MainteServiceHD1OfSetubi(sqlID)
    $Mlog.debug("R_MainteServiceHD1_model") {"set明細訂正データOfR_MainteServiceHD1OfSetubi start"}

    requestHRecord = getJsonChunkById(@request_data, "records", "header",          "record")
    requestDRecord = getJsonChunkById(@request_data, "records", "detail",          "record")
    sqlRecord      = getJsonChunkById(@sql_data,     "sqls",     sqlID,  "input",  "record")

    maxSize = requestDRecord["削除"]["value"].length - 1
    k       = 0
    emptySW = "PASS"
    
    for i in 0..maxSize do
      # 削除データは処理対象外
      if requestDRecord["削除"]["value"][i] == "9"
        next
      end
      
      # 設備行番未入力は処理対象外
      if requestDRecord["設備行番"]["value"][i] == ""
        next
      end
      
      sqlRecord["設備タイプ"]["value"][k] = requestDRecord["設備タイプ"]["value"][i]
      sqlRecord["設備名"]["value"][k]     = requestDRecord["設備名"]["value"][i]
      sqlRecord["契約単価"]["value"][k]   = requestDRecord["契約単価"]["value"][i]
      sqlRecord["業者ＩＤ"]["value"][k]   = requestDRecord["業者ＩＤ"]["value"][i]
      
      sqlRecord["契約ＮＯ"]["value"][k]   = requestHRecord["契約ＮＯ"]["value"][0]
      sqlRecord["設備行番"]["value"][k]   = requestDRecord["設備行番"]["value"][i]
      
      k = k + 1
      emptySW = "OK"
    end

    $Mlog.debug("R_MainteServiceHD1_model") {"set明細訂正データOfR_MainteServiceHD1OfSetubi end status = #{emptySW}"}
    return emptySW
  end

  # 契約設備明細の登録データを設定する（訂正処理用）
  def set明細訂正登録データOfR_MainteServiceHD1OfSetubi(sqlID)
    $Mlog.debug("R_MainteServiceHD1_model") {"set明細訂正登録データOfR_MainteServiceHD1OfSetubi start"}

    requestHRecord = getJsonChunkById(@request_data, "records", "header",          "record")
    requestDRecord = getJsonChunkById(@request_data, "records", "detail",          "record")
    sqlRecord      = getJsonChunkById(@sql_data,     "sqls",     sqlID,  "input",  "record")
    
    maxSize = requestDRecord["削除"]["value"].length - 1
    emptySW = "PASS"

    # 設備業番の最大値を設定する
    w_設備業番 = 0
    for i in 0..maxSize do
      if requestDRecord["設備行番"]["value"][i] == ""
        next
      end

      if requestDRecord["設備行番"]["value"][i] > w_設備業番
        w_設備業番 = requestDRecord["設備行番"]["value"][i]
      end
    end
    w_設備業番 = w_設備業番 + 1
    
    k = 0
    for i in 0..maxSize do
      # 削除データは処理対象外
      if requestDRecord["削除"]["value"][i] == "9"
        next
      end
      
      # 設備行番入力は処理対象外
      if requestDRecord["設備行番"]["value"][i] != ""
        next
      end
      
      sqlRecord["契約ＮＯ"]["value"][k]   = requestHRecord["契約ＮＯ"]["value"][0]
      sqlRecord["設備行番"]["value"][k]   = w_設備業番
      
      sqlRecord["設備タイプ"]["value"][k] = requestDRecord["設備タイプ"]["value"][i]
      sqlRecord["設備名"]["value"][k]     = requestDRecord["設備名"]["value"][i]
      sqlRecord["契約単価"]["value"][k]   = requestDRecord["契約単価"]["value"][i]
      sqlRecord["業者ＩＤ"]["value"][k]   = requestDRecord["業者ＩＤ"]["value"][i]
      
      k          = k + 1
      w_設備業番 = w_設備業番 + 1
      emptySW    = "OK"
    end

    $Mlog.debug("R_MainteServiceHD1_model") {"set明細訂正登録データOfR_MainteServiceHD1OfSetubi end status = #{emptySW}"}
    return emptySW
  end

end

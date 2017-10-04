# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfBaseNameMainteOfModelMixin'

class R_TraderEquipmentType_model
  include SetubiOfBaseNameMainteOfModelMixin

  def initialize(rmenu_db, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("R_TraderEquipmentType_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_db       = rmenu_db
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("R_TraderEquipmentType_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("R_TraderEquipmentType_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end
  
  
  # 削除データを設定する
  def setDeleteDataOfR_TraderEquipmentTypeOfSetubi(sqlsId)
    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setDeleteDataOfR_TraderEquipmentTypeOfSetubi start"}                  # Logファイル Debug用

    requestHeaderRecord = getJsonChunkById(@request_data, "records", "header")["record"]
    requestDetailRecord = getJsonChunkById(@request_data, "records", "detail")["record"]
    sqlRecord           = getJsonChunkById(@sql_data, "sqls", sqlsId)["input"]["record"]

    w_削除      = requestDetailRecord["削除"]["value"]
    maxSize     = w_削除.length - 1
    emptySW     = "PASS"
    j           = 0

    for i in 0..maxSize do
      if w_削除[i] != "9"
        next
      end

      sqlRecord["業者ＩＤ"]["value"][j]   = requestHeaderRecord["業者ＩＤ"]["value"][0]
      sqlRecord["設備タイプ"]["value"][j] = requestDetailRecord["設備タイプ"]["value"][i]
      
      emptySW = "OK"
      j       = j + 1
    end

    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setDeleteDataOfR_TraderEquipmentTypeOfSetubi end status = #{emptySW}"}
    return emptySW
  end
  

  # 更新データを設定する
  def setUpdateDataOfR_TraderEquipmentTypeOfSetubi(sqlsId)
    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setUpdateDataOfR_TraderEquipmentTypeOfSetubi start"}                  # Logファイル Debug用

    requestHeaderRecord = getJsonChunkById(@request_data, "records", "header")["record"]
    requestDetailRecord = getJsonChunkById(@request_data, "records", "detail")["record"]
    sqlRecord           = getJsonChunkById(@sql_data, "sqls", sqlsId)["input"]["record"]

    w_削除      = requestDetailRecord["削除"]["value"]
    maxSize     = w_削除.length - 1
    emptySW     = "PASS"
    j           = 0

    for i in 0..maxSize do
      if w_削除[i] == "9"
        next
      end

      sqlRecord["業者ＩＤ"]["value"][j]   = requestHeaderRecord["業者ＩＤ"]["value"][0]
      sqlRecord["設備タイプ"]["value"][j] = requestDetailRecord["設備タイプ"]["value"][i]
      
      emptySW = "OK"
      j       = j + 1
    end

    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setUpdateDataOfR_TraderEquipmentTypeOfSetubi end status = #{emptySW}"}
    return emptySW
  end


  # 登録データを設定する
  def setInsertDataOfR_TraderEquipmentTypeOfSetubi(sqlsId)
    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setInsertDataOfR_TraderEquipmentTypeOfSetubi start"}                  # Logファイル Debug用

    requestHeaderRecord = getJsonChunkById(@request_data, "records", "header")["record"]
    requestDetailRecord = getJsonChunkById(@request_data, "records", "detail")["record"]
    sqlRecord           = getJsonChunkById(@sql_data, "sqls", sqlsId)["input"]["record"]

    w_削除      = requestDetailRecord["削除"]["value"]
    maxSize     = w_削除.length - 1
    emptySW     = "PASS"
    j           = 0

    for i in 0..maxSize do
      if w_削除[i] == "9"
        next
      end

      sqlRecord["業者ＩＤ"]["value"][j]   = requestHeaderRecord["業者ＩＤ"]["value"][0]
      sqlRecord["設備タイプ"]["value"][j] = requestDetailRecord["設備タイプ"]["value"][i]
      sqlRecord["摘要"]["value"][j]       = requestDetailRecord["摘要"]["value"][i]
      
      emptySW = "OK"
      j       = j + 1
    end

    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setInsertDataOfR_TraderEquipmentTypeOfSetubi end status = #{emptySW}"}
    return emptySW
  end

end

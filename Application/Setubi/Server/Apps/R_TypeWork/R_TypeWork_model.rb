# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfBaseNameMainteOfModelMixin'

class R_TypeWork_model
  include SetubiOfBaseNameMainteOfModelMixin

  def initialize(rmenu_db, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("R_TypeWork_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_db       = rmenu_db
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("R_TypeWork_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("R_TypeWork_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end
  
  
  # 削除データを設定する
  def setDeleteDataOfR_TypeWorkOfSetubi(sqlsId)
    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setDeleteDataOfR_TypeWorkOfSetubi start"}                  # Logファイル Debug用

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

      sqlRecord["設備タイプ"]["value"][j] = requestHeaderRecord["設備タイプ"]["value"][0]
      sqlRecord["作業区分"]["value"][j]   = requestDetailRecord["作業区分"]["value"][i]
      
      emptySW = "OK"
      j       = j + 1
    end

    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setDeleteDataOfR_TypeWorkOfSetubi end status = #{emptySW}"}
    return emptySW
  end
  

  # 更新データを設定する
  def setUpdateDataOfR_TypeWorkOfSetubi(sqlsId)
    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setUpdateDataOfR_TypeWorkOfSetubi start"}                  # Logファイル Debug用

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

      sqlRecord["設備タイプ"]["value"][j] = requestHeaderRecord["設備タイプ"]["value"][0]
      sqlRecord["作業区分"]["value"][j]   = requestDetailRecord["作業区分"]["value"][i]
      
      emptySW = "OK"
      j       = j + 1
    end

    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setUpdateDataOfR_TypeWorkOfSetubi end status = #{emptySW}"}
    return emptySW
  end


  # 登録データを設定する
  def setInsertDataOfR_TypeWorkOfSetubi(sqlsId)
    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setInsertDataOfR_TypeWorkOfSetubi start"}                  # Logファイル Debug用

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

      sqlRecord["設備タイプ"]["value"][j] = requestHeaderRecord["設備タイプ"]["value"][0]
      sqlRecord["作業区分"]["value"][j]   = requestDetailRecord["作業区分"]["value"][i]
      sqlRecord["摘要"]["value"][j]       = requestDetailRecord["摘要"]["value"][i]
      
      emptySW = "OK"
      j       = j + 1
    end

    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setInsertDataOfR_TypeWorkOfSetubi end status = #{emptySW}"}
    return emptySW
  end

end

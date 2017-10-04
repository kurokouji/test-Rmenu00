# coding: UTF-8

require 'RmenuLoggerMixin'                                                      # Logファイル Debug用
require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する

module SetubiOfBaseNameMainteOfModelMixin
  include RmenuLoggerMixin                                                      # Logファイル Debug用
  include RmenuJsonMixin

  # 基本名称メンテナンス用　モジュール
  # 削除データを設定する
  def setDeleteDataOfSetubi(requestID, sqlsId, idName)
    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setDeleteDataOfSetubi start"}                  # Logファイル Debug用

    requestInfo   = getJsonChunkById(@request_data, "records", requestID)
    requestRecord = requestInfo["record"]

    sqlInfo       = getJsonChunkById(@sql_data, "sqls", sqlsId)
    sqlRecord     = sqlInfo["input"]["record"]

    deleteCheck   = requestRecord["削除"]["value"]
    idData        = requestRecord[idName]["value"]
    maxLength     = deleteCheck.length - 1
    j             = 0
    emptySW       = "PASS"
    for i in 0..maxLength do
      if deleteCheck[i] != "9"
        next
      end
      if idData[i] == ""
        next
      end

      requestRecord.each{|key, value|
        if sqlRecord.key?("#{key}")
          sqlRecord[key]["value"][j] = value["value"][i]
          emptySW = "OK"
        end
      }
      j = j + 1
    end

    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setDeleteDataOfSetubi end status = #{emptySW}"}
    return emptySW
  end

  # 基本名称メンテナンス用　モジュール
  # 更新データを設定する
  def setUpdateDataOfSetubi(requestID, sqlsId, idName)
    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setUpdateDataOfSetubi start"}                  # Logファイル Debug用

    requestInfo   = getJsonChunkById(@request_data, "records", requestID)
    requestRecord = requestInfo["record"]

    sqlInfo       = getJsonChunkById(@sql_data, "sqls", sqlsId)
    sqlRecord     = sqlInfo["input"]["record"]

    deleteCheck   = requestRecord["削除"]["value"]
    idData        = requestRecord[idName]["value"]
    maxLength     = deleteCheck.length - 1
    j             = 0
    emptySW       = "PASS"
    for i in 0..maxLength do
      if deleteCheck[i] == "9"
        next
      end
      if idData[i] == ""
        next
      end

      requestRecord.each { |key, value|
        if sqlRecord.key?("#{key}")
          sqlRecord[key]["value"][j] = value["value"][i]
          emptySW = "OK"
        end
      }
      j = j + 1
    end

    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setUpdateDataOfSetubi end status = #{emptySW}"}
    return emptySW
  end

  # 基本名称メンテナンス用　モジュール
  # 登録データを設定する
  def setInsertDataOfSetubi(requestID, sqlsId, idName)
    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setInsertDataOfSetubi start"}                  # Logファイル Debug用

    requestInfo   = getJsonChunkById(@request_data, "records", requestID)
    requestRecord = requestInfo["record"]

    sqlInfo       = getJsonChunkById(@sql_data, "sqls", sqlsId)
    sqlRecord     = sqlInfo["input"]["record"]

    deleteCheck   = requestRecord["削除"]["value"]
    idData        = requestRecord[idName]["value"]
    maxLength     = deleteCheck.length - 1
    j             = 0
    emptySW       = "PASS"
    for i in 0..maxLength do
      if deleteCheck[i] == "9"
        next
      end
      if idData[i] != ""
        next
      end

      requestRecord.each { |key, value|
        if sqlRecord.key?("#{key}")
          sqlRecord[key]["value"][j] = value["value"][i]
          emptySW = "OK"
        end
      }
      j = j + 1
    end

    $Mlog.debug("SetubiOfBaseNameMainteOfModelMixin_model") {"setInsertDataOfSetubi end status = #{emptySW}"}
    return emptySW
  end

end

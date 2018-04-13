# coding: UTF-8

require 'json'
require 'open3'
require 'RmenuLoggerMixin'                                                      # Logファイル Debug用
require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する

module Myapp00OfBatchStartUpOfModelMixin
  include RmenuLoggerMixin                                                      # Logファイル Debug用
  include RmenuJsonMixin

  # バッチ起動処理（起動する側）
  def batch_startup(projectName, programName, mode, startupProgramName)
    $Mlog.debug("Myapp00OfBatchStartUpOfModelMixin") {"batch_startup start"}

    keyRecord    = getJsonChunkById(@sql_data,  "sqls",  "batchKey",   "input", "record")
    paramRecord  = getJsonChunkById(@sql_data,  "sqls",  "batchParam", "input", "record")

    str_sql      = "SELECT プロジェクト名, プログラム名, モード, MAX(起動連番) FROM バッチ起動パラメータ"
    str_sql     += " WHERE プロジェクト名 = '#{projectName}'"
    str_sql     += " AND   プログラム名   = '#{programName}'"
    str_sql     += " AND   モード         = '#{mode}'"
    str_sql     += " GROUP BY"
    str_sql     += " プロジェクト名, プログラム名, モード"

    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"@rmenu_db: #{@rmenu_db}"}
    valueArray   = @rmenu_db["default"].select_namevalue(str_sql)
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"valueArray: #{valueArray}"}
    
    if valueArray.empty?
      startNo = 0
    else
      startNo = valueArray[0]["起動連番"].to_i + 1
    end
    
    # バッチ起動パラメータ　登録
    batch_startup_insert(projectName, programName, mode, startNo, keyRecord, paramRecord)
    
    # Rubyプログラム　起動
    batch_startup_ruby(projectName, startupProgramName)

    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"batch_startup end"}
    return "OK"
  end
  
  
  # バッチ起動処理（起動される側）
  def batch_paramkeyget(projectName, programName, mode)
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"batch_paramkeyget start"}

    keyRecord    = getJsonChunkById(@sql_data,  "sqls",  "parallelKey",   "input", "record")
    paramRecord  = getJsonChunkById(@sql_data,  "sqls",  "parallelParam", "input", "record")

    str_sql      = "SELECT MIN(起動連番) FROM バッチ起動パラメータ"
    str_sql     += " WHERE プロジェクト名 = '#{projectName}'"
    str_sql     += " AND   プログラム名   = '#{programName}'"
    str_sql     += " AND   モード         = '#{mode}'"
    str_sql     += " GROUP BY"
    str_sql     += " プロジェクト名, プログラム名, モード"
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"sql1 = #{str_sql}"}
    startNo      = @rmenu_db["default"].select_value(str_sql)


    str_sql      = "SELECT バッチキーデータ, バッチパラメータ FROM バッチ起動パラメータ"
    str_sql     += " WHERE プロジェクト名 = '#{projectName}'"
    str_sql     += " AND   プログラム名   = '#{programName}'"
    str_sql     += " AND   モード         = '#{mode}'"
    str_sql     += " AND   起動連番       = #{startNo}"
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"sql2 = #{str_sql}"}
    valueArray   = @rmenu_db["default"].select_namevalue(str_sql)
    
    if valueArray.empty?
      $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"バッチ起動パラメータがありません。"}
      $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"batch_paramkeyget abnormal end"}
      return "ERROR"
    end
    

    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"keyRecord   = #{valueArray[0]["バッチキーデータ"]}"}
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"paramRecord = #{valueArray[0]["バッチパラメータ"]}"}
    
    # json文字列をHashに変換する
    keyHash   = JSON.load(valueArray[0]["バッチキーデータ"])
    paramHash = JSON.load(valueArray[0]["バッチパラメータ"])
    
    keyHash.each do |name, value|
     if keyRecord.has_key?(name)
       maxSize = value["value"].length - 1
       for i in 0..maxSize
         keyRecord[name]["value"][i] = value["value"][i]
       end
     end
    end
    
    paramHash.each do |name, value|
     if paramRecord.has_key?(name)
       maxSize = value["value"].length - 1
       for i in 0..maxSize
         paramRecord[name]["value"][i] = value["value"][i]
       end
     end
    end
    
    # バッチ起動パラメータ　削除
    batch_startup_delete(projectName, programName, mode, startNo)
    
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"batch_paramkeyget end"}
    return "OK"
  end
  
  # バッチ起動パラメータ　登録
  def batch_startup_insert(projectName, programName, mode, startNo, keyRecord, paramRecord)
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"batch_startup_insert start"}

    str_sql      = "INSERT INTO バッチ起動パラメータ"
    str_sql     += " (プロジェクト名, プログラム名, モード, 起動連番, バッチキーデータ, バッチパラメータ)"
    str_sql     += " VALUES ("
    str_sql     += " '#{projectName}',"
    str_sql     += " '#{programName}',"
    str_sql     += " '#{mode}',"
    str_sql     += " #{startNo},"
    
    # hashオブジェクトをJSON文字列に変換する
    str_sql     += " '#{JSON.dump(keyRecord)}',"
    str_sql     += " '#{JSON.dump(paramRecord)}'"
    str_sql     += ")"
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"sql = #{str_sql}"}
    @rmenu_db["default"].insert(str_sql)
        
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"batch_startup_insert end"}
    return "OK"
  end
  
  # バッチ起動パラメータ　削除
  def batch_startup_delete(projectName, programName, mode, startNo)
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"batch_startup_delete start"}

    str_sql      = "DELETE FROM バッチ起動パラメータ"
    str_sql     += " WHERE プロジェクト名 = '#{projectName}'"
    str_sql     += " AND   プログラム名   = '#{programName}'"
    str_sql     += " AND   モード         = '#{mode}'"
    str_sql     += " AND   起動連番       = #{startNo}"
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"sql = #{str_sql}"}
    @rmenu_db["default"].delete(str_sql)
        
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"batch_startup_delete end"}
    return "OK"
  end
  
  # Rubyプログラム　起動
  def batch_startup_ruby(projectName, startupProgramName)
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"batch_startup_ruby start"}

    command = "ruby " + $Rconfig['base_application'] + "/" + projectName + "/Server/BachProcess/" + startupProgramName + ".rb"
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"command = #{command}"}
    Open3.popen3(command)

    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"batch_startup_ruby end"}
    return "OK"
  end
  
end

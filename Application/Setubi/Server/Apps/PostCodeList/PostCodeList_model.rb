# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfMasterMainteOfModelMixin'

class PostCodeList_model
  include SetubiOfMasterMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("PostCodeList_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("PostCodeList_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("PostCodeList_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # SQL文の検索条件を変更する（検索データ項目名無し）
  def setSql_PostCodeListOfSetubi(idname1, idname2 ,genesql_freesql)
    $Mlog.debug("PostCodeList_model") {"setSql_PostCodeListOfSetubi start"}                  # Logファイル Debug用

    requestInfo          = getJsonChunkById(@request_data, "records", idname1)
    sqlInfo              = getJsonChunkById(@sql_data, "sqls", idname2)

    w_検索郵便番号   = requestInfo["record"]["検索郵便番号"]["value"][0]
    w_検索町域名カナ   = requestInfo["record"]["検索町域名カナ"]["value"][0]
    w_検索市区町村名 = requestInfo["record"]["検索市区町村名"]["value"][0]


    rep = ""

    # 郵便番号
    if w_検索郵便番号 != ""
      rep = rep + " AND 郵便番号 LIKE '%#{w_検索郵便番号}%'"
    end

    # 町域名カナ
    if w_検索町域名カナ != ""
      rep = rep + " AND 町域名カナ LIKE '%#{w_検索町域名カナ}%'"
    end

    # 市区町村名
    if w_検索市区町村名 != ""
      rep = rep + " AND 市区町村名 LIKE '%#{w_検索市区町村名}%'"
    end



    # 検索条件の置き換え
    if    genesql_freesql == 'genesql'
      sqlInfo["sql"]["genesql"]["where"].sub!(/&&/,rep)
    elsif genesql_freesql == 'freesql'
      strJoin = sqlInfo["sql"]["freesql"].join("\t")
      strJoin.sub!(/&&/,rep)
      strSplit = strJoin.split("\t")
      sqlInfo["sql"]["freesql"].each_with_index do |temp, idx|
        sqlInfo["sql"]["freesql"][idx] = strSplit[idx]
      end
    end

    $Mlog.debug("PostCodeList_model") {"setSql_PostCodeListOfSetubi end"}                    # Logファイル Debug用
    return "OK"
  end


end

# coding: UTF-8

require 'Myapp00/Server/Modules/Myapp00OfMasterMainteOfModelMixin'

class R_SalesPersonList_model
  include Myapp00OfMasterMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("R_SalesPersonList_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("R_SalesPersonList_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("R_SalesPersonList_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # SQL文の検索条件を変更する（検索データ項目名無し）
  def setSql_R_SalesPersonListOfMyapp00(idname1, idname2 ,genesql_freesql)
    $Mlog.debug("R_SalesPersonList_model") {"setSql_R_SalesPersonListOfMyapp00 start"}                  # Logファイル Debug用

    requestInfo     = getJsonChunkById(@request_data, "records", idname1)
    sqlInfo         = getJsonChunkById(@sql_data, "sqls", idname2)

    w_検索営業担当者名  = requestInfo["record"]["検索営業担当者名"]["value"][0]
    w_検索索引  = requestInfo["record"]["検索索引"]["value"][0]
    w_検索摘要      = requestInfo["record"]["検索摘要"]["value"][0]


    rep = ""

    # 検索営業担当者名
    if w_検索営業担当者名 != ""
      rep = rep + " AND 名称 LIKE '%#{w_検索営業担当者名}%'"
    end

    # 検索索引
    if w_検索索引 != ""
      rep = rep + " AND 索引 LIKE '%#{w_検索索引}%'"
    end

    # 検索摘要
    if w_検索摘要 != ""
      rep = rep + " AND 所在地 LIKE '%#{w_検索摘要}%'"
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

    $Mlog.debug("R_SalesPersonList_model") {"setSql_R_SalesPersonListOfMyapp00 end"}                    # Logファイル Debug用
    return "OK"
  end


end

# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfMasterMainteOfModelMixin'

class R_MainteContractList_model
  include SetubiOfMasterMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("R_MainteContractList_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("R_MainteContractList_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("R_MainteContractList_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # SQL文の検索条件を変更する（検索データ項目名無し）
  def setSql_R_MainteContractListOfSetubi(idname1, idname2 ,genesql_freesql)
    $Mlog.debug("R_MainteContractList_model") {"setSql_R_MainteContractListOfSetubi start"}                  # Logファイル Debug用

    requestInfo          = getJsonChunkById(@request_data, "records", idname1)
    sqlInfo              = getJsonChunkById(@sql_data, "sqls", idname2)

    w_検索顧客名称       = requestInfo["record"]["検索顧客名称"]["value"][0]
    w_検索設備タイプ名称 = requestInfo["record"]["検索設備タイプ名称"]["value"][0]
    w_検索設備名称       = requestInfo["record"]["検索設備名称"]["value"][0]
    w_検索業者名称       = requestInfo["record"]["検索業者名称"]["value"][0]
    w_検索作業区分       = requestInfo["record"]["検索作業区分"]["value"][0]


    rep = ""

    # 検索顧客名称
    if w_検索顧客名称 != ""
      rep = rep + " AND E.名称 LIKE '%#{w_検索顧客名称}%'"
    end

    # 検索設備タイプ名称
    if w_検索設備タイプ名称 != ""
      rep = rep + " AND F.名称 LIKE '%#{w_検索設備タイプ名称}%'"
    end

    # 検索設備名称
    if w_検索設備名称 != ""
      rep = rep + " AND B.設備名 LIKE '%#{w_検索設備名称}%'"
    end

    # 検索業者名称
    if w_検索業者名称 != ""
      rep = rep + " AND G.名称 LIKE '%#{w_検索業者名称}%'"
    end

    # 検索作業区分
    if w_検索作業区分 != ""
      rep = rep + " AND C.作業区分 LIKE '%#{w_検索作業区分}%'"
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

    $Mlog.debug("R_MainteContractList_model") {"setSql_R_MainteContractListOfSetubi end"}                    # Logファイル Debug用
    return "OK"
  end


end

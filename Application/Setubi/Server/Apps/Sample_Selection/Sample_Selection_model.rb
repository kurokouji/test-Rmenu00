# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfMasterMainteOfModelMixin'

class Sample_Selection_model
  include SetubiOfMasterMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("Sample_Selection_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("Sample_Selection_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("Sample_Selection_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # SQL文の検索条件を変更する（検索データ項目名無し）
  def setSql_Sample_SelectionOfSetubi(idname1, idname2 ,genesql_freesql)
    $Mlog.debug("Sample_Selection_model") {"setSql_Sample_SelectionOfSetubi start"}                  # Logファイル Debug用

    requestInfo     = getJsonChunkById(@request_data, "records", idname1)
    sqlInfo         = getJsonChunkById(@sql_data, "sqls", idname2)

    w_検索サンプル項目１  = requestInfo["record"]["検索サンプル項目１"]["value"][0]
    w_検索サンプル項目２  = requestInfo["record"]["検索サンプル項目２"]["value"][0]
    w_検索サンプル項目３  = requestInfo["record"]["検索サンプル項目３"]["value"][0]


    rep = ""

    # 検索サンプル項目１
    if w_検索サンプル項目１ != ""
      rep = rep + " AND サンプル項目１ LIKE '%#{w_検索サンプル項目１}%'"
    end

    # 検索サンプル項目２
    if w_検索サンプル項目２ != ""
      rep = rep + " AND サンプル項目２ LIKE '%#{w_検索サンプル項目２}%'"
    end

    # 検索サンプル項目３
    if w_検索サンプル項目３ != ""
      rep = rep + " AND サンプル項目３ LIKE '%#{w_検索サンプル項目３}%'"
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

    $Mlog.debug("Sample_Selection_model") {"setSql_Sample_SelectionOfSetubi end"}                    # Logファイル Debug用
    return "OK"
  end


end

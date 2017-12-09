# coding: UTF-8

require 'Myapp00/Server/Modules/Myapp00OfMasterMainteOfModelMixin'

class T_Sample_Selection_model
  include Myapp00OfMasterMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("T_Sample_Selection_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("T_Sample_Selection_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("T_Sample_Selection_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # SQL文の検索条件を変更する（検索データ項目名無し）
  def setSql_T_Sample_SelectionOfMyapp00(idname1, idname2 ,genesql_freesql)
    $Mlog.debug("T_Sample_Selection_model") {"setSql_T_Sample_SelectionOfMyapp00 start"}                  # Logファイル Debug用

    requestInfo     = getJsonChunkById(@request_data, "records", idname1)
    sqlInfo         = getJsonChunkById(@sql_data, "sqls", idname2)

    w_検索Ｔサンプル_マスタ項目０１  = requestInfo["record"]["検索Ｔサンプル_マスタ項目０１"]["value"][0]
    w_検索Ｔサンプル_マスタ項目０２  = requestInfo["record"]["検索Ｔサンプル_マスタ項目０２"]["value"][0]
    w_検索Ｔサンプル_マスタ項目０３  = requestInfo["record"]["検索Ｔサンプル_マスタ項目０３"]["value"][0]


    rep = ""

    # 検索Ｔサンプル_マスタ項目０１
    if w_検索Ｔサンプル_マスタ項目０１ != ""
      rep = rep + " AND Ｔサンプル_マスタ項目０１ LIKE '%#{w_検索Ｔサンプル_マスタ項目０１}%'"
    end

    # 検索Ｔサンプル_マスタ項目０２
    if w_検索Ｔサンプル_マスタ項目０２ != ""
      rep = rep + " AND Ｔサンプル_マスタ項目０２ LIKE '%#{w_検索Ｔサンプル_マスタ項目０２}%'"
    end

    # 検索Ｔサンプル_マスタ項目０３
    if w_検索Ｔサンプル_マスタ項目０３ != ""
      rep = rep + " AND Ｔサンプル_マスタ項目０３ LIKE '%#{w_検索Ｔサンプル_マスタ項目０３}%'"
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

    $Mlog.debug("T_Sample_Selection_model") {"setSql_T_Sample_SelectionOfMyapp00 end"}                    # Logファイル Debug用
    return "OK"
  end


end

# coding: UTF-8

require 'Myapp00/Server/Modules/Myapp00OfMasterMainteOfModelMixin'

class T_Sample_ParentChildList_model
  include Myapp00OfMasterMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("T_Sample_ParentChildList_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("T_Sample_ParentChildList_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("T_Sample_ParentChildList_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # SQL文の検索条件を変更する（検索データ項目名無し）
  def setSql_T_Sample_ParentChildListOfMyapp00(idname1, idname2 ,genesql_freesql)
    $Mlog.debug("T_Sample_ParentChildList_model") {"setSql_T_Sample_ParentChildListOfMyapp00 start"}                  # Logファイル Debug用

    requestInfo          = getJsonChunkById(@request_data, "records", idname1)
    sqlInfo              = getJsonChunkById(@sql_data, "sqls", idname2)

    w_検索ヘッダ項目１   = requestInfo["record"]["検索ヘッダ項目１"]["value"][0]
    w_検索ヘッダ項目２   = requestInfo["record"]["検索ヘッダ項目２"]["value"][0]
    w_検索Ｔサンプル_マスタ項目０１ = requestInfo["record"]["検索Ｔサンプル_マスタ項目０１"]["value"][0]


    rep = ""

    # ヘッダ項目１
    if w_検索ヘッダ項目１ != ""
      rep = rep + " AND A.Ｔサンプル_ヘッダ項目０１ LIKE '%#{w_検索ヘッダ項目１}%'"
    end

    # ヘッダ項目２
    if w_検索ヘッダ項目２ != ""
      rep = rep + " AND A.Ｔサンプル_ヘッダ項目０２ LIKE '%#{w_検索ヘッダ項目２}%'"
    end

    # Ｔサンプル_マスタ項目０１
    if w_検索Ｔサンプル_マスタ項目０１ != ""
      rep = rep + " AND C.Ｔサンプル_マスタ項目０１ LIKE '%#{w_検索Ｔサンプル_マスタ項目０１}%'"
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

    $Mlog.debug("T_Sample_ParentChildList_model") {"setSql_T_Sample_ParentChildListOfMyapp00 end"}                    # Logファイル Debug用
    return "OK"
  end


end

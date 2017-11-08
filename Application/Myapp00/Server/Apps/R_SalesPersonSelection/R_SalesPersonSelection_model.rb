# coding: UTF-8

require 'Myapp00/Server/Modules/Myapp00OfMasterMainteOfModelMixin'

class R_SalesPersonSelection_model
  include Myapp00OfMasterMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("R_SalesPersonSelection_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("R_SalesPersonSelection_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("R_SalesPersonSelection_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # SQL文の検索条件を変更する（検索データ項目名無し）
  def setSql_R_SalesPersonSelectionOfMyapp00(idname1, idname2 ,genesql_freesql)
    $Mlog.debug("R_SalesPersonSelection_model") {"setSql_R_SalesPersonSelectionOfMyapp00 start"}                  # Logファイル Debug用

    requestInfo     = getJsonChunkById(@request_data, "records", idname1)
    sqlInfo         = getJsonChunkById(@sql_data, "sqls", idname2)

    w_検索得意先名称  = requestInfo["record"]["検索得意先名称"]["value"][0]
    w_検索郵便番号  = requestInfo["record"]["検索郵便番号"]["value"][0]
    w_検索住所      = requestInfo["record"]["検索住所"]["value"][0]


    rep = ""

    # 検索得意先名称
    if w_検索得意先名称 != ""
      rep = rep + " AND 名称 LIKE '%#{w_検索得意先名称}%'"
    end

    # 検索郵便番号
    if w_検索郵便番号 != ""
      rep = rep + " AND 郵便番号 LIKE '%#{w_検索郵便番号}%'"
    end

    # 検索住所
    if w_検索住所 != ""
      rep = rep + " AND 所在地 LIKE '%#{w_検索住所}%'"
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

    $Mlog.debug("R_SalesPersonSelection_model") {"setSql_R_SalesPersonSelectionOfMyapp00 end"}                    # Logファイル Debug用
    return "OK"
  end


end

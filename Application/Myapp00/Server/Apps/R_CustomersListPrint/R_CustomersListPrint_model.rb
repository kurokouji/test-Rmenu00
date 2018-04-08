# coding: UTF-8

require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する
require 'RmenuLoggerMixin'                                                      # Logファイル Debug用

class R_CustomersListPrint_model
  include RmenuJsonMixin

  def initialize(rmenu_db, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("R_CustomersListPrint_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_db       = rmenu_db
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("R_CustomersListPrint_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("R_CustomersListPrint_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end


  # SQL文の検索条件を変更する
  def setSql(idname1, idname2 ,genesql_freesql)
    $Mlog.debug("R_CustomersListPrint_model") {"setSql start"}                  # Logファイル Debug用

    requestInfo  = getJsonChunkById(@request_data, "records", idname1)

    goveCode  = requestInfo["record"]["検索得意先名称"]["value"][0]
    postCode  = requestInfo["record"]["検索郵便番号"      ]["value"][0]
    prefKana  = requestInfo["record"]["検索住所"]["value"][0]

    sqlInfo      = getJsonChunkById(@sql_data, "sqls", idname2)

    rep = "true"

    # 検索全国地方公共団体コード
    if goveCode != ""
        rep = rep + " AND 得意先名称 LIKE '#{goveCode}%'"
    end

    # 検索郵便番号
    if postCode != ""
        rep = rep + " AND 郵便番号 like '#{postCode}%'"
    end

    # 検索都道府県名カナ
    if prefKana != ""
        rep = rep + " AND 所在地 like '#{prefKana}%'"
    end

    $Mlog.debug("R_CustomersListPrint_model") {rep}               # Logファイル Debug用

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


    $Mlog.debug("R_CustomersListPrint_model") {"setSql end"}                    # Logファイル Debug用
    return "OK"
  end

end

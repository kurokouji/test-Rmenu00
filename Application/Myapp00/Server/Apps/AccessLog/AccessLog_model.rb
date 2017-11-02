# coding: UTF-8

require 'Myapp00/Server/Modules/Myapp00OfMasterMainteOfModelMixin'

class AccessLog_model
  include Myapp00OfMasterMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("AccessLog_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("AccessLog_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("AccessLog_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end
	
  # SQL文の検索条件を変更する（検索データ項目名無し）
  def setSql_AccessLogOfMyapp00(idname1, idname2 ,genesql_freesql)
    $Mlog.debug("AccessLog_model") {"setSql_AccessLogOfMyapp00 start"}                  # Logファイル Debug用

    requestInfo        = getJsonChunkById(@request_data, "records", idname1)
    sqlInfo            = getJsonChunkById(@sql_data,     "sqls",    idname2)

    w_検索従業員コード = requestInfo["record"]["検索従業員コード"]["value"][0]
    w_アクセス日付     = requestInfo["record"]["アクセス日付"]["value"][0]


    rep = ""

    # 検索従業員コード
    if w_検索従業員コード != ""
      rep = rep + " AND A.ユーザＩＤ = #{w_検索従業員コード}"
    end

    # アクセス日付
    if w_アクセス日付 != ""
      rep = rep + " AND TO_CHAR(A.アクセス日時, 'YYYY/MM/DD') = '#{w_アクセス日付}'"
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

    $Mlog.debug("AccessLog_model") {"setSql_AccessLogOfMyapp00 end"}                    # Logファイル Debug用
    return "OK"
  end


end

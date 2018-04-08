# coding: UTF-8

class R_CustomersList_controller

  def initialize(request_data, validation_data)
    begin
      # initialize 開始ログを出力する
      $Clog.debug("R_CustomersList_controller") {"initialize start"}              # Logファイル Debug用

      @request_data      = request_data
      @validation_data   = validation_data
      
      # initialize 終了ログを出力する
      $Clog.debug("R_CustomersList_controller") {"initialize normal end"}         # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Clog.error("R_CustomersList_controller") {"initialize exception: #{$!}"}   # Logファイル Debug用
      raise
    end
  end


  # SQL文の検索条件を変更する
  def setSql(idname1, idname2 ,genesql_freesql)
    $Mlog.debug("R_CustomersList_model") {"setSql start"}                  # Logファイル Debug用

    requestInfo  = getJsonChunkById(@request_data, "records", idname1)

    goveCode  = requestInfo["record"]["検索全国地方公共団体コード"]["value"][0]
    postCode  = requestInfo["record"]["検索郵便番号"      ]["value"][0]
    prefKana  = requestInfo["record"]["検索都道府県名カナ"]["value"][0]
    cityKana  = requestInfo["record"]["検索市区町村名カナ"]["value"][0]
    chouKana  = requestInfo["record"]["検索町域名カナ"    ]["value"][0]
    prefName  = requestInfo["record"]["検索都道府県名"    ]["value"][0]
    cityName  = requestInfo["record"]["検索市区町村名"    ]["value"][0]
    chouName  = requestInfo["record"]["検索町域名"        ]["value"][0]

    sqlInfo      = getJsonChunkById(@sql_data, "sqls", idname2)

    rep = "true"

    # 検索全国地方公共団体コード
    if goveCode != ""
        rep = rep + " AND 全国地方公共団体コード LIKE '#{goveCode}%'"
    end

    # 検索郵便番号
    if postCode != ""
        rep = rep + " AND 郵便番号 like '#{postCode}%'"
    end

    # 検索都道府県名カナ
    if prefKana != ""
        rep = rep + " AND 都道府県名カナ like '#{prefKana}%'"
    end

    # 検索市区町村名カナ
    if cityKana != ""
        rep = rep + " AND 市区町村名カナ like '#{cityKana}%'"
    end

    # 検索町域名カナ
    if chouKana != ""
        rep = rep + " AND 町域名カナ like '%#{chouKana}%'"
    end

    # 検索都道府県名
    if prefName != ""
        rep = rep + " AND 都道府県名 like '#{prefName}%'"
    end

    # 検索市区町村名
    if cityName != ""
        rep = rep + " AND 市区町村名 like '#{cityName}%'"
    end

    # 検索町域名
    if chouName != ""
        rep = rep + " AND 町域名 like '%#{chouName}%'"
    end


    sqlInfo["sql"]["genesql"]["where"] = rep

    $Mlog.debug("R_CustomersList_model") {rep}               # Logファイル Debug用

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

    $Mlog.debug("R_CustomersList_model") {"setSql end"}                    # Logファイル Debug用
    return "OK"
  end
end

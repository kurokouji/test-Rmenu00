# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfMasterMainteOfModelMixin'

class R_MainteServiceList_model
  include SetubiOfMasterMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("R_MainteServiceList_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("R_MainteServiceList_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("R_MainteServiceList_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # SQL文の検索条件を変更する（検索データ項目名無し）
  def setSql_R_MainteServiceListOfSetubi(idname1, idname2 ,genesql_freesql)
    $Mlog.debug("R_MainteServiceList_model") {"setSql_R_MainteServiceListOfSetubi start"}                  # Logファイル Debug用

    requestInfo          = getJsonChunkById(@request_data, "records", idname1)
    sqlInfo              = getJsonChunkById(@sql_data, "sqls", idname2)

    w_検索指示ＮＯ       = requestInfo["record"]["検索指示ＮＯ"]["value"][0]
    w_検索業者名称       = requestInfo["record"]["検索業者名称"]["value"][0]
    w_検索契約ＮＯ       = requestInfo["record"]["検索契約ＮＯ"]["value"][0]
    w_検索顧客名称       = requestInfo["record"]["検索顧客名称"]["value"][0]
    w_検索指示日         = requestInfo["record"]["検索指示日"]["value"][0]
    w_検索作業予定日     = requestInfo["record"]["検索作業予定日"]["value"][0]
    w_検索作業実施日     = requestInfo["record"]["検索作業実施日"]["value"][0]
    w_検索作業完了フラグ = requestInfo["record"]["検索作業完了フラグ"]["value"][0]


    rep = ""

    # 検索指示ＮＯ
    if w_検索指示ＮＯ != ""
      rep = rep + " AND A.サービス指示ＮＯ = #{w_検索指示ＮＯ}"
    end

    # 検索業者名称
    if w_検索業者名称 != ""
      rep = rep + " AND D.名称 LIKE '%#{w_検索業者名称}%'"
    end

    # 検索契約ＮＯ
    if w_検索契約ＮＯ != ""
      rep = rep + " AND A.ref_契約ＮＯ = #{w_検索契約ＮＯ}"
    end

    # 検索顧客名称
    if w_検索顧客名称 != ""
      rep = rep + " AND F.名称 LIKE '%#{w_検索顧客名称}%'"
    end

    # 検索指示日
    if w_検索指示日 != ""
      rep = rep + " AND TO_CHAR(A.指示日, 'YYYYMMDD') = '#{w_検索指示日}'"
    end

    # 検索作業予定日
    if w_検索作業予定日 != ""
      rep = rep + " AND TO_CHAR(A.作業予定日, 'YYYYMMDD') = '#{w_検索作業予定日}'"
    end

    # 検索作業実施日
    if w_検索作業実施日 != ""
      rep = rep + " AND TO_CHAR(A.作業実施日, 'YYYYMMDD') = '#{w_検索作業実施日}'"
    end

    # 検索作業完了フラグ
    if w_検索作業完了フラグ == "未完了"
      rep = rep + " AND A.作業実施日 IS NULL"
    end

    # 検索作業完了フラグ
    if w_検索作業完了フラグ == "完了"
      rep = rep + " AND A.作業実施日 IS NOT NULL"
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

    $Mlog.debug("R_MainteServiceList_model") {"setSql_R_MainteServiceListOfSetubi end"}                    # Logファイル Debug用
    return "OK"
  end


end

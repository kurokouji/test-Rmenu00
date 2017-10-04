# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfBaseNameMainteOfModelMixin'


class R_MainteServiceHD_model
  include SetubiOfBaseNameMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("R_MainteServiceHD_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("R_MainteServiceHD_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("R_MainteServiceHD_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end


  # 契約ＮＯ行番号変更有りの判定（有り：OK　　無し：PASS）
  def is契約ＮＯ行番号変更有りOfR_MainteServiceHDOfSetubi()
    $Mlog.debug("R_MainteServiceHD_model") {"is契約ＮＯ行番号変更有りOfR_MainteServiceHDOfSetubi start"}

    requestRecord = getJsonChunkById(@request_data, "records", "header",                  "record")
    sqlRecord     = getJsonChunkById(@sql_data,     "sqls",    "header_select", "output", "record")
    status        = "PASS"
    
    if requestRecord["契約ＮＯ"]["value"][0] != sqlRecord["契約ＮＯ"]["value"][0]
      status = "OK"
    end

    if requestRecord["設備行番"]["value"][0] != sqlRecord["設備行番"]["value"][0]
      status = "OK"
    end

    $Mlog.debug("R_MainteServiceHD_model") {"is契約ＮＯ行番号変更有りOfR_MainteServiceHDOfSetubi end status = #{status}"}
    return status
  end


  # 契約ＮＯ行番号変更無しの判定（有り：PASS　　無し：OK）
  def is契約ＮＯ行番号変更無しOfR_MainteServiceHDOfSetubi()
    $Mlog.debug("R_MainteServiceHD_model") {"is契約ＮＯ行番号変更無しOfR_MainteServiceHDOfSetubi start"}

    requestRecord = getJsonChunkById(@request_data, "records", "header",                  "record")
    sqlRecord     = getJsonChunkById(@sql_data,     "sqls",    "header_select", "output", "record")
    status        = "PASS"
    
    if requestRecord["契約ＮＯ"]["value"][0] == sqlRecord["契約ＮＯ"]["value"][0]
      if requestRecord["設備行番"]["value"][0] == sqlRecord["設備行番"]["value"][0]
        status = "OK"
      end
    end

    $Mlog.debug("R_MainteServiceHD_model") {"is契約ＮＯ行番号変更無しOfR_MainteServiceHDOfSetubi end status = #{status}"}
    return status
  end


end

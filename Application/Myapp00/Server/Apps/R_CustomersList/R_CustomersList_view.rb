# coding: UTF-8

require 'RmenuConfig'                                                           # Rmenu環境設定クラス
require 'RmenuLoggerMixin'                                                      # Logファイル Debug用
require 'RmenuFilePathMixin'                                                    # セッション処理用
require 'Myapp00/Server/Modules/Myapp00OfMasterMainteOfViewMixin'

class R_CustomersList_view
  include RmenuLoggerMixin                                                      # Logファイル Debug用
  include RmenuFilePathMixin                                                    # Logファイル Debug用
  include Myapp00OfMasterMainteOfViewMixin

  def initialize(response_data, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Vlog.debug("R_CustomersList_view") {"initialize start"}                    # Logファイル Debug用

      @response_data  = response_data
      @sql_data       = sql_data
      @request_data   = request_data
      
      # initialize 終了ログを出力する
      $Vlog.debug("R_CustomersList_view") {"initialize normal end"}               # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Vlog.error("R_CustomersList_view") {"initialize exception: #{$!}"}         # Logファイル Debug用
      raise
    end
  end

  # CSVファイル作成
  def createCSVFile
    $Vlog.debug("R_CustomersList_model") {"createCSVFile start"}                  # Logファイル Debug用

    sqlInfo   = getJsonChunkById(@sql_data, "sqls", "csvCreate")
    sqlRecord = sqlInfo["output"]["record"]

    # 見出し出力
    data = ""
    max  = 0
    i    = 0
    sqlRecord.each do |name, value|
      if i == 0
        max = value["value"].length - 1
      else
        data << ","
      end
      data << name
      i += 1
    end
    data << "\n"
 
    # データ出力
    for i in 0..max
      j = 0
      sqlRecord.each do |name, value|
        if j != 0
          data << ","
        end
        data << value["value"][i]
        j += 1
      end
      data << "\n"
    end

    # ファイル出力
    tempTime   = Time.now
    tempNow    = tempTime.strftime("%Y%m%d%H%M%S")
    csvDir     = $Rconfig['apps_path'] + "/" + @response_data["html"].gsub(/\/Json\//, '/DownLoad/')
    csvNewFile = csvDir + "/" + "data" + "#{tempNow}.csv"

    writeCodeFileWithBom(csvNewFile, data, "UTF-8")

    # ファイル情報設定
    csvPath       = @response_data["html"].gsub(/\/Json\//, '/DownLoad/')
    filename = "data" + "#{tempNow}.csv"

    responseInfo  = getJsonChunkById(@response_data, "records", "csvCreate")
    responseInfo["record"]["downloadfile"]["value"][0] = csvPath + "/" + filename

    $Vlog.debug("R_CustomersList_model") {"createCSVFile end"}                    # Logファイル Debug用
    return "OK"
  end

end

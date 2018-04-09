# coding: UTF-8

require 'rubyXL'
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
    $Vlog.debug("R_CustomersList_view") {"createCSVFile start"}                  # Logファイル Debug用

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

    $Vlog.debug("R_CustomersList_view") {"createCSVFile end"}                    # Logファイル Debug用
    return "OK"
  end

  # エクセルを作成する
  def createExcel()
    $Vlog.debug("R_CustomersList_view") {"createExcel start"}
    
    requestRecord      = getJsonChunkById(@request_data,  "records", "header",                         "record")
    custmerListRecord   = getJsonChunkById(@sql_data,      "sqls",    "csvCreate",     "output", "record")
    
    
    # テンプレートファイル名設定
    excelFile = $Rconfig['apps_path'] + "/" + @response_data["html"].gsub(/\/Json\//, '/PdfTemplate/') + "/印刷用テンプレート.xlsx"

    # エクセルテンプレートを読み込む
    workbook  = RubyXL::Parser.parse(excelFile)

    # 新規作成の場合
#    workbook = RubyXL::Workbook.new

#    worksheet = workbook["得意先一覧"]

#    worksheet.add_cell(4, 1, 'B5セル')
    
    
    # 得意先一覧を作成する
    createCustomerList(workbook, custmerListRecord)

    # 当日日付とカレント時刻を設定する
    w_date      = Date.today
    w_time      = Time.now
    yyyymmdd    = w_date.strftime("%Y%m%d")
    hhmmss      = w_time.strftime("%H%M%S")

    # ディレクトリが無ければ作成する（有れば何もしない）
    downloadDir = $Rconfig['apps_path'] + "/Myapp00/DownLoad/Apps/R_CustomersList"
    newDir      = $Rconfig['apps_path'] + "/Myapp00/DownLoad/Apps/R_CustomersList" + "/d" + yyyymmdd
    createDir(newDir)
    
    # 当日よりも古いディレクトリーを削除する
    deleteDir(downloadDir, newDir)

    
    # エクセルファイル出力
    excelFile = newDir + "/" + "data" + "#{hhmmss}.xlsx"
    workbook.write(excelFile)


    # エクセルファイル情報設定
    excelPath    = "Myapp00/DownLoad/Apps/R_CustomersList" + "/d" + yyyymmdd + "/"
    filename   = "data" + "#{hhmmss}.xlsx"

    responseInfo  = getJsonChunkById(@response_data, "records", "header")
    responseInfo["record"]["downloadfile"]["value"][0] = excelPath + "/" + filename

    $Vlog.debug("R_CustomersList_view") {"createExcel normal end"}
    return "OK"
  end
  
  # エンティティ一覧を作成する
  def createCustomerList(workbook, entityListRecord)
    $Vlog.debug("R_CustomersList_view") {"createCustomerList start"}
    
    worksheet = workbook["得意先一覧"]
    maxSize   = entityListRecord["得意先ＩＤ"]["value"].length
    
    # １２行を超える時、行を追加する
    if maxSize > 12
      addSize = maxSize - 12
      for j in 1..addSize do
        worksheet.insert_row(13)
      end
    end
    
    # データセットの開始行とデータの終了行を設定する
    maxSize = maxSize - 1
    
    for num in 0..maxSize do
      row = num + 1
      
      worksheet[row][0].change_contents(row,                                                  worksheet[row][0].formula)
      worksheet[row][1].change_contents(entityListRecord["得意先ＩＤ"]["value"][num],       worksheet[row][1].formula)
      worksheet[row][2].change_contents(entityListRecord["得意先名称"]["value"][num],         worksheet[row][2].formula)
      worksheet[row][3].change_contents(entityListRecord["郵便番号"]["value"][num],       worksheet[row][3].formula)
      worksheet[row][4].change_contents(entityListRecord["営業担当者ＩＤ"]["value"][num],         worksheet[row][4].formula)
      worksheet[row][5].change_contents(entityListRecord["表示順"]["value"][num], worksheet[row][5].formula)
    
    end
    

    $Vlog.debug("R_CustomersList_view") {"createCustomerList end"}
  end
  
end

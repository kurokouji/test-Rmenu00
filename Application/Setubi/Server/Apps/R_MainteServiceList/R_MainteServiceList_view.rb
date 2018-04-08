# coding: UTF-8

require 'RmenuLoggerMixin'                                                      # Logファイル Debug用
require 'RmenuFilePathMixin'                                                    # セッション処理用
require 'Setubi/Server/Modules/SetubiOfMasterMainteOfViewMixin'

class R_MainteServiceList_view
  include RmenuLoggerMixin                                                      # Logファイル Debug用
  include RmenuFilePathMixin                                                    # Logファイル Debug用
  include SetubiOfMasterMainteOfViewMixin

  def initialize(response_data, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Vlog.debug("R_MainteServiceList_view") {"initialize start"}                    # Logファイル Debug用

      @response_data  = response_data
      @sql_data       = sql_data
      @request_data   = request_data
      
      # initialize 終了ログを出力する
      $Vlog.debug("R_MainteServiceList_view") {"initialize normal end"}               # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Vlog.error("R_MainteServiceList_view") {"initialize exception: #{$!}"}         # Logファイル Debug用
      raise
    end
  end
  
  # 保守契約一覧表　編集処理
  def edit保守サービス指示一覧表OfR_MainteServiceListOfSetubi()
    $Vlog.debug("R_MainteServiceList_view") {"edit保守サービス指示一覧表OfR_MainteServiceListOfSetubi start"}

    responseRecord = getJsonChunkById(@response_data, "records", "detail",           "record")
    sqlRecord      = getJsonChunkById(@sql_data,      "sqls",    "detail", "output", "record")

    maxSize = sqlRecord["契約ＮＯ"]["value"].length - 1
    w_指示ＮＯ = ""
    w_作業区分 = ""
    
    for i in 0..maxSize do
      if w_指示ＮＯ != sqlRecord["指示ＮＯ"]["value"][i]
        edit保守サービス指示一覧表_指示ＮＯ(sqlRecord, responseRecord, i)
        
        w_指示ＮＯ = sqlRecord["指示ＮＯ"]["value"][i]
        w_作業区分 = sqlRecord["作業区分"]["value"][i]
        
        next
      end
      
      if w_作業区分 != sqlRecord["作業区分"]["value"][i]
        edit保守サービス指示一覧表_作業区分(sqlRecord, responseRecord, i)
        
        w_作業区分 = sqlRecord["作業区分"]["value"][i]
        
        next
      end
      
      edit保守サービス指示一覧表_諸掛行番(sqlRecord, responseRecord, i)
    end

    $Vlog.debug("R_MainteServiceList_view") {"edit保守サービス指示一覧表OfR_MainteServiceListOfSetubi end"}
    return "OK"
  end

  # 保守サービス指示一覧表　指示ＮＯ　編集処理
  def edit保守サービス指示一覧表_指示ＮＯ(sqlRecord, responseRecord, i)
    $Vlog.debug("R_MainteServiceList_view") {"edit保守サービス指示一覧表_指示ＮＯ start"}

    responseRecord["指示ＮＯ"]["value"][i]       = sqlRecord["指示ＮＯ"]["value"][i]
    responseRecord["作業区分"]["value"][i]       = sqlRecord["作業区分"]["value"][i]

    responseRecord["表示用指示ＮＯ"]["value"][i] = sqlRecord["表示用指示ＮＯ"]["value"][i]
    responseRecord["業者名称"]["value"][i]       = sqlRecord["業者名称"]["value"][i]
    responseRecord["契約ＮＯ"]["value"][i]       = sqlRecord["契約ＮＯ"]["value"][i]
    responseRecord["顧客名称"]["value"][i]       = sqlRecord["顧客名称"]["value"][i]
    responseRecord["設備行番"]["value"][i]       = sqlRecord["設備行番"]["value"][i]
    responseRecord["設備タイプ名称"]["value"][i] = sqlRecord["設備タイプ名称"]["value"][i]
    responseRecord["設備名称"]["value"][i]       = sqlRecord["設備名称"]["value"][i]
    responseRecord["契約単価"]["value"][i]       = sqlRecord["契約単価"]["value"][i]
    responseRecord["指示日"]["value"][i]         = sqlRecord["指示日"]["value"][i]
    responseRecord["作業予定日"]["value"][i]     = sqlRecord["作業予定日"]["value"][i]
    responseRecord["作業実施日"]["value"][i]     = sqlRecord["作業実施日"]["value"][i]
    responseRecord["表示用作業区分"]["value"][i] = sqlRecord["表示用作業区分"]["value"][i]
    responseRecord["作業件数"]["value"][i]       = sqlRecord["作業件数"]["value"][i]
    responseRecord["作業単価"]["value"][i]       = sqlRecord["作業単価"]["value"][i]
    responseRecord["諸掛行番"]["value"][i]       = sqlRecord["諸掛行番"]["value"][i]
    responseRecord["単価"]["value"][i]           = sqlRecord["単価"]["value"][i]
    responseRecord["数量"]["value"][i]           = sqlRecord["数量"]["value"][i]
    responseRecord["請求額"]["value"][i]         = sqlRecord["請求額"]["value"][i]
    responseRecord["摘要"]["value"][i]           = sqlRecord["摘要"]["value"][i]

    $Vlog.debug("R_MainteServiceList_view") {"edit保守サービス指示一覧表_指示ＮＯ end"}
    return "OK"
  end

  # 保守サービス指示一覧表　作業区分　編集処理
  def edit保守サービス指示一覧表_作業区分(sqlRecord, responseRecord, i)
    $Vlog.debug("R_MainteServiceList_view") {"edit保守サービス指示一覧表_作業区分 start"}

    responseRecord["指示ＮＯ"]["value"][i]       = sqlRecord["指示ＮＯ"]["value"][i]
    responseRecord["作業区分"]["value"][i]       = sqlRecord["作業区分"]["value"][i]

    responseRecord["表示用指示ＮＯ"]["value"][i] = ""
    responseRecord["業者名称"]["value"][i]       = ""
    responseRecord["契約ＮＯ"]["value"][i]       = ""
    responseRecord["顧客名称"]["value"][i]       = ""
    responseRecord["設備行番"]["value"][i]       = ""
    responseRecord["設備タイプ名称"]["value"][i] = ""
    responseRecord["設備名称"]["value"][i]       = ""
    responseRecord["契約単価"]["value"][i]       = ""
    responseRecord["指示日"]["value"][i]         = ""
    responseRecord["作業予定日"]["value"][i]     = ""
    responseRecord["作業実施日"]["value"][i]     = ""
    responseRecord["表示用作業区分"]["value"][i] = sqlRecord["表示用作業区分"]["value"][i]
    responseRecord["作業件数"]["value"][i]       = sqlRecord["作業件数"]["value"][i]
    responseRecord["作業単価"]["value"][i]       = sqlRecord["作業単価"]["value"][i]
    responseRecord["諸掛行番"]["value"][i]       = sqlRecord["諸掛行番"]["value"][i]
    responseRecord["単価"]["value"][i]           = sqlRecord["単価"]["value"][i]
    responseRecord["数量"]["value"][i]           = sqlRecord["数量"]["value"][i]
    responseRecord["請求額"]["value"][i]         = sqlRecord["請求額"]["value"][i]
    responseRecord["摘要"]["value"][i]           = sqlRecord["摘要"]["value"][i]

    $Vlog.debug("R_MainteServiceList_view") {"edit保守サービス指示一覧表_作業区分 end"}
    return "OK"
  end

  # 保守サービス指示一覧表　諸掛行番　編集処理
  def edit保守サービス指示一覧表_諸掛行番(sqlRecord, responseRecord, i)
    $Vlog.debug("R_MainteServiceList_view") {"edit保守サービス指示一覧表_諸掛行番 start"}

    responseRecord["指示ＮＯ"]["value"][i]       = sqlRecord["指示ＮＯ"]["value"][i]
    responseRecord["作業区分"]["value"][i]       = sqlRecord["作業区分"]["value"][i]

    responseRecord["表示用指示ＮＯ"]["value"][i] = ""
    responseRecord["業者名称"]["value"][i]       = ""
    responseRecord["契約ＮＯ"]["value"][i]       = ""
    responseRecord["顧客名称"]["value"][i]       = ""
    responseRecord["設備行番"]["value"][i]       = ""
    responseRecord["設備タイプ名称"]["value"][i] = ""
    responseRecord["設備名称"]["value"][i]       = ""
    responseRecord["契約単価"]["value"][i]       = ""
    responseRecord["指示日"]["value"][i]         = ""
    responseRecord["作業予定日"]["value"][i]     = ""
    responseRecord["作業実施日"]["value"][i]     = ""
    responseRecord["表示用作業区分"]["value"][i] = ""
    responseRecord["作業件数"]["value"][i]       = ""
    responseRecord["作業単価"]["value"][i]       = ""
    responseRecord["諸掛行番"]["value"][i]       = sqlRecord["諸掛行番"]["value"][i]
    responseRecord["単価"]["value"][i]           = sqlRecord["単価"]["value"][i]
    responseRecord["数量"]["value"][i]           = sqlRecord["数量"]["value"][i]
    responseRecord["請求額"]["value"][i]         = sqlRecord["請求額"]["value"][i]
    responseRecord["摘要"]["value"][i]           = sqlRecord["摘要"]["value"][i]

    $Vlog.debug("R_MainteServiceList_view") {"edit保守サービス指示一覧表_諸掛行番 end"}
    return "OK"
  end

end

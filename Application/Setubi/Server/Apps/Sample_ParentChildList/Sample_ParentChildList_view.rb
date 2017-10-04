# coding: UTF-8

require 'RmenuLoggerMixin'                                                      # Logファイル Debug用
require 'RmenuFilePathMixin'                                                    # セッション処理用
require 'Setubi/Server/Modules/SetubiOfMasterMainteOfViewMixin'

class Sample_ParentChildList_view
  include RmenuLoggerMixin                                                      # Logファイル Debug用
  include RmenuFilePathMixin                                                    # Logファイル Debug用
  include SetubiOfMasterMainteOfViewMixin

  def initialize(response_data, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Vlog.debug("Sample_ParentChildList_view") {"initialize start"}                    # Logファイル Debug用

      @response_data  = response_data
      @sql_data       = sql_data
      @request_data   = request_data
      
      # initialize 終了ログを出力する
      $Vlog.debug("Sample_ParentChildList_view") {"initialize normal end"}               # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Vlog.error("Sample_ParentChildList_view") {"initialize exception: #{$!}"}         # Logファイル Debug用
      raise
    end
  end
  
  # 保守契約一覧表　編集処理
  def editサンプル親子一覧リストOfSample_ParentChildListOfSetubi()
    $Mlog.debug("Sample_ParentChildList_view") {"editサンプル親子一覧リストOfSample_ParentChildListOfSetubi start"}

    responseRecord = getJsonChunkById(@response_data, "records", "detail",           "record")
    sqlRecord      = getJsonChunkById(@sql_data,      "sqls",    "detail", "output", "record")

    maxSize = sqlRecord["サンプル_ヘッダＩＤ"]["value"].length - 1
    w_サンプル_ヘッダＩＤ = ""
    
    for i in 0..maxSize do
      if w_サンプル_ヘッダＩＤ != sqlRecord["サンプル_ヘッダＩＤ"]["value"][i]
        editサンプル親子一覧リスト_親子(sqlRecord, responseRecord, i)
        
        w_サンプル_ヘッダＩＤ = sqlRecord["サンプル_ヘッダＩＤ"]["value"][i]
        next
      end
      
      editサンプル親子一覧リスト_子(sqlRecord, responseRecord, i)
    end

    $Mlog.debug("Sample_ParentChildList_view") {"editサンプル親子一覧リストOfSample_ParentChildListOfSetubi end"}
    return "OK"
  end

  # 保守サービス指示一覧表　指示ＮＯ　編集処理
  def editサンプル親子一覧リスト_親子(sqlRecord, responseRecord, i)
    $Mlog.debug("Sample_ParentChildList_view") {"editサンプル親子一覧リスト_親子 start"}

    responseRecord["サンプル_ヘッダＩＤ"]["value"][i]       = sqlRecord["サンプル_ヘッダＩＤ"]["value"][i]

    responseRecord["表示サンプル_ヘッダＩＤ"]["value"][i] = sqlRecord["表示サンプル_ヘッダＩＤ"]["value"][i]
    responseRecord["サンプル_ヘッダ項目１"]["value"][i]   = sqlRecord["サンプル_ヘッダ項目１"]["value"][i]
    responseRecord["サンプル_ヘッダ項目２"]["value"][i]   = sqlRecord["サンプル_ヘッダ項目２"]["value"][i]
    responseRecord["サンプル_ヘッダ項目３"]["value"][i]   = sqlRecord["サンプル_ヘッダ項目３"]["value"][i]
    responseRecord["サンプル_ヘッダ項目４"]["value"][i]   = sqlRecord["サンプル_ヘッダ項目４"]["value"][i]
    responseRecord["サンプル_ヘッダ項目５"]["value"][i]   = sqlRecord["サンプル_ヘッダ項目５"]["value"][i]
    responseRecord["サンプル項目１"]["value"][i]          = sqlRecord["サンプル項目１"]["value"][i]
    responseRecord["サンプル_明細行番号"]["value"][i]     = sqlRecord["サンプル_明細行番号"]["value"][i]
    responseRecord["サンプル_明細項目１"]["value"][i]     = sqlRecord["サンプル_明細項目１"]["value"][i]
    responseRecord["サンプル_明細項目２"]["value"][i]     = sqlRecord["サンプル_明細項目２"]["value"][i]
    responseRecord["サンプル_明細項目３"]["value"][i]     = sqlRecord["サンプル_明細項目３"]["value"][i]
    responseRecord["サンプル_明細数量"]["value"][i]       = sqlRecord["サンプル_明細数量"]["value"][i]
    responseRecord["サンプル_明細単価"]["value"][i]       = sqlRecord["サンプル_明細単価"]["value"][i]
    responseRecord["サンプル_明細金額"]["value"][i]       = sqlRecord["サンプル_明細金額"]["value"][i]
    responseRecord["サンプル区分名称"]["value"][i]        = sqlRecord["サンプル区分名称"]["value"][i]

    $Mlog.debug("Sample_ParentChildList_view") {"editサンプル親子一覧リスト_親子 end"}
    return "OK"
  end

  # 保守サービス指示一覧表　作業区分　編集処理
  def editサンプル親子一覧リスト_子(sqlRecord, responseRecord, i)
    $Mlog.debug("Sample_ParentChildList_view") {"editサンプル親子一覧リスト_子 start"}

    responseRecord["サンプル_ヘッダＩＤ"]["value"][i]       = sqlRecord["サンプル_ヘッダＩＤ"]["value"][i]

    responseRecord["表示サンプル_ヘッダＩＤ"]["value"][i] = ""
    responseRecord["サンプル_ヘッダ項目１"]["value"][i]   = ""
    responseRecord["サンプル_ヘッダ項目２"]["value"][i]   = ""
    responseRecord["サンプル_ヘッダ項目３"]["value"][i]   = ""
    responseRecord["サンプル_ヘッダ項目４"]["value"][i]   = ""
    responseRecord["サンプル_ヘッダ項目５"]["value"][i]   = ""
    responseRecord["サンプル項目１"]["value"][i]          = ""
    responseRecord["サンプル_明細行番号"]["value"][i]     = sqlRecord["サンプル_明細行番号"]["value"][i]
    responseRecord["サンプル_明細項目１"]["value"][i]     = sqlRecord["サンプル_明細項目１"]["value"][i]
    responseRecord["サンプル_明細項目２"]["value"][i]     = sqlRecord["サンプル_明細項目２"]["value"][i]
    responseRecord["サンプル_明細項目３"]["value"][i]     = sqlRecord["サンプル_明細項目３"]["value"][i]
    responseRecord["サンプル_明細数量"]["value"][i]       = sqlRecord["サンプル_明細数量"]["value"][i]
    responseRecord["サンプル_明細単価"]["value"][i]       = sqlRecord["サンプル_明細単価"]["value"][i]
    responseRecord["サンプル_明細金額"]["value"][i]       = sqlRecord["サンプル_明細金額"]["value"][i]
    responseRecord["サンプル区分名称"]["value"][i]        = sqlRecord["サンプル区分名称"]["value"][i]

    $Mlog.debug("Sample_ParentChildList_view") {"editサンプル親子一覧リスト_子 end"}
    return "OK"
  end

end

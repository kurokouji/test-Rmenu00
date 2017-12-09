# coding: UTF-8

require 'RmenuLoggerMixin'                                                      # Logファイル Debug用
require 'RmenuFilePathMixin'                                                    # セッション処理用
require 'Myapp00/Server/Modules/Myapp00OfMasterMainteOfViewMixin'

class T_Sample_ParentChildList_view
  include RmenuLoggerMixin                                                      # Logファイル Debug用
  include RmenuFilePathMixin                                                    # Logファイル Debug用
  include Myapp00OfMasterMainteOfViewMixin

  def initialize(response_data, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Vlog.debug("T_Sample_ParentChildList_view") {"initialize start"}                    # Logファイル Debug用

      @response_data  = response_data
      @sql_data       = sql_data
      @request_data   = request_data
      
      # initialize 終了ログを出力する
      $Vlog.debug("T_Sample_ParentChildList_view") {"initialize normal end"}               # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Vlog.error("T_Sample_ParentChildList_view") {"initialize exception: #{$!}"}         # Logファイル Debug用
      raise
    end
  end
  
  # 保守契約一覧表　編集処理
  def editサンプル親子一覧リストOfT_Sample_ParentChildListOfMyapp00()
    $Mlog.debug("T_Sample_ParentChildList_view") {"editサンプル親子一覧リストOfT_Sample_ParentChildListOfMyapp00 start"}

    responseRecord = getJsonChunkById(@response_data, "records", "detail",           "record")
    sqlRecord      = getJsonChunkById(@sql_data,      "sqls",    "detail", "output", "record")

    maxSize = sqlRecord["Ｔサンプル_ヘッダＩＤ"]["value"].length - 1
    w_Ｔサンプル_ヘッダＩＤ = ""
    
    for i in 0..maxSize do
      if w_Ｔサンプル_ヘッダＩＤ != sqlRecord["Ｔサンプル_ヘッダＩＤ"]["value"][i]
        editサンプル親子一覧リスト_親子(sqlRecord, responseRecord, i)
        
        w_Ｔサンプル_ヘッダＩＤ = sqlRecord["Ｔサンプル_ヘッダＩＤ"]["value"][i]
        next
      end
      
      editサンプル親子一覧リスト_子(sqlRecord, responseRecord, i)
    end

    $Mlog.debug("T_Sample_ParentChildList_view") {"editサンプル親子一覧リストOfT_Sample_ParentChildListOfMyapp00 end"}
    return "OK"
  end

  # 保守サービス指示一覧表　指示ＮＯ　編集処理
  def editサンプル親子一覧リスト_親子(sqlRecord, responseRecord, i)
    $Mlog.debug("T_Sample_ParentChildList_view") {"editサンプル親子一覧リスト_親子 start"}

    responseRecord["Ｔサンプル_ヘッダＩＤ"]["value"][i]       = sqlRecord["Ｔサンプル_ヘッダＩＤ"]["value"][i]

    responseRecord["表示Ｔサンプル_ヘッダＩＤ"]["value"][i] = sqlRecord["表示Ｔサンプル_ヘッダＩＤ"]["value"][i]
    responseRecord["Ｔサンプル_ヘッダ項目０１"]["value"][i]   = sqlRecord["Ｔサンプル_ヘッダ項目０１"]["value"][i]
    responseRecord["Ｔサンプル_ヘッダ項目０２"]["value"][i]   = sqlRecord["Ｔサンプル_ヘッダ項目０２"]["value"][i]
    responseRecord["Ｔサンプル_ヘッダ項目０３"]["value"][i]   = sqlRecord["Ｔサンプル_ヘッダ項目０３"]["value"][i]
    responseRecord["Ｔサンプル_ヘッダ項目０４"]["value"][i]   = sqlRecord["Ｔサンプル_ヘッダ項目０４"]["value"][i]
    responseRecord["Ｔサンプル_ヘッダ項目０５"]["value"][i]   = sqlRecord["Ｔサンプル_ヘッダ項目０５"]["value"][i]
    responseRecord["Ｔサンプル_マスタ項目０１"]["value"][i]          = sqlRecord["Ｔサンプル_マスタ項目０１"]["value"][i]
    responseRecord["Ｔサンプル_明細行番号"]["value"][i]     = sqlRecord["Ｔサンプル_明細行番号"]["value"][i]
    responseRecord["Ｔサンプル_明細項目０１"]["value"][i]     = sqlRecord["Ｔサンプル_明細項目０１"]["value"][i]
    responseRecord["Ｔサンプル_明細項目０２"]["value"][i]     = sqlRecord["Ｔサンプル_明細項目０２"]["value"][i]
    responseRecord["Ｔサンプル_明細項目０３"]["value"][i]     = sqlRecord["Ｔサンプル_明細項目０３"]["value"][i]
    responseRecord["Ｔサンプル_区分名称"]["value"][i]        = sqlRecord["Ｔサンプル_区分名称"]["value"][i]

    $Mlog.debug("T_Sample_ParentChildList_view") {"editサンプル親子一覧リスト_親子 end"}
    return "OK"
  end

  # 保守サービス指示一覧表　作業区分　編集処理
  def editサンプル親子一覧リスト_子(sqlRecord, responseRecord, i)
    $Mlog.debug("T_Sample_ParentChildList_view") {"editサンプル親子一覧リスト_子 start"}

    responseRecord["Ｔサンプル_ヘッダＩＤ"]["value"][i]       = sqlRecord["Ｔサンプル_ヘッダＩＤ"]["value"][i]

    responseRecord["表示Ｔサンプル_ヘッダＩＤ"]["value"][i] = ""
    responseRecord["Ｔサンプル_ヘッダ項目０１"]["value"][i]   = ""
    responseRecord["Ｔサンプル_ヘッダ項目０２"]["value"][i]   = ""
    responseRecord["Ｔサンプル_ヘッダ項目０３"]["value"][i]   = ""
    responseRecord["Ｔサンプル_ヘッダ項目０４"]["value"][i]   = ""
    responseRecord["Ｔサンプル_ヘッダ項目０５"]["value"][i]   = ""
    responseRecord["Ｔサンプル_マスタ項目０１"]["value"][i]          = ""
    responseRecord["Ｔサンプル_明細行番号"]["value"][i]     = sqlRecord["Ｔサンプル_明細行番号"]["value"][i]
    responseRecord["Ｔサンプル_明細項目０１"]["value"][i]     = sqlRecord["Ｔサンプル_明細項目０１"]["value"][i]
    responseRecord["Ｔサンプル_明細項目０２"]["value"][i]     = sqlRecord["Ｔサンプル_明細項目０２"]["value"][i]
    responseRecord["Ｔサンプル_明細項目０３"]["value"][i]     = sqlRecord["Ｔサンプル_明細項目０３"]["value"][i]
    responseRecord["Ｔサンプル_区分名称"]["value"][i]        = sqlRecord["Ｔサンプル_区分名称"]["value"][i]

    $Mlog.debug("T_Sample_ParentChildList_view") {"editサンプル親子一覧リスト_子 end"}
    return "OK"
  end

end

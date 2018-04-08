# coding: UTF-8

require 'RmenuLoggerMixin'                                                      # Logファイル Debug用
require 'RmenuFilePathMixin'                                                    # セッション処理用
require 'Setubi/Server/Modules/SetubiOfMasterMainteOfViewMixin'

class R_MainteContractSelection_view
  include RmenuLoggerMixin                                                      # Logファイル Debug用
  include RmenuFilePathMixin                                                    # Logファイル Debug用
  include SetubiOfMasterMainteOfViewMixin

  def initialize(response_data, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Vlog.debug("R_MainteContractSelection_view") {"initialize start"}                    # Logファイル Debug用

      @response_data  = response_data
      @sql_data       = sql_data
      @request_data   = request_data
      
      # initialize 終了ログを出力する
      $Vlog.debug("R_MainteContractSelection_view") {"initialize normal end"}               # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Vlog.error("R_MainteContractSelection_view") {"initialize exception: #{$!}"}         # Logファイル Debug用
      raise
    end
  end

  
  # 保守契約選択　編集処理
  def edit保守契約選択OfR_MainteContractSelectionOfSetubi()
    $Vlog.debug("R_MainteContractSelection_view") {"edit保守契約選択OfR_MainteContractSelectionOfSetubi start"}

    responseRecord = getJsonChunkById(@response_data, "records", "detail",           "record")
    sqlRecord      = getJsonChunkById(@sql_data,      "sqls",    "detail", "output", "record")

    maxSize = sqlRecord["契約ＮＯ"]["value"].length - 1
    w_契約ＮＯ = ""
    w_設備行番 = ""
    
    for i in 0..maxSize do
      if w_契約ＮＯ != sqlRecord["契約ＮＯ"]["value"][i]
        edit保守契約選択_契約ＮＯ(sqlRecord, responseRecord, i)
        
        w_契約ＮＯ = sqlRecord["契約ＮＯ"]["value"][i]
        w_設備行番 = sqlRecord["設備行番"]["value"][i]
        
        next
      end
      
      if w_設備行番 != sqlRecord["設備行番"]["value"][i]
        edit保守契約選択_設備行番(sqlRecord, responseRecord, i)
        
        w_設備行番 = sqlRecord["設備行番"]["value"][i]
        
        next
      end
      
      edit保守契約選択_作業区分(sqlRecord, responseRecord, i)
    end

    $Vlog.debug("R_MainteContractSelection_view") {"edit保守契約選択OfR_MainteContractSelectionOfSetubi end"}
    return "OK"
  end

  # 保守契約選択　契約ＮＯ　編集処理
  def edit保守契約選択_契約ＮＯ(sqlRecord, responseRecord, i)
    $Vlog.debug("R_MainteContractSelection_view") {"edit保守契約選択_契約ＮＯ start"}

    responseRecord["契約ＮＯ"]["value"][i]       = sqlRecord["契約ＮＯ"]["value"][i]
    responseRecord["設備行番"]["value"][i]       = sqlRecord["設備行番"]["value"][i]
    responseRecord["顧客ＩＤ"]["value"][i]       = sqlRecord["顧客ＩＤ"]["value"][i]
    responseRecord["設備タイプ"]["value"][i]     = sqlRecord["設備タイプ"]["value"][i]
    responseRecord["作業区分"]["value"][i]       = sqlRecord["作業区分"]["value"][i]

    responseRecord["表示用契約ＮＯ"]["value"][i] = sqlRecord["表示用契約ＮＯ"]["value"][i]
    responseRecord["顧客名称"]["value"][i]       = sqlRecord["顧客名称"]["value"][i]
    responseRecord["表示用設備行番"]["value"][i] = sqlRecord["表示用設備行番"]["value"][i]
    responseRecord["設備タイプ名称"]["value"][i] = sqlRecord["設備タイプ名称"]["value"][i]
    responseRecord["設備名称"]["value"][i]       = sqlRecord["設備名称"]["value"][i]
    responseRecord["契約単価"]["value"][i]       = sqlRecord["契約単価"]["value"][i]
    responseRecord["標準業者名称"]["value"][i]   = sqlRecord["標準業者名称"]["value"][i]
    responseRecord["表示用作業区分"]["value"][i] = sqlRecord["表示用作業区分"]["value"][i]
    responseRecord["作業区分摘要"]["value"][i]   = sqlRecord["作業区分摘要"]["value"][i]
    responseRecord["インターバル"]["value"][i]   = sqlRecord["インターバル"]["value"][i]

    $Vlog.debug("R_MainteContractSelection_view") {"edit保守契約選択_契約ＮＯ end"}
    return "OK"
  end

  # 保守契約選択　設備行番　編集処理
  def edit保守契約選択_設備行番(sqlRecord, responseRecord, i)
    $Vlog.debug("R_MainteContractSelection_view") {"edit保守契約選択_設備行番 start"}

    responseRecord["契約ＮＯ"]["value"][i]       = sqlRecord["契約ＮＯ"]["value"][i]
    responseRecord["設備行番"]["value"][i]       = sqlRecord["設備行番"]["value"][i]
    responseRecord["顧客ＩＤ"]["value"][i]       = sqlRecord["顧客ＩＤ"]["value"][i]
    responseRecord["設備タイプ"]["value"][i]     = sqlRecord["設備タイプ"]["value"][i]
    responseRecord["作業区分"]["value"][i]       = sqlRecord["作業区分"]["value"][i]

    responseRecord["表示用契約ＮＯ"]["value"][i] = ""
    responseRecord["顧客名称"]["value"][i]       = ""
    responseRecord["表示用設備行番"]["value"][i] = sqlRecord["表示用設備行番"]["value"][i]
    responseRecord["設備タイプ名称"]["value"][i] = sqlRecord["設備タイプ名称"]["value"][i]
    responseRecord["設備名称"]["value"][i]       = sqlRecord["設備名称"]["value"][i]
    responseRecord["契約単価"]["value"][i]       = sqlRecord["契約単価"]["value"][i]
    responseRecord["標準業者名称"]["value"][i]   = sqlRecord["標準業者名称"]["value"][i]
    responseRecord["表示用作業区分"]["value"][i] = sqlRecord["表示用作業区分"]["value"][i]
    responseRecord["作業区分摘要"]["value"][i]   = sqlRecord["作業区分摘要"]["value"][i]
    responseRecord["インターバル"]["value"][i]   = sqlRecord["インターバル"]["value"][i]

    $Vlog.debug("R_MainteContractSelection_view") {"edit保守契約選択_設備行番 end"}
    return "OK"
  end

  # 保守契約選択　作業区分　編集処理
  def edit保守契約選択_作業区分(sqlRecord, responseRecord, i)
    $Vlog.debug("R_MainteContractSelection_view") {"edit保守契約選択_作業区分 start"}

    responseRecord["契約ＮＯ"]["value"][i]       = sqlRecord["契約ＮＯ"]["value"][i]
    responseRecord["設備行番"]["value"][i]       = sqlRecord["設備行番"]["value"][i]
    responseRecord["顧客ＩＤ"]["value"][i]       = sqlRecord["顧客ＩＤ"]["value"][i]
    responseRecord["設備タイプ"]["value"][i]     = sqlRecord["設備タイプ"]["value"][i]
    responseRecord["作業区分"]["value"][i]       = sqlRecord["作業区分"]["value"][i]

    responseRecord["表示用契約ＮＯ"]["value"][i] = ""
    responseRecord["顧客名称"]["value"][i]       = ""
    responseRecord["表示用設備行番"]["value"][i] = ""
    responseRecord["設備タイプ名称"]["value"][i] = ""
    responseRecord["設備名称"]["value"][i]       = ""
    responseRecord["契約単価"]["value"][i]       = ""
    responseRecord["標準業者名称"]["value"][i]   = ""
    responseRecord["表示用作業区分"]["value"][i] = sqlRecord["表示用作業区分"]["value"][i]
    responseRecord["作業区分摘要"]["value"][i]   = sqlRecord["作業区分摘要"]["value"][i]
    responseRecord["インターバル"]["value"][i]   = sqlRecord["インターバル"]["value"][i]

    $Vlog.debug("R_MainteContractSelection_view") {"edit保守契約選択_作業区分 end"}
    return "OK"
  end

end

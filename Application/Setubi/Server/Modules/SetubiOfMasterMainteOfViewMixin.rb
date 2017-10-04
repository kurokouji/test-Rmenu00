# coding: UTF-8

require 'RmenuLoggerMixin'                                                      # Logファイル Debug用
require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する

module SetubiOfMasterMainteOfViewMixin
  include RmenuLoggerMixin                                                      # Logファイル Debug用
  include RmenuJsonMixin

  # 総件数とページ当りの行数を使って、総ページ数を計算する
  def getMaxPageCountOfSetubi(idName)
    $Vlog.debug("SetubiOfMasterMainteOfViewMixin") {"getMaxPageCountOfSetubi start"}                 # Logファイル Debug用

    responseRecord = getJsonChunkById(@response_data, "records", idName)
    page_line      = responseRecord["record"]["ページライン数"]["value"][0].to_i
    total_count    = responseRecord["record"]["トータル件数"]["value"][0].to_i
    if total_count == 0
      max_page      = 1
    else
      max_page      = ((total_count + (page_line - 1)) / page_line).truncate
    end
    
    responseRecord["record"]["最大ページ"]["value"][0] = max_page
    
    $Vlog.debug("SetubiOfMasterMainteOfViewMixin") {"getMaxPageCountOfSetubi end"}                   # Logファイル Debug用
    return "OK"
  end
end

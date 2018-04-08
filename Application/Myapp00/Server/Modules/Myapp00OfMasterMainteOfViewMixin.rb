# coding: UTF-8

require 'RmenuLoggerMixin'                                                      # Logファイル Debug用
require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する

module Myapp00OfMasterMainteOfViewMixin
  include RmenuLoggerMixin                                                      # Logファイル Debug用
  include RmenuJsonMixin

  # 総件数とページ当りの行数を使って、総ページ数を計算する
  def getMaxPageCountOfMyapp00(idName)
    $Vlog.debug("Myapp00OfMasterMainteOfViewMixin") {"getMaxPageCountOfMyapp00 start"}                 # Logファイル Debug用

    responseRecord = getJsonChunkById(@response_data, "records", idName)
    page_line      = responseRecord["record"]["ページライン数"]["value"][0].to_i
    total_count    = responseRecord["record"]["トータル件数"]["value"][0].to_i
    if total_count == 0
      max_page      = 1
    else
      max_page      = ((total_count + (page_line - 1)) / page_line).truncate
    end
    
    responseRecord["record"]["最大ページ"]["value"][0] = max_page
    
    $Vlog.debug("Myapp00OfMasterMainteOfViewMixin") {"getMaxPageCountOfMyapp00 end"}                   # Logファイル Debug用
    return "OK"
  end

  # ファイル名（パス情報含む）を使用してファイルを出力する
  # Excel iPad　双方で文字化けしないようにbomを付けた
  # 2015-07-21 SHIMOYAMA Yoshihiro 
  def writeCodeFileWithBom(file_name, data, outcode)
    $Vlog.debug("Myapp00OfMasterMainteOfViewMixin") {"writeCodeFileWithBom start"}                 # Logファイル Debug用
    begin
      file = File.open(file_name, "w:#{outcode}")

      bom = '   '
      bom.setbyte(0, 0xEF)
      bom.setbyte(1, 0xBB)
      bom.setbyte(2, 0xBF)

      file.write(bom)
      file.write(data)
      file.close
    rescue Exception
      puts Exception.message
    end
    $Vlog.debug("Myapp00OfMasterMainteOfViewMixin") {"writeCodeFileWithBom end"}                   # Logファイル Debug用
  end
end

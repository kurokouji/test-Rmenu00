# coding: UTF-8

require 'RmenuLoggerMixin'                                                      # Logファイル Debug用
require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する

module Myapp00OfMasterMainteOfModelMixin
  include RmenuLoggerMixin                                                      # Logファイル Debug用
  include RmenuJsonMixin

  # カレントページ数とページ当りの行数を使って、オフセット行数を計算する
  def getOffsetLineOfMyapp00(idName1, idName2)
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"getOffsetLineOfMyapp00 start"}                  # Logファイル Debug用

    requestRecord   = getJsonChunkById(@request_data, "records", idName1)
    page_line       = requestRecord["record"]["ページライン数"]["value"][0].to_i
    cur_page        = requestRecord["record"]["カレントページ"]["value"][0].to_i
    offset_line     = (cur_page - 1) * page_line
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"ページライン数 :     #{page_line}"}
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"カレントページ :     #{cur_page}"}
    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"オフセットライン数 : #{offset_line}"}

    sqlRecord = getJsonChunkById(@sql_data, "sqls", idName2, "input")
    sqlRecord["record"]["オフセットライン数"]["value"][0] = offset_line.to_s

    $Mlog.debug("Myapp00OfBaseNameMainteOfModelMixin") {"getOffsetLineOfMyapp00 end"}                    # Logファイル Debug用
    return "OK"
  end
end

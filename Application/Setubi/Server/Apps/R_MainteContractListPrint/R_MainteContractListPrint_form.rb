# coding: UTF-8

require "date"
require 'RmenuJsonMixin' # ID名で該当レコードを取得する
require 'Setubi/Server/Modules/SetubiOfPrintOfFormMixin'

class R_MainteContractListPrint_form
  include RmenuJsonMixin
  include SetubiOfPrintOfFormMixin  

  def initialize(pdfcreate, response_data, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $PDFC.debug("R_MainteContractListPrint_form") {"initialize start"}                          # Logファイル Debug用

      @pdfcreate      = pdfcreate
      @response_data  = response_data
      @sql_data       = sql_data
      @request_data   = request_data

      @controlPageCount = 0
      @controlPageKey   = ""

      # initialize 終了ログを出力する
      $PDFC.debug("R_MainteContractListPrint_form") {"initialize normal end"}                     # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $PDFC.error("R_MainteContractListPrint_form") {"initialize exception: #{$!}"}               # Logファイル Debug用
      raise
    end
  end

  # ページヘッダ処理
  def page_header()
    begin
      $PDFC.debug("R_MainteContractListPrint_form") {"page_header start"}                               # Logファイル Debug用

      sqlRecord      = getJsonChunkById(@sql_data     , "sqls"   , "page_header"  , "output", "record")
      requestRecord = getJsonChunkById(@request_data, "records", "printparam"  , "record")      
      responseRecord = getJsonChunkById(@response_data, "records", "page_header"  , "record")

      header_dateTime = requestRecord["処理日時"]["value"][0]
#     responseRecord["処理日付"]["value"][0] = formatDateTime(DateTime.now.to_s,'YYYY年M月D日')
#     responseRecord["処理時刻"]["value"][0] = formatDateTime(DateTime.now.to_s,'H時m分s秒'   )
      responseRecord["処理日付"]["value"][0] = formatDateTime(header_dateTime,'YYYY年M月D日')
      responseRecord["処理時刻"]["value"][0] = formatDateTime(header_dateTime,'H時m分s秒'   )

      responseRecord["ページ"]["value"][0]     = @pdfcreate.getTotalPageCount()

      $PDFC.debug("R_MainteContractListPrint_form") {"page_header end"}                                 # Logファイル Debug用
      return "OK"
    rescue Exception
      $PDFC.error("R_MainteContractListPrint_form") {"page_header: #{$!}"}               # Logファイル Debug用
      raise
    end
  end

end

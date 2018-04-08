# coding: UTF-8

require "date"
require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する

class R_CustomersListPrint_form
  include RmenuJsonMixin

  def initialize(pdfcreate, response_data, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $PDFC.debug("R_CustomersListPrint_form") {"initialize start"}                          # Logファイル Debug用

      @pdfcreate      = pdfcreate
      @response_data  = response_data
      @sql_data       = sql_data
      @request_data   = request_data
      @row_count   = 0
      @pdfObject = @pdfcreate.getPdfObject()

      # initialize 終了ログを出力する
      $PDFC.debug("R_CustomersListPrint_form") {"initialize normal end"}                     # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $PDFC.error("R_CustomersListPrint_form") {"initialize exception: #{$!}"}               # Logファイル Debug用
      raise
    end
  end

  # ページフォーマット（罫線描画等）
  def background_pattern()
    begin
      $PDFC.debug("R_CustomersListPrint_form") {"background_pattern start"}                               # Logファイル Debug用

    pdfObject = @pdfcreate.getPdfObject()

#    pdfObject.fill_color "ffd700"
    pdfObject.fill_color "40E0D0"
    pdfObject.fill_rectangle [-27, 812], 593, 42

      $PDFC.debug("R_CustomersListPrint_form") {"background_pattern end"}                                 # Logファイル Debug用
      return "OK"
    rescue Exception
      # エラーログを出力する
      $PDFC.error("R_CustomersListPrint_form") {"background_pattern: #{$!}"}               # Logファイル Debug用
      raise
    end
  end

  # ページヘッダー処理（システム日付・ページ番号）
  def page_header()
    begin
      $PDFC.debug("R_CustomersListPrint_form") {"page_header start"}                               # Logファイル Debug用

      responseRecord       = getJsonChunkById(@response_data, "records", "page_header","record")

      responseRecord["ページ"]["value"][0]     = @pdfcreate.getTotalPageCount()

      $PDFC.debug("R_CustomersListPrint_form") {"page_header end"}                                 # Logファイル Debug用
      return "OK"
    rescue Exception
      # エラーログを出力する
      $PDFC.error("R_CustomersListPrint_form") {"page_header: #{$!}"}               # Logファイル Debug用
      raise
    end
  end

  # 明細（印刷行数）
  def page_detail()
    begin
      $PDFC.debug("R_CustomersListPrint_form") {"page_detail start"}                               # Logファイル Debug用

      @row_count = @row_count + 1

      responseRecord       = getJsonChunkById(@response_data, "records", "detail","record")

      tcount =  @pdfcreate.getTotalRecordCount()

      $PDFC.debug("R_CustomersListPrint_form") {"page_detail aaaaaaa #{tcount}"}                                 # Logファイル Debug用

      responseRecord["印刷行数"]["value"][tcount - 1]   = tcount


#      responseRecord["印刷行数"]["value"][@row_count - 1]   = @row_count




      $PDFC.debug("R_CustomersListPrint_form") {"page_detail end"}                                 # Logファイル Debug用
      return "OK"
    rescue Exception
      # エラーログを出力する
      $PDFC.error("R_CustomersListPrint_form") {"page_detail: #{$!}"}               # Logファイル Debug用
      raise
    end
  end



  # ページフォーマット（背景・罫線描画等）
  def background_grid(flag)
    begin
      $PDFC.debug("#{__FILE__}") {"#{__method__} start"}                       # Logファイル Debug用
    status = "OK"

      if (flag == false) then
      $PDFC.debug("#{__FILE__}") {"#{__method__} exit"}                       # Logファイル Debug用
        return status
      end

      drawGrid(@pdfObject)

      $PDFC.debug("#{__FILE__}") {"#{__method__} end"}                       # Logファイル Debug用
      return "OK"
    rescue Exception
      # エラーログを出力する
      $PDFC.error("#{__FILE__}") {"#{__method__} exception: #{$!}"}          # Logファイル Debug用
      raise
    end
  end

  def drawGrid(pdfObj)
    begin
      $PDFC.debug("#{__FILE__}") {"#{__method__} start"}                       # Logファイル Debug用
      status = "OK"

    pdfObj.stroke_color 50, 100, 0, 0
    pdfObj.cap_style = :round
    pdfObj.join_style = :round

    pdfObj.line_width = 0.15.mm
    pdfObj.dash(2, :space => 2, :phase => 2)

    pdfObj.transparent(0.2) do
      num = 0
      while num < pdfObj.bounds.height
        pdfObj.stroke_line [0, num], [pdfObj.bounds.width, num]
        num += 10.mm
      end

      num = 0
      while num < pdfObj.bounds.width
        pdfObj.stroke_line [num, 0], [num, pdfObj.bounds.height]
        num += 10.mm
      end
    end


    pdfObj.stroke_color "000000"
    pdfObj.transparent(0.3) do
      num = 0
      while num < pdfObj.bounds.height
        pdfObj.stroke_line [0, num], [pdfObj.bounds.width, num]
        num += 50.mm
      end

      num = 0
      while num < pdfObj.bounds.width
        pdfObj.stroke_line [num, 0], [num, pdfObj.bounds.height]
        num += 50.mm
      end
    end

    pdfObj.undash() 

      $PDFC.debug("#{__FILE__}") {"#{__method__} end"}                       # Logファイル Debug用
      return status
    rescue Exception
      # エラーログを出力する
      $PDFC.error("#{__FILE__}") {"#{__method__} exception: #{$!}"}          # Logファイル Debug用
      raise
    end
  end

end

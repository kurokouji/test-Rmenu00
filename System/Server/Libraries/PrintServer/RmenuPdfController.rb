# coding: UTF-8

require 'RmenuPdfCreate'
require 'RmenuLoggerMixin'
require 'json'


class RmenuPdfController
  include RmenuLoggerMixin

  def initialize(log_file_name)
    $PDF             = createLogger(log_file_name)                                                  # PdfController用ログの作成

    begin
      # initialize 開始ログを出力する
      $PDF.debug ("PdfController") {"initialize start"}                                             # Logファイル Debug用

      # initialize 終了ログを出力する
      $PDF.debug ("PdfController") {"initialize normal end"}                                        # Logファイル Debug用
    rescue
      $PDF.error ("PdfController") {"initialize exception: #{$!}"}                                  # Logファイル Debug用
    end
  end

  # 初期処理
  def start(response_data, sql_data, request_data)
    $PDF.debug("PdfController") {"start    start"}                                                  # Logファイル Debug用

    @pdfcreate = RmenuPdfCreate.new("pdfcreate", response_data, sql_data, request_data)
    @pdfcreate.start(response_data)

    $PDF.debug("PdfController") {"start    end"}                                                    # Logファイル Debug用
  end

  # 終了処理
  def terminate(response_data, sql_data, request_data)
    $PDF.debug("PdfController") {"terminate    start"}                                              # Logファイル Debug用

    newResponse = @pdfcreate.terminate(response_data)

    $PDF.debug("PdfController") {"terminate    end"}                                                # Logファイル Debug用
    return newResponse
  end

  # 帳票　ヘッダー
  def printHeader(response_data, sql_data, request_data)
    $PDF.debug("PdfController") {"printHeader    start"}                                            # Logファイル Debug用

    @pdfcreate.printHeader(response_data)

    $PDF.debug("PdfController") {"printHeader    end"}                                              # Logファイル Debug用
  end

  # 帳票　フッター
  def printFooter(response_data, sql_data, request_data)
    $PDF.debug("PdfController") {"printFooter    start"}                                            # Logファイル Debug用

    @pdfcreate.printFooter(response_data)

    $PDF.debug("PdfController") {"printFooter    end"}                                              # Logファイル Debug用
  end

  # メイン処理（コントローラから呼び出される）
  def call(response_data, sql_data, request_data)
    begin
      # メイン処理 開始ログを出力する
      $PDF.debug("PdfController") {"call    start"}                                                 # Logファイル Debug用

      recordArray = @pdfcreate.getRecordOfPageOutputControl("detail", "all_page", response_data)

      arraySize = recordArray.length - 1
      maxSize  = 0
      tempSize = 0
      for num in 0..arraySize do
        recordArray[num]["record"].each{|key, value|
          tempSize = value["value"].size
          if tempSize > maxSize
            maxSize = tempSize
          end
        }
      end

      @pdfcreate.printReady(@pdfcreate, response_data, sql_data, request_data)
      @pdfcreate.pageHeaderFirst(response_data)
      @pdfcreate.controlHeaderFirst(response_data)
      @pdfcreate.setCurrentLineCount(0)

      for num in 1..maxSize do
        @pdfcreate.addTotalRecordCount()
        @pdfcreate.detailControl(recordArray, num, maxSize, response_data)
      end

      pageFooterLastSW = @pdfcreate.getPageFooterLastSW()
      if pageFooterLastSW == 0
        @pdfcreate.controlFooterLast(response_data)
        @pdfcreate.pageFooterLast(response_data)
      end

      # メイン処理 終了ログを出力する
      $PDF.debug("PdfController") {"call normal end"}                                               # Logファイル Debug用
    rescue
      # メイン処理 エラーログを出力する
      $PDF.error("PdfController") {"call exception: #{$@}"}                                         # Logファイル Debug用
    end
  end
end

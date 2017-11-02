# coding: UTF-8

require 'RmenuJsonMixin'                                                                  # ID名で該当レコードを取得する
require 'RmenuLoggerMixin'                                                                # pdfファイル　削除用
require 'RmenuConfig'                                                                     # Rmenu環境設定クラス
require 'Myapp00/Server/Modules/Myapp00OfMasterMainteOfModelMixin'

class ParallelPrintList_model
  include RmenuJsonMixin
  include RmenuLoggerMixin                                                                # Logファイル Debug用
  include Myapp00OfMasterMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("ParallelPrintList_model") {"initialize start"}                         # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("ParallelPrintList_model") {"initialize normal end"}                    # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("ParallelPrintList_model") {"initialize exception: #{$!}"}              # Logファイル Debug用
      raise
    end
  end

  # PDFファイルを削除する
  def pdfDeleteOfMyapp00
    $Mlog.debug("ParallelPrintList_model") {"pdfDeleteOfMyapp00 start"}                            # Logファイル Debug用

    request_record = @request_data["records"][0]["record"]
    pdfFime        = request_record["削除ファイル名称"]["value"][0]
    url            = $Rconfig["apps_path"] + "/" + pdfFime

    $Mlog.debug("ParallelPrintList_model") {"delete file name : #{url}"}                  # Logファイル Debug用
    deleteFile(url)

    $Mlog.debug("ParallelPrintList_model") {"pdfDeleteOfMyapp00 end"}                              # Logファイル Debug用
    return "OK"
  end

end

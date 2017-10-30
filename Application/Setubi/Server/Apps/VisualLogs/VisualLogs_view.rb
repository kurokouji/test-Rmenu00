# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfMasterMainteOfViewMixin'

class VisualLogs_view
  include SetubiOfMasterMainteOfViewMixin

  def initialize(response_data, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Vlog.debug("VisualLogs_view") {"initialize start"}                    # Logファイル Debug用

      @response_data  = response_data
      @sql_data       = sql_data
      @request_data   = request_data
      
      # initialize 終了ログを出力する
      $Vlog.debug("VisualLogs_view") {"initialize normal end"}               # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Vlog.error("VisualLogs_view") {"initialize exception: #{$!}"}         # Logファイル Debug用
      raise
    end
  end

end

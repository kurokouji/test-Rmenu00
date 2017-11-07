# coding: UTF-8

require 'Myapp00/Server/Modules/Myapp00OfBaseNameMainteOfModelMixin'


class R_SalesPersonMainte_model
  include Myapp00OfBaseNameMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("R_SalesPersonMainte_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("R_SalesPersonMainte_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("R_SalesPersonMainte_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

end

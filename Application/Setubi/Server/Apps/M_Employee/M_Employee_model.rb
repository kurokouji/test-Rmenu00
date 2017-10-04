# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfBaseNameMainteOfModelMixin'

class M_Employee_model
  include SetubiOfBaseNameMainteOfModelMixin

  def initialize(rmenu_db, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("M_Employee_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_db       = rmenu_db
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("M_Employee_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("M_Employee_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

end

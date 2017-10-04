# coding: UTF-8

require 'Setubi/Server/Modules/SetubiOfBaseNameMainteOfModelMixin'

class Sample_ClassMainte_model
  include SetubiOfBaseNameMainteOfModelMixin

  def initialize(rmenu_db, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("Sample_ClassMainte_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_db       = rmenu_db
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("Sample_ClassMainte_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("Sample_ClassMainte_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

end

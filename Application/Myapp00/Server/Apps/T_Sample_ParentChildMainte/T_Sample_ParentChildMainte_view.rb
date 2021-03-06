# coding: UTF-8

require 'date'
require 'RmenuFilePathMixin'                                                    # セッション処理用
require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する

class T_Sample_ParentChildMainte_view
  include RmenuFilePathMixin                                                    # Logファイル Debug用
  include RmenuJsonMixin

  def initialize(response_data, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Vlog.debug("T_Sample_ParentChildMainte_view") {"initialize start"}                    # Logファイル Debug用

      @response_data  = response_data
      @sql_data       = sql_data
      @request_data   = request_data
      
      # initialize 終了ログを出力する
      $Vlog.debug("T_Sample_ParentChildMainte_view") {"initialize normal end"}               # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Vlog.error("T_Sample_ParentChildMainte_view") {"initialize exception: #{$!}"}         # Logファイル Debug用
      raise
    end
  end

end

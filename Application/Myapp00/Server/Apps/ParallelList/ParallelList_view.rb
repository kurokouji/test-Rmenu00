# coding: UTF-8

require 'RmenuConfig'                                                           # Rmenu環境設定クラス
require 'RmenuLoggerMixin'                                                      # Logファイル Debug用
require 'RmenuFilePathMixin'                                                    # セッション処理用
require 'Myapp00/Server/Modules/Myapp00OfMasterMainteOfViewMixin'

class ParallelList_view
  include RmenuLoggerMixin                                                      # Logファイル Debug用
  include RmenuFilePathMixin                                                    # Logファイル Debug用
  include Myapp00OfMasterMainteOfViewMixin

  def initialize(response_data, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Vlog.debug("ParallelList_view") {"initialize start"}                    # Logファイル Debug用

      @response_data  = response_data
      @sql_data       = sql_data
      @request_data   = request_data
      
      # initialize 終了ログを出力する
      $Vlog.debug("ParallelList_view") {"initialize normal end"}               # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Vlog.error("ParallelList_view") {"initialize exception: #{$!}"}         # Logファイル Debug用
      raise
    end
  end

end

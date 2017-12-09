# coding: UTF-8

class T_Sample_ParentChildMainte_controller

  def initialize(request_data, validation_data)
    begin
      # initialize 開始ログを出力する
      $Clog.debug("T_Sample_ParentChildMainte_controller") {"initialize start"}              # Logファイル Debug用

      @request_data      = request_data
      @validation_data   = validation_data
      
      # initialize 終了ログを出力する
      $Clog.debug("T_Sample_ParentChildMainte_controller") {"initialize normal end"}         # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Clog.error("T_Sample_ParentChildMainte_controller") {"initialize exception: #{$!}"}   # Logファイル Debug用
      raise
    end
  end
end
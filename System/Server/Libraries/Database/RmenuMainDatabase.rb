# coding: UTF-8

require 'RmenuLoggerMixin'
require "RmenuMainRubyDbi"
require "RmenuMainSequel"

class RmenuMainDatabase
  include RmenuLoggerMixin

  def initialize(log_file_name)
    $Dlog             = createLogger(log_file_name)                             # database用ログの作成

    begin
      # initialize 開始ログを出力する
      $Dlog.debug("RmenuMainDatabase") {"initialize start"}
      
      case $Rconfig['db_tool']
      when "Sequel"
        @mainDatabase = RmenuMainSequel.new()
      when "RubyDbi"
        @mainDatabase = RmenuMainRubyDbi.new()
      else
        $Dlog.error("RmenuMainDatabase") {"Rconfig error: db_tool?"}
        raise
      end
      
      # initialize 終了ログを出力する
      $Dlog.debug("RmenuMainDatabase") {"initialize normal end"}
    rescue
      # エラーログを出力する
      $Dlog.error("RmenuMainDatabase") {"initialize exception: #{$!}"}
      raise
    end
  end

  def getDatabase()
    return @mainDatabase
  end
end
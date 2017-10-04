# coding: UTF-8

require 'RmenuLoggerMixin'
require 'RmenuTupleSpace'

class RestartMainServer
  include RmenuLoggerMixin

  def initialize(log_file_name)
    $Tlog                     = createLogger(log_file_name)                     # TupleServer用ログの作成

    begin
      # initialize 開始ログを出力する
      $Tlog.debug("RestartTupleServer") {"initialize start"}                    # Logファイル Debug用

      @tuplespace             = RmenuTupleSpace.new()                           # タプルスペース

      # initialize 終了ログを出力する
      $Tlog.debug("RestartTupleServer") {"initialize normal end"}               # Logファイル Debug用
    rescue
      # エラーログを出力する
      $Tlog.error("RestartTupleServer") {"initialize exception: #{$!}"}         # Logファイル Debug用
    end
  end

  # メイン処理（コントローラから呼び出される）
  def call(parallel_controll_id, parallel_division_id, dbname)
    begin
      # メイン処理 開始ログを出力する
      $Tlog.debug("RestartTupleServer") {"call start"}                          # Logファイル Debug用

      @tuplespace.writeTupleClien(parallel_controll_id, parallel_division_id, dbname)

      # メイン処理 終了ログを出力する
      $Tlog.debug("RestartTupleServer") {"call normal end"}                     # Logファイル Debug用
    rescue
      # メイン処理 エラーログを出力する
      $Tlog.error("RestartTupleServer") {"call exception: #{$@}"}               # Logファイル Debug用
    end
  end
end

# coding: UTF-8

require 'RmenuLoggerMixin'
require 'RmenuParallelControll'
require 'json'
require 'RmenuJsonMixin'

class RmenuParallelPrintStartUp
  include RmenuLoggerMixin
  include RmenuJsonMixin

  def initialize( *args )
    $PSlog                     = createLogger("ParallelPrintStartUp")                     # TupleClient用ログの作成

    begin
      # initialize 開始ログを出力する
      $PSlog.debug("ParallelPrintStartUp") {"initialize start"}

      argsSize = args.length
      if argsSize == 0
        @rmenu_db               = nil                                                     # DBオブジェクト(dbno=0)
        @parallel_controll_id   = nil                                                     # ジョブ管理テーブル
        @rmenuParallelControll  = nil                                                     # ジョブ管理テーブル
      else
        @rmenu_db               = args[0]                                                 # DBオブジェクト(dbno=0)
        @parallel_controll_id   = args[1]
        @rmenuParallelControll  = RmenuParallelControll.new(@rmenu_db)                    # ジョブ管理テーブル
      end

      @rmenuPrintServer = DRbObject.new_with_uri($Rconfig["printserver_uri"])

      # initialize 終了ログを出力する
      $PSlog.debug("ParallelPrintStartUp") {"initialize normal end"}
    rescue
      # エラーログを出力する
      $PSlog.error("ParallelPrintStartUp") {"initialize exception: #{$!}"}
      raise
    end
  end

  # スタート プリントサーバ処理
  def call(sql_data)
    begin
      $PSlog.debug("ParallelPrintStartUp") {"並列分散帳票処理　スタートアップ start"}     # Logファイル Debug用

      # プリントサーバのcallを実行し、レスポンスデータを取得する
      printparam    = getJsonChunkById(sql_data, "sqls", "printparam")
      response_data = @rmenuPrintServer.call(printparam)

      # 並列帳票管理テーブルをINSERTする
      if @parallel_controll_id
        $PSlog.debug("ParallelPrintStartUp") {"並列帳票管理　テーブル insert start"}      # Logファイル Debug用

        @rmenuParallelControll.print_insert(@parallel_controll_id, response_data)

        $PSlog.debug("ParallelPrintStartUp") {"並列帳票管理　テーブル insert end"}        # Logファイル Debug用
      end

      $PSlog.debug("ParallelPrintStartUp") {"並列分散帳票処理　スタートアップ end"}       # Logファイル Debug用
      return response_data
    rescue
      $PSlog.debug("ParallelPrintStartUp") {"ロールバックを実行"}
      
      # エラーログを出力する
      $PSlog.error("ParallelPrintStartUp") {"call exception: #{$!}"}                      # Logファイル Debug用
      raise
    end
  end

end

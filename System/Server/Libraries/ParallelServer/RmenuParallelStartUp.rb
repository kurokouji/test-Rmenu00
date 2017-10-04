# coding: UTF-8

require 'RmenuLoggerMixin'
require 'RmenuParallelControll'
require 'RmenuTupleSpace'
require 'json'

class RmenuParallelStartUp
  include RmenuLoggerMixin

  def initialize(rmenu_db)
    #$Tlog                     = createLogger("ParallelStartUp")                          # TupleClient用ログの作成

    begin
      # initialize 開始ログを出力する
      #$Tlog.debug("ParallelStartUp") {"initialize start"}

      @rmenu_db               = rmenu_db                                                  # DBオブジェクト(dbno=0)
      @tuplespace             = RmenuTupleSpace.new()                                     # タプルスペース
      @rmenuParallelControll  = RmenuParallelControll.new(@rmenu_db)                      # ジョブ管理テーブル

      # initialize 終了ログを出力する
      #$Tlog.debug("ParallelStartUp") {"initialize normal end"}
    rescue
      # エラーログを出力する
      #$Tlog.error("ParallelStartUp") {"initialize exception: #{$!}"}
      raise
    end
  end

  # スタート バッチサーバ処理
  def call(sql_data)
    begin
      #$Tlog.debug("ParallelStartUp") {"並列分散処理スタートアップ start"}                # Logファイル Debug用

      # 並列分散管理テーブルをINSERTする
      #$Tlog.debug("ParallelStartUp") {"並列分散管理　テーブル insert start"}             # Logファイル Debug用
      @rmenuParallelControll.controll_insert(sql_data)
      #$Tlog.debug("ParallelStartUp") {"並列分散管理　テーブル insert end"}               # Logファイル Debug用

      # 並列分散キーテーブルをINSERTする
      #$Tlog.debug("ParallelStartUp") {"並列分散キー　テーブル insert start"}             # Logファイル Debug用
      @rmenuParallelControll.keyvalue_insert(sql_data)
      #$Tlog.debug("ParallelStartUp") {"並列分散キー　テーブル insert end"}               # Logファイル Debug用

      # 並列分散パラメータテーブルをINSERTする
      #$Tlog.debug("ParallelStartUp") {"並列分散パラメータ　テーブル insert start"}       # Logファイル Debug用
      @rmenuParallelControll.param_insert(sql_data)
      #$Tlog.debug("ParallelStartUp") {"並列分散パラメータ　テーブル insert end"}         # Logファイル Debug用

      # タプルスペースへサーバ情報（"TupleServer", parallel_controll_id）を出力する
      #$Tlog.debug("ParallelStartUp") {"タプルスペース write start"}                      # Logファイル Debug用
      @tuplespace.writeTupleServer(sql_data)
      #$Tlog.debug("ParallelStartUp") {"タプルスペース write end"}                        # Logファイル Debug用

      #$Tlog.debug("ParallelStartUp") {"並列分散処理スタートアップ end"}                  # Logファイル Debug用
			
			#$Tlog.close()
    rescue
      #$Tlog.debug("ParallelStartUp") {"ロールバックを実行"}
      
      # エラーログを出力する
      #$Tlog.error("ParallelStartUp") {"call exception: #{$!}"}                           # Logファイル Debug用
      raise
    end
  end

end

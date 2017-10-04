# coding: UTF-8

require 'RmenuLoggerMixin'
require 'RmenuParallelDBMixin'
require 'RmenuMainDatabase'
require 'RmenuTupleSpace'
require 'RmenuParallelControll'
require 'RmenuParallelDivisionControll'

class RmenuTupleMainServer
  include RmenuLoggerMixin
  include RmenuParallelDBMixin

  def initialize(log_file_name)
    $Tlog                     = createLogger(log_file_name)                               # TupleServer用ログの作成

    begin
      # initialize 開始ログを出力する
      $Tlog.debug("TupleMainServer") {"initialize start"}                                 # Logファイル Debug用

      maindatabase            = RmenuMainDatabase.new(log_file_name + "DB")               # DATABASEオブジェクトをプーリング
      @db_queue               = maindatabase.getDatabase()
      @tuplespace             = RmenuTupleSpace.new()                                     # タプルスペース

      # initialize 終了ログを出力する
      $Tlog.debug("TupleMainServer") {"initialize normal end"}                            # Logファイル Debug用
    rescue
      # エラーログを出力する
      $Tlog.error("TupleMainServer") {"initialize exception: #{$!}"}                      # Logファイル Debug用
    end
  end

  # メイン処理（コントローラから呼び出される）
  def call()
    begin
      # メイン処理 開始ログを出力する
      $Tlog.debug("TupleMainServer") {"call start"}                                       # Logファイル Debug用

      # ループ開始
      loop do
        # タプルスペース take(['TupleServer', parallel_controll_id, dbname])
        tuple                = @tuplespace.takeTupleServer()
        parallel_controll_id = tuple[1]
        dbname               = tuple[2]
        $Tlog.debug("TupleMainServer") {"take TupleServer id : #{parallel_controll_id}"}
        $Tlog.debug("TupleMainServer") {"take TupleServer db : #{dbname}"}
        
        # 終了判定
        if parallel_controll_id == 0
          break
        end

        # DBオブジェクトをキューから取得する
        rmenu_db        = @db_queue.pop

        # トランザクションをスタートする
        $Tlog.debug("TupleMainServer") {"トランザクション スタート"}
        transaction(rmenu_db, dbname)

        rmenuParallelControll         = RmenuParallelControll.new(rmenu_db)               # ジョブ管理テーブル
        rmenuParallelDivisionControll = RmenuParallelDivisionControll.new(rmenu_db)       # ジョブ管理テーブル

        # ジョブ管理テーブルをSELECTする
        $Tlog.debug("TupleMainServer") {"並列分散管理テーブル select start"}              # Logファイル Debug用
        parallelData = rmenuParallelControll.controll_select(parallel_controll_id)
        $Tlog.debug("TupleMainServer") {"並列分散管理テーブル select end"}                # Logファイル Debug用

        # 分割ジョブ管理テーブルをINSERTする
        $Tlog.debug("TupleMainServer") {"並列分割管理テーブル insert start"}              # Logファイル Debug用
        rmenuParallelDivisionControll.insert(parallel_controll_id, parallelData["division_number"])
        $Tlog.debug("TupleMainServer") {"並列分割管理テーブル insert end"}                # Logファイル Debug用

        # タプルスペースに分割ジョブ数分、ジョブIDとジョブNOを出力する
        $Tlog.debug("TupleMainServer") {"タプルスペース write (TupleClient parallel_controll_id, division_number_id) start"} # Logファイル Debug用
        i = 1
        division_number = parallelData["division_number"].to_i
        while i <= division_number
          @tuplespace.writeTupleClient(parallel_controll_id, i, dbname)
          i += 1
        end
        $Tlog.debug("TupleMainServer") {"タプルスペース write (TupleClient parallel_controll_id, division_number_id) end"}   # Logファイル Debug用

        # トランザクションをコミットする
        $Tlog.debug("TupleMainServer") {"コミットを実行"}
        commit(rmenu_db)

        # DBオブジェクトをキューに戻す
        @db_queue.push(rmenu_db)

      # ループ終了
      end

      # メイン処理 終了ログを出力する
      $Tlog.debug("TupleMainServer") {"call normal end"}                                  # Logファイル Debug用
    rescue
      # トランザクションをロールバックする
      $Tlog.debug("TupleMainServer") {"ロールバックを実行"}
      rollback(rmenu_db)

      # メイン処理 エラーログを出力する
      $Tlog.error("TupleMainServer") {"call exception: #{$@}"}                            # Logファイル Debug用
    end
  end
end

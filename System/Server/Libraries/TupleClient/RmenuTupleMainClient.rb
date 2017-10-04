# coding: UTF-8

require 'RmenuLoggerMixin'
require 'RmenuParallelDBMixin'
require 'RmenuDefCache'
require 'RmenuAppCache'

require 'RmenuMainDatabase'
require 'RmenuTupleSpace'
require 'RmenuParallelControll'
require 'RmenuParallelDivisionControll'
require 'RmenuTupleMainController'
require 'RmenuParallelStartUp'
require 'RmenuParallelPrintStartUp'
require 'RmenuJsonMixin'                                                                  # ID名で該当レコードを取得する

class RmenuTupleMainClient
  include RmenuLoggerMixin
  include RmenuParallelDBMixin
  include RmenuJsonMixin

  def initialize(log_file_name)
    $Tlog                     = createLogger(log_file_name)                               # TupleClient用ログの作成

    begin
      # initialize 開始ログを出力する
      $Tlog.debug("TupleMainClient") {"initialize start"}                                 # Logファイル Debug用

      maindatabase                   = RmenuMainDatabase.new(log_file_name + "DB")        # DATABASEオブジェクトをプーリング
      @db_queue                      = maindatabase.getDatabase()
      @tuplespace                    = RmenuTupleSpace.new()                              # タプルスペース

      # initialize 終了ログを出力する
      $Tlog.debug("TupleMainClient") {"initialize normal end"}                            # Logファイル Debug用
    rescue
      # エラーログを出力する
      $Tlog.error("TupleMainClient") {"initialize exception: #{$!}"}                      # Logファイル Debug用
    end
  end

  # メイン処理（コントローラから呼び出される）
  def call()
    begin
      # メイン処理 開始ログを出力する
      $Tlog.debug("TupleMainClient") {"call start"}                                       # Logファイル Debug用

      # ループ開始
      loop do
        # タプルスペース take(['TupleClient', parallel_controll_id, parallel_division_id, dbname])
        tuple                 = @tuplespace.takeTupleClient()
        parallel_controll_id  = tuple[1]
        parallel_division_id  = tuple[2]
        dbname                = tuple[3]
        $Tlog.debug("TupleMainClient") {"take TupleClient parallel_controll_id : #{parallel_controll_id}"}
        $Tlog.debug("TupleMainClient") {"take TupleClient parallel_division_id : #{parallel_division_id}"}
        $Tlog.debug("TupleMainClient") {"take TupleClient dbname : #{dbname}"}

        # 終了判定
        if parallel_controll_id == 0
          break
        end

        # DBオブジェクトをキューから取得する
        rmenu_db                      = @db_queue.pop

        # トランザクションをスタートする
        $Tlog.debug("TupleMainClient") {"トランザクション スタート"}
        transaction(rmenu_db, dbname)

        rmenuParallelControll         = RmenuParallelControll.new(rmenu_db)               # ジョブ管理テーブル
        rmenuParallelDivisionControll = RmenuParallelDivisionControll.new(rmenu_db)       # ジョブ管理テーブル
        rmenuTupleMainController      = RmenuTupleMainController.new(@db_queue, rmenu_db)

        # 並列分散管理テーブルの開始日時を更新する
        if parallel_division_id == 1
          $Tlog.debug("TupleMainClient") {"並列分散管理テーブルの開始日時を更新 start"}
          rmenuParallelControll.update_start_date(parallel_controll_id)
          $Tlog.debug("TupleMainClient") {"並列分散管理テーブルの開始日時を更新 end"}
        end

        # 並列分割管理テーブルの開始日時を更新する
        $Tlog.debug("TupleMainClient") {"並列分割管理テーブルの開始日時を更新 start"}
        rmenuParallelDivisionControll.update_start_date(parallel_controll_id, parallel_division_id)
        $Tlog.debug("TupleMainClient") {"並列分割管理テーブルの開始日時を更新 end"}

        # トランザクションをコミットする
        $Tlog.debug("TupleMainClient") {"コミットを実行"}
        commit(rmenu_db)

        # トランザクションをスタートする
        $Tlog.debug("TupleMainClient") {"トランザクション スタート"}
        transaction(rmenu_db, dbname)

        # タプルメインコントローラを実行する
        $Tlog.debug("TupleMainClient") {"タプルメインコントローラ　call start"}
        sql_data = rmenuTupleMainController.call(rmenuParallelControll, parallel_controll_id, parallel_division_id)
        $Tlog.debug("TupleMainClient") {"タプルメインコントローラ　call end"}
        $Tlog.debug("TupleMainClient") {"タプルメインコントローラ　実行後のsql_data : #{JSON.dump(sql_data)}"}

        # プリントサーバのcallを実行し、レスポンスデータを取得する
        printparam = getJsonChunkById(sql_data, "sqls", "printparam")
        if printparam
          $Tlog.debug("TupleMainClient") {"プリントサーバのcall start"}
          parallelPrintStartUp = RmenuParallelPrintStartUp.new(rmenu_db, parallel_controll_id)
          response_data = parallelPrintStartUp.call(sql_data)
          $Tlog.debug("TupleMainClient") {"プリントサーバのcall end"}
        end

        # 並列分割管理テーブルの終了日時を更新する
        $Tlog.debug("TupleMainClient") {"並列分割管理テーブルの終了日時を更新 start"}
        rmenuParallelDivisionControll.update_end_date(parallel_controll_id, parallel_division_id)
        $Tlog.debug("TupleMainClient") {"並列分割管理テーブルの終了日時を更新 end"}

        # 並列分散管理テーブルのの分割処理終了回数と終了日時を更新し、NEXT処理フラッグを戻す
        $Tlog.debug("TupleMainClient") {"並列分散管理テーブルの分割処理終了回数と終了日時を更新 start"}
        nextStatus = rmenuParallelControll.update_end_number(parallel_controll_id)
        $Tlog.debug("TupleMainClient") {"並列分散管理テーブルの分割処理終了回数と終了日時を更新 end"}

        # トランザクションをコミットする
        $Tlog.debug("TupleMainClient") {"コミットを実行"}
        commit(rmenu_db)

        # 分割処理終了数　＝　分割数の時NEXT処理の起動する
        if nextStatus
          # トランザクションをスタートする
          $Tlog.debug("TupleMainClient") {"トランザクション スタート"}
          transaction(rmenu_db, dbname)


				  $Tlog.debug("TupleMainClient") {"NEXT処理の起動 start"}
          parallelStartUp = RmenuParallelStartUp.new(rmenu_db)
          parallelStartUp.call(sql_data)
          $Tlog.debug("TupleMainClient") {"NEXT処理の起動 end"}

          # トランザクションをコミットする
          $Tlog.debug("TupleMainClient") {"コミットを実行"}
          commit(rmenu_db)
			  end


				# DBオブジェクトをキューに戻す
        @db_queue.push(rmenu_db)

      # ループ終了
      end

      # メイン処理 終了ログを出力する
      $Tlog.debug("TupleMainClient") {"call normal end"}                        # Logファイル Debug用
    rescue
      # トランザクションをロールバックする
      $Tlog.debug("TupleMainClient") {"ロールバックを実行"}
      rollback(@rmenu_db)

      # DBオブジェクトをキューに戻す
      @db_queue.push(@rmenu_db)

      # メイン処理 エラーログを出力する
      $Tlog.error("TupleMainClient") {"call exception: #{$@}"}                  # Logファイル Debug用
    end
  end
end

# coding: UTF-8

require 'RmenuLoggerMixin'
require 'RmenuParallelDBMixin'
require 'RmenuJsonMixin'

require 'json'
require 'RmenuTupleSpace'
require 'RmenuMainDatabase'
require 'RmenuParallelStartUp'

class RmenuTupleParallelMainServer
  include RmenuLoggerMixin
  include RmenuParallelDBMixin
  include RmenuJsonMixin

  def initialize(log_file_name)
    $Clog               = createLogger(log_file_name)                           # controller用ログの作成

    begin
      # initialize 開始ログを出力する
      $Tlog.debug("TupleParallelMainServer") {"initialize start"}               # Logファイル Debug用
    
      @tuplespace    = RmenuTupleSpace.new()                                    # タプルスペース
      maindatabase   = RmenuMainDatabase.new(log_file_name + "DB")              # DATABASEオブジェクトをプーリング
      @db_queue      = maindatabase.getDatabase()

    
      # initialize 終了ログを出力する
      $Tlog.debug("TupleParallelMainServer") {"initialize end"}                 # Logファイル Debug用
    rescue
      # エラーログを出力する
      $Tlog.debug("TupleParallelMainServer") {"initialize exception: #{$!}"}    # Logファイル Debug用
    end
  end

  # メイン処理（タプル並列クライアントから呼び出される）
  def call(request, sql_data)
    begin
      # メイン処理 開始ログを出力する
      $Tlog.debug("TupleParallelMainServer") {"call start"}                      # Logファイル Debug用

			if request == "tapleclient"
        # タプルスペース take(['TupleClient', parallel_controll_id, parallel_division_id, dbname])
        tuple = @tuplespace.takeTupleClient()

        # メイン処理 終了ログを出力する
        $Tlog.debug("TupleParallelMainServer") {"call normal end"}                 # Logファイル Debug用
			  return tuple
			end
			
			if request == "tapleserver"
          # DBオブジェクトをキューから取得し、DB名をsql_dataから取得する
          rmenu_db         = @db_queue.pop
		      parallelControll = getJsonChunkById(sql_data, "sqls", "parallelControll")
					dbname           = parallelControll["dbname"]

				  # トランザクションをスタートする
          $Tlog.debug("TupleParallelMainServer") {"トランザクション スタート"}
          transaction(rmenu_db, dbname)


				  $Tlog.debug("TupleParallelMainServer") {"NEXT処理の起動 start"}
          parallelStartUp = RmenuParallelStartUp.new(rmenu_db)
          parallelStartUp.call(sql_data)
          $Tlog.debug("TupleParallelMainServer") {"NEXT処理の起動 end"}

          # トランザクションをコミットする
          $Tlog.debug("TupleParallelMainServer") {"コミットを実行"}
          commit(rmenu_db)
					
				  # DBオブジェクトをキューに戻す
          @db_queue.push(rmenu_db)
					return "OK"
			end
			
    rescue
      # メイン処理 エラーログを出力する
      $Tlog.debug("TupleParallelMainServer") {"call exception: #{$@}"}           # Logファイル Debug用
    end
  end
end

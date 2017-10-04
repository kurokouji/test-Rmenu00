# coding: UTF-8

require 'RmenuLoggerMixin'
require 'RmenuParallelDBMixin'
require 'RmenuDefCache'
require 'RmenuAppCache'
require 'RmenuParallelControll'
require 'RmenuModel'
require 'json'
require 'RmenuJsonMixin'                                                                  # ID名で該当レコードを取得する

class RmenuTupleMainController
  include RmenuLoggerMixin
  include RmenuJsonMixin
  include RmenuParallelDBMixin

  def initialize(db_queue, rmenu_db)
    $Mlog                     = createLogger("TupleMainController")                       # TupleClient用ログの作成

    begin

      # initialize 開始ログを出力する
      $Mlog.debug("RmenuTupleMainController") {"initialize start"}                        # Logファイル Debug用

      @db_queue                   = db_queue
      @rmenu_db                   = rmenu_db

      @tran_def_cache             = RmenuDefCache.new("tran.json")                        # sql定義情報のキャッシュ
      @tran_def_cache.createCache()
      @sql_def_cache              = RmenuDefCache.new("sql.json")                         # sql定義情報のキャッシュ
      @sql_def_cache.createCache()
      @app_cache                  = RmenuAppCache.new("model.rb")                         # モデルAPPのキャッシュ
      @app_cache.createCache()

      # initialize 終了ログを出力する
      $Mlog.debug("RmenuTupleMainController") {"initialize normal end"}                   # Logファイル Debug用
    rescue
      # エラーログを出力する
      $Mlog.debug("RmenuTupleMainController") {"initialize exception: #{$!}"}             # Logファイル Debug用
      raise
    end
  end
  
  # メイン処理
  def call(rmenuParallelControll, parallel_controll_id, parallel_division_id)
    begin
      # メイン処理 開始ログを出力する
      $Mlog.debug("RmenuTupleMainController") {"call start"}                              # Logファイル Debug用

      parallelData    = rmenuParallelControll.controll_select(parallel_controll_id)
      parallelKey     = rmenuParallelControll.keyvalue_select(parallel_controll_id)
      parallelParam   = rmenuParallelControll.param_select(parallel_controll_id)
      division_number = parallelData["division_number"].to_i
      $Mlog.debug("RmenuTupleMainController") {"parallelData    : #{JSON.dump(parallelData)}"}
      $Mlog.debug("RmenuTupleMainController") {"parallelKey     : #{JSON.dump(parallelKey)}"}
      $Mlog.debug("RmenuTupleMainController") {"parallelParam   : #{JSON.dump(parallelParam)}"}
      $Mlog.debug("RmenuTupleMainController") {"division_number : #{division_number}"}

      # トランJSONを読み込み、リクエストデータを設定する
      $Mlog.debug("RmenuTupleMainController") {"リクエストデータ読み込み start"}
      htmlMode         = Hash.new()
      htmlMode["html"] = parallelData["process_html"]
      htmlMode["mode"] = parallelData["process_mode"]
      tran_data        = @tran_def_cache.getJsonData(htmlMode)
      request_data     = tran_data["request"]
      $Mlog.debug("RmenuTupleMainController") {"読み込み　request_data : #{JSON.dump(request_data)}"}

      # parallelControllの値をリクエストデータに設定する
      parallelControll_info = getJsonChunkById(request_data, "records", "parallelControll")
      parallelData.each {|key, value|
        parallelControll_info["record"]["#{key}"]["value"][0] = value
      }
      $Mlog.debug("RmenuTupleMainController") {"parallelControllデータ編集後のrequest_data : #{JSON.dump(request_data)}"}

      # parallelParamの値リクエストデータに設定する
      parallelParam_info = getJsonChunkById(request_data, "records", "parallelParam")
      if parallelParam  != "{}"
        parallelParam.each {|key, value|
          parallelParam_info["record"]["#{key}"]["value"][0] = value["value"][0]
        }
      end
      $Mlog.debug("RmenuTupleMainController") {"parallelParamデータ編集後のrequest_data : #{JSON.dump(request_data)}"}

      dataSize        = 1
      tempSize        = 0
      if parallelKey  != "{}"
        parallelKey.each {|key, value|
          tempSize = value["value"].length
          if tempSize > dataSize
            dataSize   = tempSize
          end
        }
      end

      # 開始行数と終了行数を計算する
      # キーの行数　/　分割数・・・商：answer[0]  余り：answer[1]
      answer    = dataSize.divmod(division_number)
      start_row = (parallel_division_id - 1) * answer[0] + 1
      if division_number == parallel_division_id
        end_row = dataSize
      else
        end_row = parallel_division_id * answer[0]
      end

      # 行数回モデルを実行する
      $Mlog.debug("RmenuTupleMainController") {"start_row : #{start_row}"}
      $Mlog.debug("RmenuTupleMainController") {"end_row   : #{end_row}"}
      sql_data = ""
      for num in start_row..end_row do
        row = num - 1

        # parallelKeyの値をリクエストデータに設定する
        parallelKey_info = getJsonChunkById(request_data, "records", "parallelKey")
        if parallelKey  != "{}"
          parallelKey.each {|key, value|
            parallelKey_info["record"]["#{key}"]["value"][0] = value["value"][row]
          }
        end

        # 最後の処理判定用に、最後のデータを処理する時、分割処理終了数に分割数を設定する
        # 分割処理終了数　＝　分割数の時は最終処理
				parallel_end = false
        if dataSize == end_row
          parallelControll_info["record"]["division_end_number"]["value"][0] = division_number
					
					# 2015/04/03 shimoji
					if num == end_row
					  parallel_end = true
					end
        end
        $Mlog.debug("RmenuTupleMainController") {"parallelKeyデータ編集後のrequest_data : #{JSON.dump(request_data)}"}

        # モデルをインスタンスし、callを実行、SQLデータを取得する
        $Mlog.debug("RmenuTupleMainController") {"モデルをcall start"}
        rmemu_model     = RmenuModel.new(@rmenu_db, request_data, @db_queue, 1, parallel_end)
        sql_data        = rmemu_model.call(@sql_def_cache, @app_cache)
        $Mlog.debug("RmenuTupleMainController") {"モデル実行後のsql_data : #{JSON.dump(sql_data)}"}

        num += 1
      end

      # メイン処理 終了ログを出力する
      $Mlog.debug("RmenuTupleMainController") {"call normal end"}                         # Logファイル Debug用
      return sql_data
    rescue
      # メイン処理 エラーログを出力する
      $Mlog.error("RmenuTupleMainController") {"call exception: #{$!}"}                   # Logファイル Debug用
      raise
    end
  end
end

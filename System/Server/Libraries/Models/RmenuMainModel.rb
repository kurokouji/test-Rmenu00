# coding: UTF-8

require 'RmenuMainDatabase'
require 'RmenuDefCache'
require 'RmenuAppCache'
require 'RmenuModel'
require 'RmenuLoggerMixin'
require 'json'

class RmenuMainModel
  include RmenuLoggerMixin

  def initialize(log_file_name)
    $Mlog             = createLogger(log_file_name)                             # model用ログの作成

    begin
      # initialize 開始ログを出力する
      $Mlog.debug("MainModel") {"initialize start"}                             # Logファイル Debug用

      maindatabase    = RmenuMainDatabase.new(log_file_name + "DB")             # DATABASEオブジェクトをプーリング
      @db_queue       = maindatabase.getDatabase()
      @def_cache      = RmenuDefCache.new("sql.json")                           # sql定義情報のキャッシュ
      @def_cache.createCache()
      @app_cache      = RmenuAppCache.new("model.rb")                           # モデルAPPのキャッシュ
      @app_cache.createCache()
      
      # initialize 終了ログを出力する
      $Mlog.debug("MainModel") {"initialize normal end"}                        # Logファイル Debug用
    rescue
      # エラーログを出力する
      $Mlog.error("MainModel") {"initialize exception: #{$!}"}                  # Logファイル Debug用
    end
  end

  # メイン処理（コントローラから呼び出される）
  def call(request_data)
    begin
      # メイン処理 開始ログを出力する
      $Mlog.debug("MainModel") {"call start"}                                   # Logファイル Debug用

	  # 開発支援プロジェクトはログを出力しない
	  $Mlog = changeLoggerMode($Mlog, request_data)

      # リクエストデータをログ出力する
      $Mlog.debug("MainModel") {"リクエストデータ : #{JSON.dump(request_data)}"}

      # DBオブジェクトをキューから取得する
      rmenu_db        = @db_queue.pop

      # モデルをインスタンスし、callを実行、SQLデータを取得する
      rmemu_model     = RmenuModel.new(rmenu_db, request_data, @db_queue, nil, false)
      sql_data        = rmemu_model.call(@def_cache, @app_cache)

      # DBオブジェクトをキューに戻す
      @db_queue.push(rmenu_db)

      # モデル処理終了後の、SQLデータをログ出力する
      $Mlog.debug("MainModel") {"モデル処理終了後の、SQLデータ : #{JSON.dump(sql_data)}"}

      # メイン処理 終了ログを出力する
      $Mlog.debug("MainModel") {"call normal end"}                              # Logファイル Debug用

      # SQLデータをコントローラへリターン
      return sql_data
    rescue
      # メイン処理 エラーログを出力する
      $Mlog.error("MainModel") {"call exception: #{$@}"}                        # Logファイル Debug用
    end
  end
  
  # コントローラ接続完了
  def readyGo
    puts "MainController connect OK"
    $Mlog.debug("MainModel") {"MainController connect OK"}                      # Logファイル Debug用
  end
end

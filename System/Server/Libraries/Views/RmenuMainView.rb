# coding: UTF-8

require 'RmenuDefCache'
require 'RmenuAppCache'
require 'RmenuView'
require 'RmenuLoggerMixin'
require 'json'

class RmenuMainView
  include RmenuLoggerMixin

  def initialize(log_file_name)
    $Vlog             = createLogger(log_file_name)                             # view用ログの作成

    begin
      # initialize 開始ログを出力する
      $Vlog.debug ("MainView") {"initialize start"}                             # Logファイル Debug用

      @def_cache      = RmenuDefCache.new("tran.json")                          # tran情報定義のキャッシュ
      @def_cache.createCache()
      @app_cache      = RmenuAppCache.new("view.rb")                            # ビューAPPのキャッシュ
      @app_cache.createCache()
      
      # initialize 終了ログを出力する
      $Vlog.debug ("MainView") {"initialize normal end"}                        # Logファイル Debug用
    rescue
      $Vlog.error ("MainView") {"initialize exception: #{$!}"}                  # Logファイル Debug用
    end
  end

  # メイン処理（コントローラから呼び出される）
  def call(request_data, sql_data)
    begin
      # メイン処理 開始ログを出力する
      $Vlog.debug("MainView") {"call    start"}                                 # Logファイル Debug用

	  # 開発支援プロジェクトはログを出力しない
	  $Vlog = changeLoggerMode($Vlog, request_data)

      # リクエストデータをログ出力する
      $Vlog.debug("MainView") {"リクエストデータ : #{JSON.dump(request_data)}"}

      # SQLデータをログ出力する
      $Vlog.debug("MainView") {"SQLデータ : #{JSON.dump(sql_data)}"}

      # ビューをインスタンスし、callを実行、レスポンスデータを取得する
      rmemu_view      = RmenuView.new(request_data, sql_data)
      response_data   = rmemu_view.call(@def_cache, @app_cache)

      # クライアントへ送信する、レスポンスデータをログ出力する
      $Vlog.debug("MainView") {"クライアントへ送信する、レスポンスデータ : #{JSON.dump(response_data)}"}

      # メイン処理 終了ログを出力する
      $Vlog.debug("MainView") {"call normal end"}                               # Logファイル Debug用

      # レスポンスデータをコントローラへリターン
      return response_data
    rescue
      # メイン処理 エラーログを出力する
      $Vlog.error("MainView") {"call exception: #{$@}"}                         # Logファイル Debug用
    end
  end

  # コントローラ接続完了
  def readyGo
    puts "MainController connect OK"
    $Vlog.debug("MainView") {"MainController connect OK"}                       # Logファイル Debug用
  end
end


# coding: UTF-8

require 'RmenuDefCache'
require 'RmenuAppCache'
require 'RmenuController'
require 'RmenuLoggerMixin'
require 'json'
require 'RmenuJsonMixin'
require 'RmenuParallelPrintStartUp'

class RmenuMainController
  include RmenuLoggerMixin
  include RmenuJsonMixin

  def initialize(log_file_name, rmenu_main_model, rmenu_main_view)
    $Clog               = createLogger(log_file_name)                           # controller用ログの作成

    begin
      # initialize 開始ログを出力する
      $Clog.debug("MainController") {"initialize start"}                        # Logファイル Debug用
    
      @rmenu_main_model       = rmenu_main_model                                # メインモデル オブジェクト
      @rmenu_main_view        = rmenu_main_view                                 # メインビュー オブジェクト
      @def_cache              = RmenuDefCache.new("validation.json")            # validation定義情報のキャッシュ
      @def_cache.createCache()
      @app_cache              = RmenuAppCache.new("controller.rb")              # コントローラAPPのキャッシュ
      @app_cache.createCache()
    
      # initialize 終了ログを出力する
      $Clog.debug("MainController") {"initialize normal end"}                   # Logファイル Debug用
    rescue
      # エラーログを出力する
      $Clog.error("MainController") {"initialize exception: #{$!}"}             # Logファイル Debug用
    end
  end

  # メイン処理（cgiから呼び出される）
  def call(cgi_data)
    begin
      # メイン処理 開始ログを出力する
      $Clog.debug("MainController") {"call start"}                              # Logファイル Debug用
	  
	  # 開発支援プロジェクトはログを出力しない
	  $Clog = changeLoggerMode($Clog, cgi_data)
      
      # 受信したリクエスト(CGI)データをログ出力する
      $Clog.debug("MainController") {"受信したリクエスト(CGI)データ: #{JSON.dump(cgi_data)}"}

      # コントローラをインスタンスし、callを実行、チェック済リクエストデータを取得する
      rmemu_controller  = RmenuController.new(cgi_data)
      request_data      = rmemu_controller.call(@def_cache, @app_cache)

      # チェック済リクエストデータをログ出力する
      $Clog.debug("MainController") {"チェック済リクエストデータ: #{JSON.dump(request_data)}"}

      # メインモデルのcallを実行し、SQLデータを取得する
      sql_data = Hash.new
      if request_data["message"]["status"] == "OK"                              # コントローラのチェック処理ＯＫ
        if request_data.has_key?("model")
          if request_data["model"] == "yes"                                     # モデル処理有り
            sql_data  = @rmenu_main_model.call(request_data)
          end
        end
      end

      # モデルが作成したsql_dataをログ出力する
      $Clog.debug("MainController") {"モデルが作成したsql_data : #{JSON.dump(sql_data)}"}

      # プリントサーバのcallを実行し、レスポンスデータを取得する
      printparam = getJsonChunkById(sql_data, "sqls", "printparam")
      if printparam
        $Clog.debug("MainController") {"プリントサーバを起動し帳票を作成する"}

	    parallelPrintStartUp = RmenuParallelPrintStartUp.new()
        response_data = parallelPrintStartUp.call(sql_data)
				
        $Clog.debug("MainController") {"プリントサーバの帳票作成処理終了"}
      end

      # メインビューのcallを実行し、レスポンスデータを取得する
      if !printparam
        response_data     = @rmenu_main_view.call(request_data, sql_data)
      end

      # ビューまたはプリントサーバが作成したresponse_dataをログ出力する
      $Clog.debug("MainController") {"ビューが作成したresponse_data : #{JSON.dump(response_data)}"}

      # メイン処理 終了ログを出力する
      $Clog.debug("MainController") {"call normal end"}                         # Logファイル Debug用

      return response_data
    rescue
      # メイン処理 エラーログを出力する
      $Clog.error("MainController") {"call exception: #{$@}"}                   # Logファイル Debug用
    end
  end
end


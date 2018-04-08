# coding: UTF-8

require 'RmenuMainModel'
require 'RmenuMainView'
require 'RmenuDefCache'
require 'RmenuAppCache'
require 'RmenuPrintServerController'
require 'RmenuPdfController'
require 'RmenuLoggerMixin'
require 'json'

class RmenuPrintServerMainController
  include RmenuLoggerMixin

  def initialize(log_file_name)
    $PRClog = createLogger(log_file_name)                                                           # controller用ログの作成

    begin
      # initialize 開始ログを出力する
      $PRClog.debug("PrintServerMainController") {"initialize start"}                               # Logファイル Debug用

      @rmenu_main_model = RmenuMainModel.new("printmodel")                                          # メインモデル オブジェクト
      @rmenu_main_view  = RmenuMainView.new("printview")                                            # メインビュー オブジェクト
      @def_cache        = RmenuDefCache.new("tran.json")                                            # request定義情報のキャッシュ
      @def_cache.createCache()
      @app_cache        = RmenuAppCache.new("controller.rb")                                        # コントローラAPPのキャッシュ
      @app_cache.createCache()

      # initialize 終了ログを出力する
      $PRClog.debug("PrintServerMainController") {"initialize normal end"}                          # Logファイル Debug用
    rescue
      # エラーログを出力する
      $PRClog.error("PrintServerMainController") {"initialize exception: #{$!}"}                    # Logファイル Debug用
    end
  end

  # メイン処理（モデルから呼び出される）
  def call(printparam)
    begin
      # メイン処理 開始ログを出力する
      $PRClog.debug("PrintServerMainController") {"call start"}                                     # Logファイル Debug用
      
      # 受信したプリントパラメータデータをログ出力する
      $PRClog.debug("PrintServerMainController") {"受信したプリントパラメータデータ: #{JSON.dump(printparam)}"}

      paramRecord    = printparam["input"]["record"]
      dataSize       = 1
      tempSize       = 0
      paramRecord.each {|key, value|
        tempSize = value["value"].length
        if tempSize > dataSize
          dataSize = tempSize
        end
      }

      for num in 1..dataSize do
        # 項目名・値のハッシュを作成する
        keyparamHash = Hash.new()
        paramRecord.each {|key, value|
          if value["value"][num - 1]
            keyparamHash[key] = value["value"][num - 1]
          else
            keyparamHash[key] = value["value"][0]
          end
        }

        # プリントサーバコントローラをインスタンスし、callを実行、リクエストデータを取得する
        rmemu_controller  = RmenuPrintServerController.new(printparam, keyparamHash)
        request_data      = rmemu_controller.call(@def_cache, @app_cache)

        # プリントサーバコントローラが作成したrequest_dataをログ出力する
        $PRClog.debug("PrintServerMainController") {"プリントサーバコントローラが作成したrequest_data : #{JSON.dump(request_data)}"}

        # プリントサーバメインモデルを呼び出す
        sql_data  = @rmenu_main_model.call(request_data)

        # プリントサーバメインモデルが作成したsql_dataをログ出力する
        $PRClog.debug("PrintServerMainController") {"モデルが作成したsql_data : #{JSON.dump(sql_data)}"}

        # プリントサーバメインビューのcallを実行し、フォームデータを取得する
        response_data     = @rmenu_main_view.call(request_data, sql_data)

        # ビューが作成したレスポンスをログ出力する
        $PRClog.debug("PrintServerMainController") {"ビューが作成したレスポンスデータ : #{JSON.dump(response_data)}"}

        # PDF コントローラ　スタート
        $PRClog.debug("PrintServerMainController") {"PDF コントローラ　スタート"}
				
        if num == 1
          pdfController = RmenuPdfController.new("pdfcontroller")
          pdfController.start(response_data, sql_data, request_data)
          pdfController.printHeader(response_data, sql_data, request_data)
        end

        pdfController.call(response_data, sql_data, request_data)

        if num == dataSize
          pdfController.printFooter(response_data, sql_data, request_data)
          response_data = pdfController.terminate(response_data, sql_data, request_data)            # 新しくレスポンスデータを作成
        end
				
        # PDF コントローラ　エンド
        $PRClog.debug("PrintServerMainController") {"PDF コントローラ　エンド"}
      end

      # メイン処理 終了ログを出力する
      $PRClog.debug("PrintServerMainController") {"call normal end"}                                # Logファイル Debug用
      return response_data
    rescue
      # メイン処理 エラーログを出力する
      $PRClog.error("PrintServerMainController") {"call exception: #{$@}"}                          # Logファイル Debug用
    end
  end

  # コントローラ接続完了
  def readyGo
    puts "MainController connect OK"
    $PRClog.debug("PrintServerMainController") {"MainController connect OK"}                        # Logファイル Debug用
  end
end

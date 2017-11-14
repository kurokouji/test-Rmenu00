# coding: UTF-8

require 'rubygems'
require 'json'
require 'RmenuMainController'
require 'RmenuMainModel'
require 'RmenuMainView'
require 'RmenuFilePathMixin'

class RmenuBatchStartup
  include RmenuFilePathMixin

  def initialize(file_path, output_path=nil)
  
    # トランザクションファイルのパスを設定する
    @tran_filepath = file_path
    
    # 結果出力ファイルのパスを設定する
    # 省略されている場合は、トランザクションファイルのパスより生成
    if output_path then
      @output_filepath = output_path
    else
      @output_filepath = file_path.sub(/.json/, '.txt')
    end
    
  end
  
  def call()
    begin
      # モデルのインスタンス
      rmenu_main_model = RmenuMainModel.new("model")

      # ビューのインスタンス
      rmenu_main_view = RmenuMainView.new("view")

      # コントローラのインスタンス
      rmenu_main_controller = 
        RmenuMainController.new("controller", rmenu_main_model, rmenu_main_view)

      # トランザクションデータを読込む（JSON文字列）
      tran_data = readFile(@tran_filepath)
    
      # json文字列（トランザクションデータ）をHashに変換する
      tran_hash = JSON.load(tran_data)

      # リクエストデータを取得する
      request_data = tran_hash["request"]
    
      # コントローラのcallを実行し、レスポンスデータを取得する
      response_data = rmenu_main_controller.call(request_data)

      # レスポンスデータをトランザクションデータに設定する
      tran_hash["response"] = response_data

      # トランザクションデータ（Hashオブジェクト）をJSON文字列に変換する
      tran_data = JSON.dump(tran_hash)

      # トランザクションデータを書き込む
      writeFile(@output_filepath, tran_data)
    rescue => ex
      puts ex.message
    end
  end
end


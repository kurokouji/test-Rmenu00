# coding: UTF-8

$LOAD_PATH.push(File.dirname(__FILE__))

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'drb'                                                                   # dRubyライブラリを読みこむ
require 'RmenuMainController'
require 'RmenuMainModel'
require 'RmenuMainView'

if __FILE__ == $0
  begin
    # モデルのインスタンス
    if $Rconfig["controller_uri"] == $Rconfig["model_uri"]
      rmenu_main_model = RmenuMainModel.new("model")
    else
      rmenu_main_model = DRbObject.new_with_uri($Rconfig["model_uri"])
      rmenu_main_model.readyGo()
    end

    # ビューのインスタンス
    if $Rconfig["controller_uri"] == $Rconfig["view_uri"]
      rmenu_main_view = RmenuMainView.new("view")
    else
      rmenu_main_view = DRbObject.new_with_uri($Rconfig["view_uri"])
      rmenu_main_view.readyGo()
    end

    # コントローラのインスタンス
    rmenu_main_controller = 
      RmenuMainController.new("controller", rmenu_main_model, rmenu_main_view)
	
    # コントローラの公開
    DRb.start_service($Rconfig["controller_uri"], rmenu_main_controller)
    puts DRb.uri
    puts "MainController ready"
    DRb.thread.join          # joinが有ることで、メインスレッドが終了しない
  rescue => error
    puts error
  end
end

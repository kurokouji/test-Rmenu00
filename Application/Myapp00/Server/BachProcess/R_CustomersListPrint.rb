# coding: UTF-8

require "rbconfig"

osn    = RbConfig::CONFIG["target_os"].downcase
osname = osn =~ /mswin(?!ce)|mingw|cygwin|bccwin/ ? "win" : (osn =~ /linux/ ? "linux" : "other")

if osname == "win"
  $LOAD_PATH.push("C:/RmenuSVN3/Rmenu/System/Server/Libraries/Main/")
else
  $LOAD_PATH.push("/home/rmenu_user/Rmenu/System/Server/Libraries/Main/")
end

require 'RmenuConfig'                                       # 設定情報を読みこむ
require 'RmenuBatchStartup'                                 # テストラン用コントローラ

def main
  begin
    # 設備台帳　起動トランザクションのファイルパスを設定する
    file_path = $Rconfig['base_application'] + "/Myapp00/Json/Apps/BatchStartR_CustomersListPrint/BatchStartR_CustomersListPrint_startup_tran.json"
    out_path  = $Rconfig['base_application'] + "/Myapp00/Server/BachProcess/R_CustomersListPrint_result.txt"

    # バッチ起動用コントローラのインスタンス
    batch_run = RmenuBatchStartup.new(file_path, out_path)

    # テストランの実行
    batch_run.call()
  end
end

main

# coding: UTF-8

require "rbconfig"

class RmenuConfig
osn = RbConfig::CONFIG["target_os"].downcase
@@os = osn =~ /mswin(?!ce)|mingw|cygwin|bccwin/ ? "win" : (osn =~ /linux/ ? "linux" : "other")

#
# ベースURL設定
#
$Rconfig = Hash.new
$Rconfig['os']                  = @@os
if @@os == "win"
  $Rconfig['base_url']          = "http//127.0.0.1:9292/RmenuSVN/Rmenu"
  $Rconfig['base_systempath']   = "C:/RmenuSVN3/Rmenu/System"
  $Rconfig['base_serverpath']   = "C:/RmenuSVN3/Rmenu/System/Server"
  $Rconfig['base_htmlpath']     = "C:/RmenuSVN3/Rmenu/System/Html"
  $Rconfig['base_application']  = "C:/RmenuSVN3/Rmenu/Application"
else
  $Rconfig['base_url']          = "http://192.168.0.123/rmenu_user/"
  $Rconfig['base_systempath']   = "/home/rmenu_user/Rmenu/System"
  $Rconfig['base_serverpath']   = "/home/rmenu_user/Rmenu/System/Server"
  $Rconfig['base_htmlpath']     = "/home/rmenu_user/Rmenu/System/Html"
  $Rconfig['base_application']  = "/home/rmenu_user/Rmenu/Application"
end


#
# 実行モード
# 本番：""  || 開発："develop"
#
$Rconfig['run_mode']          = "develop"

#
# マルチユーザ環境時のユーザ名
# シングルユーザ環境の場合は空文字列にしておく
#
if @@os == "win"
  $Rconfig['multi_user_name']   = ""
else
  $Rconfig['multi_user_name']   = "rmenu_user"
end

#
# ライブラリーPATH 設定
#
$Rconfig['jsons_path']        = $Rconfig['base_application']
$Rconfig['apps_path']         = $Rconfig['base_application']
$Rconfig['editor_path']       = $Rconfig['base_systempath']   + "/Editor"
$Rconfig['session_path']      = $Rconfig['base_htmlpath']     + "/session"
$Rconfig['libs_path']         = $Rconfig['base_serverpath']   + "/Libraries"
$Rconfig['logs_path']         = $Rconfig['base_serverpath']   + "/Logs"

# Rmenu ドキュメント用
$Rconfig['docs_path']         = $Rconfig['base_application'].sub("Rmenu","rmenuDocs")

dbopts  = Array.new
#
# setubi DB 設定
#
dbopts0 = Hash.new
dbopts0['db_dbdriver']        = "PostgreSQL"
dbopts0['db_hostname']        = "127.0.0.1"
dbopts0['db_portno']          = 5432
dbopts0['db_database']        = "setubi"
dbopts0['db_username']        = "postgres"
dbopts0['db_password']        = "password"
dbopts0['db_encoding']        = "utf8"
dbopts0['db_compress']        = false
dbopts[0]                     = dbopts0

#
# rmenusales DB 設定
#
dbopts1 = Hash.new
dbopts1['db_dbdriver']        = "PostgreSQL"
dbopts1['db_hostname']        = "127.0.0.1"
dbopts1['db_portno']          = 5432
dbopts1['db_database']        = "rmenusales"
dbopts1['db_username']        = "postgres"
dbopts1['db_password']        = "password"
dbopts1['db_encoding']        = "utf8"
dbopts1['db_compress']        = false
dbopts[1]                     = dbopts1

#
# flowershop DB 設定
#
dbopts2 = Hash.new
dbopts2['db_dbdriver']        = "PostgreSQL"
dbopts2['db_hostname']        = "127.0.0.1"
dbopts2['db_portno']          = 5432
dbopts2['db_database']        = "flowershop"
dbopts2['db_username']        = "postgres"
dbopts2['db_password']        = "password"
dbopts2['db_encoding']        = "utf8"
dbopts2['db_compress']        = false
dbopts[2]                     = dbopts2

#
# rmenuvisualtools DB 設定
#
dbopts3 = Hash.new
dbopts3['db_dbdriver']        = "PostgreSQL"
dbopts3['db_hostname']        = "127.0.0.1"
dbopts3['db_portno']          = 5432
dbopts3['db_database']        = "rmenuvisualtools"
dbopts3['db_username']        = "postgres"
dbopts3['db_password']        = "password"
dbopts3['db_encoding']        = "utf8"
dbopts3['db_compress']        = false
dbopts[3]                     = dbopts3

#
# skeleton DB 設定
#
dbopts4 = Hash.new
dbopts4['db_dbdriver']        = "PostgreSQL"
dbopts4['db_hostname']        = "127.0.0.1"
dbopts4['db_portno']          = 5432
dbopts4['db_database']        = "skeleton"
dbopts4['db_username']        = "postgres"
dbopts4['db_password']        = "password"
dbopts4['db_encoding']        = "utf8"
dbopts4['db_compress']        = false
dbopts[4]                     = dbopts4


$Rconfig['db_tool']           = "Sequel"
$Rconfig['db_pools']          = 0
$Rconfig['db_options']        = dbopts

#
# コントローラ・モデル・ビューの公開URi設定
# MVCが各々別プロセスとして起動させる時、各々のIPアドレス・ポートを指定する。
# 全て同じIPアドレス・ポートの時は、同一プロセスとして起動する。
#
$Rconfig['controller_uri']    = "druby://localhost:12345"
$Rconfig['model_uri']         = "druby://localhost:12345"
$Rconfig['view_uri']          = "druby://localhost:12345"
$Rconfig['printserver_uri']   = "druby://localhost:12347"

#
# タプルスペースの公開URi設定
#
$Rconfig['tuplespace_uri']    = "druby://localhost:12349"

#
# ロード方法
# TYPE = static   プログラム変更は不可。サーバ再立ち上げ後、修正を反映
#      = dynamic  プログラム変更は可能。修正後最初の実行で即反映
#      = file     FILEからロード（テスト用）
$Rconfig['load_type']         = "file"

#
# ログの設定
# Level = FATAL   プログラムをクラッシュさせるような対処不可能なエラー
#       = ERROR   対処可能なエラー
#       = WARN    警告
#       = INFO    一般的な情報 
#       = DEBUG   開発者用の低レベルな情報 
#$Rconfig['logger_level']      = "FATAL"
#$Rconfig['logger_level']      = "ERROR"
#$Rconfig['logger_level']      = "WARN"
#$Rconfig['logger_level']      = "INFO"
$Rconfig['logger_level']      = "DEBUG"
#$Rconfig['logger_level']      = "WARN"

#
# ライブラリー読込みPATH 設定
#
$LOAD_PATH.push($Rconfig['base_serverpath'])
$LOAD_PATH.push($Rconfig['jsons_path'])
$LOAD_PATH.push($Rconfig['libs_path'])
$LOAD_PATH.push($Rconfig['libs_path'] + "/Controllers")
$LOAD_PATH.push($Rconfig['libs_path'] + "/Models")
$LOAD_PATH.push($Rconfig['libs_path'] + "/Views")
$LOAD_PATH.push($Rconfig['libs_path'] + "/Database")
$LOAD_PATH.push($Rconfig['libs_path'] + "/Modules")
$LOAD_PATH.push($Rconfig['libs_path'] + "/Commons")
$LOAD_PATH.push($Rconfig['libs_path'] + "/ParallelServer")
$LOAD_PATH.push($Rconfig['libs_path'] + "/TupleSpace")
$LOAD_PATH.push($Rconfig['libs_path'] + "/TupleServer")
$LOAD_PATH.push($Rconfig['libs_path'] + "/TupleClient")
$LOAD_PATH.push($Rconfig['libs_path'] + "/PrintServer")
$LOAD_PATH.push($Rconfig['libs_path'] + "/TestRun")
$LOAD_PATH.push($Rconfig['libs_path'] + "/JsonEditor")


#
# 個別システム用ライブラリー読込みPATH 設定
#
$LOAD_PATH.push($Rconfig['libs_path'] + "/Validation")                         # 標準バリデーションモジュール


#
# 設定終り
#
end

# coding: UTF-8
require "rbconfig"
require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する

class R_MasterUpload_model
  include RmenuJsonMixin

  def initialize(rmenu_db, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("R_MasterUpload_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_db       = rmenu_db
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("R_MasterUpload_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("R_MasterUpload_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # テーブル　クリア
  def clearMyapp00Table(tablename)
      $Mlog.debug("R_MasterUpload_model") {"clearMyapp00Table start"}                  # Logファイル Debug用

    str_sql    = "TRUNCATE TABLE "
    str_sql   += tablename

    $Mlog.debug("R_MasterUpload_model") {"clearMyapp00Table doSQL : #{str_sql}"}     # Logファイル Debug用
    @rmenu_db["default"].doRun(str_sql)

      $Mlog.debug("R_MasterUpload_model") {"clearMyapp00Table end"}                    # Logファイル Debug用
    return "OK"
  end

  # テーブル　クリア
  def copyMyapp00Table(tablename)
      $Mlog.debug("R_MasterUpload_model") {"copyMyapp00Table start"}                  # Logファイル Debug用

    request_record  = @request_data["records"][0]["record"]
    csvfilename     = request_record["マスターファイル名称"]["value"][0]

    filebasename = File.basename(csvfilename)

      $Mlog.debug("R_MasterUpload_model") {"csvfilename : #{csvfilename}"}     # Logファイル Debug用
      $Mlog.debug("R_MasterUpload_model") {"filebasename : #{filebasename}"}     # Logファイル Debug用


    osn = RbConfig::CONFIG["target_os"].downcase
    osname = osn =~ /mswin(?!ce)|mingw|cygwin|bccwin/ ? "win" : (osn =~ /linux/ ? "linux" : "other")

    if osname == "win"
      str_sql    = "COPY "
      str_sql   += tablename
      str_sql   += " FROM "
      str_sql   += "\'"
      str_sql   += $Rconfig["apps_path"]
      str_sql   += "/"
      str_sql   += csvfilename
      str_sql   += "\'"
      str_sql   += "  WITH encoding \'SJIS\' CSV"
    else
  # csvファイルを　postgres にアクセス可能にするため　/usr/share/rmenu/ を共有フォルダとして使用する
  # /usr/share/rmenu/ を作成しrmenu_userは書込み可に設定すること

      src_path = $Rconfig["apps_path"] + "/Myapp00/UpLoad/Apps/R_MasterUpload/"
      src  = [
        src_path + filebasename
      ]
      $Mlog.debug("R_MasterUpload_model") {"src : #{src}"}     # Logファイル Debug用

      dest = "/usr/share/rmenu/"
      FileUtils.cp(src, dest)

      $Mlog.debug("R_MasterUpload_model") {"csvfilename : #{csvfilename}"}     # Logファイル Debug用

      str_sql    = "COPY "
      str_sql   += tablename
      str_sql   += " FROM "
      str_sql   += "\'"
      str_sql   += "/usr/share/rmenu/" + filebasename
      str_sql   += "\'"
      str_sql   += "  WITH encoding \'SJIS\' CSV"
    end

      $Mlog.debug("R_MasterUpload_model") {"copyMyapp00Table doSQL : #{str_sql}"}     # Logファイル Debug用
    @rmenu_db["default"].doRun(str_sql)

      $Mlog.debug("R_MasterUpload_model") {"copyMyapp00Table end"}                    # Logファイル Debug用
    return "OK"
  end

  # インデックスを削除
  def dropMyapp00Index(indexname)
      $Mlog.debug("R_MasterUpload_model") {"dropMyapp00Index start"}                  # Logファイル Debug用

    str_sql    = "DROP INDEX "
    str_sql   += indexname
    str_sql   += " CASCADE"

      $Mlog.debug("R_MasterUpload_model") {"dropMyapp00Index doSQL : #{str_sql}"}     # Logファイル Debug用
    @rmenu_db["default"].doRun(str_sql)

      $Mlog.debug("R_MasterUpload_model") {"dropMyapp00Index end"}                    # Logファイル Debug用
    return "OK"
  end


end

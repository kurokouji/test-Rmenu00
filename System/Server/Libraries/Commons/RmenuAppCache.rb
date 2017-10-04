# coding: UTF-8

require "monitor"
require "RmenuFilePathMixin"
require "zlib"

class RmenuAppCache
  include MonitorMixin
  include RmenuFilePathMixin

  def initialize(type)
    super()
    @type           = type                                            # controller.rb or model.rb or view.rb or form.rb

    if $Rconfig['load_type'] != "file"
      @app_cache    = Hash.new
      @zipper       = Zlib::Deflate.new(Zlib::BEST_COMPRESSION)
      @unzipper     = Zlib::Inflate.new
    end
  end

  # アプリファイルのデータをキャッシュする
  def createCache()
    return if $Rconfig['load_type'] == "file"

    createHash($Rconfig['apps_path'])
  end

  def createHash(path)
    if File.directory?(path)
    dir           = Dir.open(path)
      while name = dir.read
        next if name == "."
        next if name == ".."

        createHash(path + "/" + name)                                 # 再帰呼び出し
      end
      dir.close
    else
      if path.include?@type
        filedata    = readFile(path)                                  # RmenuFilePathMixin
        zipdata     = @zipper.deflate(filedata, Zlib::FINISH)

        path_array  = path.split(/\//)
        idx         = path_array.length - 1
        key         = path_array[idx]
        if $Rconfig['load_type'] == "static"
          @app_cache[key] = zipdata
        else
          updatetime = File.stat(path).mtime
          @app_cache[key] = {data: zipdata, time: updatetime}
        end
      end
    end
  end

  # アプリデータを取得する
  def getAppData(data)
    case $Rconfig['load_type']
    when "static"
      name          = data["html"]
      app_data      = getStaticData(name)
    when "dynamic"
      name          = data["html"]
      file_path     = getAppsPath(@type, data)                        # RmenuFilePathMixin
      app_data      = getDynamicData(name, file_path)
    else
      file_path     = getAppsPath(@type, data)                        # RmenuFilePathMixin
      app_data      = getFileData(file_path)
    end

    return app_data
  end

  # load_type = static の処理
  def getStaticData(name)
    @unzipper << @app_cache[name]
    return  @unzipper.inflate(nil)
  end

  # load_type = dynamic の処理（ファイル更新日時を判定する）
  def getDynamicData(name, file_path)
    updatetime      = File.stat(file_path).mtime

    if updatetime == @app_cache[name]["time"]
      @unzipper << @app_cache[name]["data"]
      return  @unzipper.inflate(nil)
    else
      synchronize do
        file_data   = readFile(file_path)                             # RmenuFilePathMixin
        zip_data    = @zipper.deflate(file_data, Zlib::FINISH)
        @app_cache[name] = {data: zip_data, time: updatetime}
        return file_data
      end
    end
  end

  # load_type = file の処理
  def getFileData(file_path)
    synchronize do
      file_data     = readFile(file_path)                             # RmenuFilePathMixin
      return file_data
    end
  end

  # コントローラクラスを動的インスタンス
  def getControllerObject(request_data, validation_data)
    # コントローラクラスの有無を判定
    return nil unless request_data.has_key?("prog")
    return nil     if request_data["prog"] == "no"

    # コントローラプログラム（項目チェック）ファイルを読み込む
    app_data        = getAppData(request_data)
    folder_name     = getFolderName(request_data)                     # RmenuFilePathMixin
    file_name       = folder_name + "_controller.rb"
    eval(app_data, binding, file_name, 1)

    # コントローラオブジェクトを動的生成
    app_object      = folder_name       + 
                      "_controller"     +
                      ".new(request_data, validation_data)"
    return eval(app_object)                                           # コントローラオブジェクト
  end

  # モデルクラスを動的インスタンス
  def getModelObject(rmenu_dbi, sql_data, request_data)
    # モデルクラスの有無を判定
    return nil unless sql_data.has_key?("prog")
    return nil     if sql_data["prog"] == "no"

    # モデルプログラムファイルを読み込む
    app_data        = getAppData(sql_data)
    folder_name     = getFolderName(sql_data)                         # RmenuFilePathMixin
    file_name       = folder_name + "_model.rb"
    eval(app_data, binding, file_name, 1)

    # モデルオブジェクトを動的生成
    app_object      = folder_name       + 
                      "_model"          +
                      ".new(rmenu_dbi, sql_data, request_data)"
    return eval(app_object)                                           # 画面用モデルオブジェクト
  end

  # ビュークラスを動的インスタンス
  def getViewObject(response_data, sql_data, request_data)
    # ビュークラスの有無を判定
    return nil unless response_data.has_key?("prog")
    return nil     if response_data["prog"] == "no"

    # ビュープログラムファイルを読み込む
    app_data        = getAppData(response_data)
    folder_name     = getFolderName(response_data)                    # RmenuFilePathMixin
    file_name       = folder_name + "_view.rb"
    eval(app_data, binding, file_name, 1)

    # ビューオブジェクトを動的生成
    app_object      = folder_name        + 
                      "_view"            +
                      ".new(response_data, sql_data, request_data)"
    #@temp_object    = eval(app_object)                                # ビューオブジェクト
    return eval(app_object)                                           # ビューオブジェクト
  end

  # プリントコントローラクラスを動的インスタンス
  def getPrintServerControllerObject(request_data)
    # プリントコントローラクラスの有無を判定
    return nil unless request_data.has_key?("prog")
    return nil     if request_data["prog"] == "no"

    # プリントコントローラプログラムファイルを読み込む
    app_data        = getAppData(request_data)
    folder_name     = getFolderName(request_data)                     # RmenuFilePathMixin
    file_name       = folder_name + "_controller.rb"
    eval(app_data, binding, file_name, 1)

    # コントローラオブジェクトを動的生成
    app_object      = folder_name       + 
                      "_controller"     +
                      ".new(request_data)"
    return eval(app_object)                                           # プリントコントローラオブジェクト
  end

  # フォームクラスを動的インスタンス
  def getFormObject(pdfcreate, response_data, sql_data, request_data)
    # フォームクラスの有無を判定
    return nil unless response_data["pdfinfo"].has_key?("prog")
    return nil     if response_data["pdfinfo"]["prog"] == "no"

    # フォームプログラムファイルを読み込む
    app_data        = getAppData(response_data)
    folder_name     = getFolderName(response_data)                    # RmenuFilePathMixin
    file_name       = folder_name + "_form.rb"
    eval(app_data, binding, file_name, 1)

    # フォームオブジェクトを動的生成
    app_object      = folder_name       + 
                      "_form"           +
                      ".new(pdfcreate, response_data, sql_data, request_data)"
    return eval(app_object)                                           # フォームオブジェクト
  end
end

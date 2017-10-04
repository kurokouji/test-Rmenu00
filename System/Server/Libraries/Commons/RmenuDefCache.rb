# coding: UTF-8

require 'rubygems'
require 'json'
require "monitor"
require "RmenuFilePathMixin"
require "zlib"

class RmenuDefCache
  include MonitorMixin
  include RmenuFilePathMixin

  def initialize(type)
    super()
    @type           = type                                  # validation.json or sql.json or tran.json or form.json

    if $Rconfig['load_type'] != "file"
      @def_cache    = Hash.new
      @zipper       = Zlib::Deflate.new(Zlib::BEST_COMPRESSION)
      @unzipper     = Zlib::Inflate.new
    end
  end

  # 設定ファイルのデータをキャッシュする
  def createCache()
    return if $Rconfig['load_type'] == "file"

    createHash($Rconfig['jsons_path'])
  end

  def createHash(path)
    if File.directory?(path)
      dir           = Dir.open(path)
      while name = dir.read
        next if name == "."
        next if name == ".."

        createHash(path + "/" + name)                       # 再帰呼び出し
      end
      dir.close
    else
      if path.include?@type
        filedata    = readFile(path)                        # RmenuFilePathMixin
        zipdata     = @zipper.deflate(filedata, Zlib::FINISH)

        path_array  = path.split(/\//)
        idx         = path_array.length - 1
        key         = path_array[idx]
        if $Rconfig['load_type'] == "static"
          @def_cache[key] = zipdata
        else
          updatetime = File.stat(path).mtime
          @def_cache[key] = {data: zipdata, time: updatetime}
        end
      end
    end
  end

  # 設定データを取得する
  def getJsonData(data)
    case $Rconfig['load_type']
    when "static"
      name          = data["html"]
      json_data     = getStaticData(name)
    when "dynamic"
      name          = data["html"]
      file_path     = getJsonsPath(@type, data)             # RmenuFilePathMixin
      json_data     = getDynamicData(name, file_path)
    else
      file_path     = getJsonsPath(@type, data)             # RmenuFilePathMixin
      json_data     = getFileData(file_path)
    end

    return JSON.load(json_data)                             # json文字列をハッシュに変換
  end

  # load_type = static の処理
  def getStaticData(name)
    @unzipper << @def_cache[name]
    return  @unzipper.inflate(nil)
  end

  # load_type = dynamic の処理（ファイル更新日時を判定する）
  def getDynamicData(name, file_path)
    updatetime      = File.stat(file_path).mtime

    if updatetime == @def_cache[name]["time"]
      @unzipper << @def_cache[name]["data"]
      return  @unzipper.inflate(nil)
    else
      synchronize do
        file_data   = readFile(file_path)                   # RmenuFilePathMixin
        zip_data    = @zipper.deflate(file_data, Zlib::FINISH)
        @def_cache[name] = {data: zip_data, time: updatetime}
        return file_data
      end
    end
  end

  # load_type = file の処理
  def getFileData(file_path)
    synchronize do
      file_data     = readFile(file_path)                   # RmenuFilePathMixin
      return file_data
    end
  end

end


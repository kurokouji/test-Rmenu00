# coding: UTF-8

module RmenuFilePathMixin
  # type・・・validation.json or sql.json or tran.json
  # data・・・request_data or sql_data or response_data
  def getJsonsPath(type, data)
    temp_path = $Rconfig['jsons_path'] + "/" + data["html"] + "/"     # ディレクトリーパスの設定

    name_array = data["html"].split(/\//)
    array_size = name_array.size
    jsons_path = temp_path + name_array[array_size - 1] + "_"         # ファイル名の設定

    if (type == "sql.json") || (type == "tran.json")
      jsons_path += data["mode"] + "_"
    end
    
    return jsons_path + type
  end

  # type・・・controller.rb or model.rb or view.rb
  # data・・・request_data or sql_data or response_data
  def getAppsPath(type, data)
    temp_path = $Rconfig['apps_path'] + "/" + data["html"] + "/"      # ディレクトリパスの設定

    name_array = data["html"].split(/\//)
    array_size = name_array.size
    apps_path = temp_path + name_array[array_size - 1] + "_" + type   # ファイル名の設定

    # JsonディレクトリをServerディレクトリに置換する
    apps_path.sub!("Json", "Server")
    return apps_path
  end

  # フォルダー名を取得
  def getFolderName(data)
    folder_name = ""
    if data["html"].include?("/")
      name_array = data["html"].split(/\//)
      array_size = name_array.size
      folder_name = name_array[array_size - 1]              # フォルダー名
    else
      folder_name = data["html"]                            # フォルダー名
    end
    return folder_name
  end

  # ファイル名（パス情報含む）を使用してJson・Appファイルを取得
  def readFile(file_name)
    begin
      file = File.open(file_name, "r:UTF-8")
      data = file.read
      file.close

      return data.force_encoding("UTF-8")
    rescue Exception
      puts Exception.message
    end
  end

  # ファイル名（パス情報含む）を使用してファイルを読み込み、配列に格納する
  def readlinesFile(file_name)
    begin
      file = File.open(file_name, "r:UTF-8")
      arraydata = file.readlines
      file.close

      return arraydata
    rescue Exception
      puts Exception.message
    end
  end

  # ファイル名（パス情報含む）を使用してファイルを出力する
  def writeFile(file_name, data)
    begin
      file = File.open(file_name, "w:UTF-8")
      file.write(data)
      file.close
    rescue Exception
      puts Exception.message
    end
  end

  # ファイル名（パス情報含む）を使用してファイルを出力する
  def writeCodeFile(file_name, data, outcode)
    begin
      file = File.open(file_name, "w:#{outcode}")
      file.write(data)
      file.close
    rescue Exception
      puts Exception.message
    end
  end

end
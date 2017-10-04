# coding: UTF-8

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'RmenuLoggerMixin'
require 'RmenuJsonEditorMixin'
require 'json'

class RmenuJsonDatasetEditor
  include RmenuLoggerMixin
  include RmenuJsonEditorMixin

  def initialize(log_file_name)
    $Jlog               = createLogger(log_file_name)                           # controller用ログの作成

    begin
      # initialize 開始ログを出力する
      $Jlog.debug("JsonDatasetEditor") {"initialize start"}                     # Logファイル Debug用

      # CSVファイルから作成した二次元配列データ
      @twoarray     = Array.new

      # 生成されるJSONデータ
      @rmenujson    = Hash.new("")
      @rmenujsonStr = ""

      # initialize 終了ログを出力する
      $Jlog.debug("JsonDatasetEditor") {"initialize normal end"}                # Logファイル Debug用
    rescue
      # エラーログを出力する
      $Jlog.error("JsonDatasetEditor") {"initialize exception: #{$!}"}          # Logファイル Debug用
    end
  end

  def call(filename)
    begin
      $Jlog.debug("JsonDatasetEditor") {"call start"}                           # Logファイル Debug用

      # csvファイルの絶対パス・ファイル名を設定する
      csvpathname   = getCsvAbsolutePath(filename) + "_dataset.csv"             # RmenuJsonEditorMixin

      # csvファイルを読み配列を取得する
      $Jlog.debug("JsonDatasetEditor") {"call file name: #{csvpathname}"}       # Logファイル Debug用
      csvarray      = readlinesCsv(csvpathname)                                 # RmenuJsonEditorMixin

      # 二次元配列を作成する
      @twoarray     = createArray(csvarray)                                     # RmenuJsonEditorMixin
      $Jlog.debug("JsonDatasetEditor") {"call tow array: #{JSON.dump(@twoarray)}"}

      # 配列からJson用連想配列を作成する
      fromArraytoJsonHash(filename)
      $Jlog.debug("JsonDatasetEditor") {"call create Hash: #{JSON.dump(@rmenujson)}"}

      # Json用連想配列からJson文字列
      fromJsonHashtoJsonStr()

      # 出力先パス・ファイル名を設定する
      jsonpathname  = getJsonAbsolutePath(filename) + "_dataset.json"           # RmenuJsonEditorMixin
      $Jlog.debug("JsonDatasetEditor") {"call file name: #{jsonpathname}"}      # Logファイル Debug用

      # Json文字列をファイルに出力する
      writeFile(jsonpathname, @rmenujsonStr)                                    # RmenuFilePathMixin

      $Jlog.debug("JsonDatasetEditor") {"call normal end"}                      # Logファイル Debug用
    rescue
      # メイン処理 エラーログを出力する
      $Jlog.error("JsonDatasetEditor") {"call exception: #{$@}"}                # Logファイル Debug用
    end
  end


  # 配列からJson用連想配列を作成する
  def fromArraytoJsonHash(filename)
    # json作成の初期処理
    createHashStart(filename)

    i       = -1
    j       = 7
    maxsize = @twoarray.size
    while j < maxsize
      # ID欄に値が入っているか
      if @twoarray[j].size == 0
         j += 1
         next
      end

      if @twoarray[j][2].size > 1
        i += 1
        createHashRecords(i, j)
      end

      if @twoarray[j][4].size > 1
        createHashItem(i, j)
      end

      j += 1
    end

  end

  def createHashStart(filename)
    column     = @twoarray[1]

    @rmenujson["comment"]           = column[1]
    @rmenujson["html"]              = filename

    @rmenujson["message"]           = Hash.new("")
    @rmenujson["message"]["status"] = "OK"
    @rmenujson["message"]["msg"]    = "データを入力して、実行ボタンを押下して下さい。"

    @rmenujson["records"]           = Array.new
  end

  # 配列recordsを作成し、直下のタグを作成する
  def createHashRecords(i, j)
    column = @twoarray[j]

    @rmenujson["records"][i]                = Hash.new("")
    @rmenujson["records"][i]["comment"]     = column[9]
    @rmenujson["records"][i]["id"]          = column[1]
    @rmenujson["records"][i]["multiline"]   = column[2]
    @rmenujson["records"][i]["defaultline"] = column[3]
    @rmenujson["records"][i]["record"]      = Hash.new("")
  end

  # 項目タグを作成する
  def createHashItem(i, j)
    column = @twoarray[j]
    item   = column[4]

    @rmenujson["records"][i]["record"][item]             = Hash.new("")
    @rmenujson["records"][i]["record"][item]["value"]    = Array.new
    @rmenujson["records"][i]["record"][item]["value"][0] = ""
    @rmenujson["records"][i]["record"][item]["idx"]      = Array.new
    @rmenujson["records"][i]["record"][item]["idx"][0]   = ""
    @rmenujson["records"][i]["record"][item]["type"]     = column[5]
    @rmenujson["records"][i]["record"][item]["edit"]     = column[6]
    @rmenujson["records"][i]["record"][item]["size"]     = column[7]
    @rmenujson["records"][i]["record"][item]["align"]    = column[8]
  end

  # Jsonファイルを出力する
  def fromJsonHashtoJsonStr()
    @rmenujsonStr = "{\n"

    i = 0
    @rmenujson.each do |key, value|
      if i == 0
        @rmenujsonStr << "  "
      else
        @rmenujsonStr << " ,"
      end

      @rmenujsonStr << "\"#{key}\": "

      if key == "message"
        createJsonMessage(value)
        i += 1
        next
      end

      if key == "records"
        createJsonRecords(value)
        i += 1
        next
      end

      @rmenujsonStr << "\"#{value}\"\n"
      i += 1
    end

    @rmenujsonStr << "}\n"
  end

  # messageタグ
  def createJsonMessage(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "  {\n"

    i = 0
    value.each do |key, value_data|
      if i == 0
        @rmenujsonStr << "      "
      else
        @rmenujsonStr << "     ,"
      end

      @rmenujsonStr << "\"#{key}\": "
      @rmenujsonStr << "\"#{value_data}\"\n"
      i += 1
    end

    @rmenujsonStr << "  }\n\n"
  end

  # recordsタグ
  def  createJsonRecords(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "  [\n"

    record_count = 0
    value.each do |array_data|
      createJsonRecord(array_data, record_count)
      record_count += 1
    end

    @rmenujsonStr << "  ]\n"
  end

  # recordタグ
  def createJsonRecord(array_data, record_count)
    if record_count == 0
      @rmenujsonStr << "    {\n"
    else
      @rmenujsonStr << "   ,{\n"
    end

    i = 0
    array_data.each do |key, value|
      if i == 0
        @rmenujsonStr << "      "
      else
        @rmenujsonStr << "     ,"
      end

      @rmenujsonStr << "\"#{key}\": "

      if key == "record"
        createJsonItem(value)
        break
      end

      @rmenujsonStr << "\"#{value}\"\n"
      i += 1
    end

    @rmenujsonStr << "    }\n\n"
  end

  # 項目名タグ
  def createJsonItem(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "      {\n"

    i = 0
    value.each do |key, value_data|
      if i == 0
        @rmenujsonStr << "        "
      else
        @rmenujsonStr << "       ,"
      end

      @rmenujsonStr << "\"#{key}\":"
      createJsonItemChild(value_data)

      i += 1
    end

    @rmenujsonStr << "      }\n"
  end

  # 項目名タグ直下のタグ
  def createJsonItemChild(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "        {"

    i = 0
    value.each do |key, value_data|
      if i > 0
        @rmenujsonStr << ", "
      end

      @rmenujsonStr << "\"#{key}\": "
      if value_data.instance_of?(String)
        @rmenujsonStr << "\"#{value_data}\""
      elsif value_data.instance_of?(Array)
        @rmenujsonStr   << "["
        if value_data[0]
          @rmenujsonStr << "\"#{value_data[0]}\""
        end
        if value_data[1]
          @rmenujsonStr << ",\"#{value_data[1]}\""
        end
        @rmenujsonStr   << "]"
      else
        @rmenujsonStr << "\"\""
      end

      i += 1
    end

    @rmenujsonStr << "}\n"
  end

end

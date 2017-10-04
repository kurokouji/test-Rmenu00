# coding: UTF-8

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'RmenuLoggerMixin'
require 'RmenuJsonEditorMixin'
require 'json'

class RmenuJsonTranEditor
  include RmenuLoggerMixin
  include RmenuJsonEditorMixin

  def initialize(log_file_name)
    $Jlog               = createLogger(log_file_name)                           # controller用ログの作成

    begin
      # initialize 開始ログを出力する
      $Jlog.debug("JsonTranEditor") {"initialize start"}                        # Logファイル Debug用

      # CSVファイルから作成した二次元配列データ
      @twoarray     = Array.new

      # 生成されるJSONデータ
      @rmenujson    = Array.new
      @rmenujsonStr = ""

      @tran         = -1
      @tran_name    = Array.new
      @reqres       = ""

      # initialize 終了ログを出力する
      $Jlog.debug("JsonTranEditor") {"initialize normal end"}                   # Logファイル Debug用
    rescue
      # エラーログを出力する
      $Jlog.error("JsonTranEditor") {"initialize exception: #{$!}"}             # Logファイル Debug用
    end
  end

  def call(filename)
    begin
      $Jlog.debug("JsonTranEditor") {"call start"}                              # Logファイル Debug用

      # csvファイルの絶対パス・ファイル名を設定する
      csvpathname   = getCsvAbsolutePath(filename) + "_tran.csv"                # RmenuJsonEditorMixin

      # csvファイルを読み配列を取得する
      $Jlog.debug("JsonTranEditor") {"call file name: #{csvpathname}"}          # Logファイル Debug用
      csvarray      = readlinesCsv(csvpathname)                                 # RmenuJsonEditorMixin

      # 二次元配列を作成する
      @twoarray     = createArray(csvarray)                                     # RmenuJsonEditorMixin
      $Jlog.debug("JsonTranEditor") {"call tow array: #{JSON.dump(@twoarray)}"}

      # 配列からJson用配列を作成する
      fromArraytoJsonArray(filename)
      $Jlog.debug("JsonTranEditor") {"call create Hash size: : #{@rmenujson.size}"}
      $Jlog.debug("JsonTranEditor") {"call create Hash: #{JSON.dump(@rmenujson)}"}

      # Json用配列からJsonファイルを作成する
      fromJsonArraytoJsonStr(filename)

      $Jlog.debug("JsonTranEditor") {"call normal end"}                         # Logファイル Debug用
    rescue
      # メイン処理 エラーログを出力する
      $Jlog.error("JsonTranEditor") {"call exception: #{$@}"}                   # Logファイル Debug用
    end
  end


  # 配列からJson用連想配列を作成する
  def fromArraytoJsonArray(filename)
    i       = -1
    j       = 7
    maxsize = @twoarray.size
     while j < maxsize
      # ID欄に値が入っているか
      if @twoarray[j].size == 0
         j += 1
         next
      end

      if @twoarray[j][1].size > 1
        @tran += 1
        createHashTran(j)
      end

      if @twoarray[j][3].size > 1
        createHashReqRes(j, filename)

        i = -1
      end

      if @twoarray[j][4].size > 1
        i += 1
        createHashRecords(i, j)
      end

      if @twoarray[j][8].size > 1
        createHashItem(i, j)
      end

      j += 1
    end

  end

  # 配列Tranを作成し、直下のタグを作成する
  def createHashTran(j)
    column = @twoarray[j]

    @rmenujson[@tran]  = Hash.new("")
    @tran_name[@tran]  = column[1]
  end

  # 配列RequestResponseを作成し、直下のタグを作成する
  def createHashReqRes(j, filename)
    column = @twoarray[j]
    @reqres = column[3]

    @rmenujson[@tran][@reqres] = Hash.new("")

    createHashStart(j, filename)
  end

  def createHashStart(j, filename)
    column1    = @twoarray[1]
    column     = @twoarray[j]

    @rmenujson[@tran][@reqres]["comment"]           = column1[1]
    @rmenujson[@tran][@reqres]["ruser_id"]          = ""
    @rmenujson[@tran][@reqres]["timestamp"]         = ""
    @rmenujson[@tran][@reqres]["html"]              = filename
    @rmenujson[@tran][@reqres]["mode"]              = @tran_name[@tran]
    @rmenujson[@tran][@reqres]["prog"]              = "no"
    @rmenujson[@tran][@reqres]["model"]             = column[2]

    @rmenujson[@tran][@reqres]["message"]           = Hash.new("")
    @rmenujson[@tran][@reqres]["message"]["status"] = "OK"
    @rmenujson[@tran][@reqres]["message"]["msg"]    = "データを入力して、実行ボタンを押下して下さい。"
  end

  # 配列recordsを作成し、直下のタグを作成する
  def createHashRecords(i, j)
    column = @twoarray[j]

    # プログラム有無の判定
    if column[5].size > 1
      @rmenujson[@tran][@reqres]["prog"] = "yes"
    end
    if column[6].size > 1
      @rmenujson[@tran][@reqres]["prog"] = "yes"
    end

    if i == 0
      @rmenujson[@tran][@reqres]["records"]                 = Array.new
    end

    @rmenujson[@tran][@reqres]["records"][i]                = Hash.new("")
    @rmenujson[@tran][@reqres]["records"][i]["comment"]     = column[13]
    @rmenujson[@tran][@reqres]["records"][i]["id"]          = column[4]
    @rmenujson[@tran][@reqres]["records"][i]["before"]      = column[5]
    @rmenujson[@tran][@reqres]["records"][i]["after"]       = column[6]
    @rmenujson[@tran][@reqres]["records"][i]["multiline"]   = column[7]
    @rmenujson[@tran][@reqres]["records"][i]["record"]      = Hash.new("")
  end

  # 項目タグを作成する
  def createHashItem(i, j)
    column = @twoarray[j]
    item   = column[8]

    @rmenujson[@tran][@reqres]["records"][i]["record"][item]             = Hash.new("")
    @rmenujson[@tran][@reqres]["records"][i]["record"][item]["value"]    = Array.new
    @rmenujson[@tran][@reqres]["records"][i]["record"][item]["value"][0] = ""
    @rmenujson[@tran][@reqres]["records"][i]["record"][item]["fromtype"] = column[9]
    @rmenujson[@tran][@reqres]["records"][i]["record"][item]["fromid"]   = column[10]
    @rmenujson[@tran][@reqres]["records"][i]["record"][item]["fromio"]   = column[11]
    @rmenujson[@tran][@reqres]["records"][i]["record"][item]["fromname"] = column[12]
  end

  # Jsonファイルを出力する
  def fromJsonArraytoJsonStr(filename)

    i = 0
    @rmenujson.each do |value|
      @rmenujsonStr = ""
      fromJsonHashtoJsonStr(value)

      # 出力先パス・ファイル名を設定する
      jsonpathname  = getJsonAbsolutePath(filename)                             # RmenuJsonEditorMixin
      jsonpathname << "_" + "#{@tran_name[i]}" + "_tran.json"
      $Jlog.debug("JsonTranEditor") {"call json file name: #{jsonpathname}"}    # Logファイル Debug用

      # Json文字列をファイルに出力する
      writeFile(jsonpathname, @rmenujsonStr)                                    # RmenuFilePathMixin
      i += 1
    end

  end

  # request responseを出力する
  def fromJsonHashtoJsonStr(value)
    @rmenujsonStr << "{\n"

    i = 0
    value.each do |key, value_data|
      if i == 0
        @rmenujsonStr << "  "
      else
        @rmenujsonStr << " ,"
      end

      @rmenujsonStr << "\"#{key}\":\n"

      if key == "request"
        fromJsonHashtoJsonStr1(value_data)
        i += 1
        next
      end

      if key == "response"
        fromJsonHashtoJsonStr1(value_data)
        i += 1
        next
      end

      i += 1
    end

    @rmenujsonStr << "}\n"
  end

  # Jsonファイルを出力する
  def fromJsonHashtoJsonStr1(value)
    @rmenujsonStr << "  {\n"

    i = 0
    value.each do |key, value_data|
      if i == 0
        @rmenujsonStr << "    "
      else
        @rmenujsonStr << "   ,"
      end

      @rmenujsonStr << "\"#{key}\": "

      if key == "message"
        createJsonMessage(value_data)
        i += 1
        next
      end

      if key == "records"
        createJsonRecords(value_data)
        i += 1
        next
      end

      @rmenujsonStr << "\"#{value_data}\"\n"
      i += 1
    end

    @rmenujsonStr << "  }\n\n"
  end

  # messageタグ
  def createJsonMessage(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "    {\n"

    i = 0
    value.each do |key, value_data|
      if i == 0
        @rmenujsonStr << "        "
      else
        @rmenujsonStr << "       ,"
      end

      @rmenujsonStr << "\"#{key}\": "
      @rmenujsonStr << "\"#{value_data}\"\n"
      i += 1
    end

    @rmenujsonStr << "    }\n\n"
  end

  # recordsタグ
  def  createJsonRecords(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "    [\n"

    record_count = 0
    value.each do |array_data|
      createJsonRecord(array_data, record_count)
      record_count += 1
    end

    @rmenujsonStr << "    ]\n"
  end

  # recordタグ
  def createJsonRecord(array_data, record_count)
    if record_count == 0
      @rmenujsonStr << "      {\n"
    else
      @rmenujsonStr << "     ,{\n"
    end

    i = 0
    array_data.each do |key, value|
      if i == 0
        @rmenujsonStr << "        "
      else
        @rmenujsonStr << "       ,"
      end

      @rmenujsonStr << "\"#{key}\": "

      if key == "record"
        createJsonItem(value)
        break
      end

      @rmenujsonStr << "\"#{value}\"\n"
      i += 1
    end

    @rmenujsonStr << "      }\n\n"
  end

  # 項目名タグ
  def createJsonItem(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "        {\n"

    i = 0
    value.each do |key, value_data|
      if i == 0
        @rmenujsonStr << "          "
      else
        @rmenujsonStr << "         ,"
      end

      @rmenujsonStr << "\"#{key}\":"
      createJsonItemChild(value_data)

      i += 1
    end

    @rmenujsonStr << "        }\n"
  end

  # 項目名タグ直下のタグ
  def createJsonItemChild(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "          {"

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

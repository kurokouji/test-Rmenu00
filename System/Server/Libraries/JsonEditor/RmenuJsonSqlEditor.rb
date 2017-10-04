# coding: UTF-8

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'RmenuLoggerMixin'
require 'RmenuJsonEditorMixin'
require 'json'

class RmenuJsonSqlEditor
  include RmenuLoggerMixin
  include RmenuJsonEditorMixin

  def initialize(log_file_name)
    $Jlog               = createLogger(log_file_name)                           # controller用ログの作成

    begin
      # initialize 開始ログを出力する
      $Jlog.debug("JsonSqlEditor") {"initialize start"}                         # Logファイル Debug用

      # CSVファイルから作成した二次元配列データ
      @twoarray     = Array.new

      # 生成されるJSONデータ
      @rmenujson    = Array.new
      @rmenujsonStr = ""

      @tran         = -1
      @tran_name    = Array.new
      @inout        = ""

      # initialize 終了ログを出力する
      $Jlog.debug("JsonSqlEditor") {"initialize normal end"}                    # Logファイル Debug用
    rescue
      # エラーログを出力する
      $Jlog.error("JsonSqlEditor") {"initialize exception: #{$!}"}              # Logファイル Debug用
    end
  end

  def call(filename)
    begin
      $Jlog.debug("JsonSqlEditor") {"call start"}                               # Logファイル Debug用

      # csvファイルの絶対パス・ファイル名を設定する
      csvpathname   = getCsvAbsolutePath(filename) + "_sql.csv"                 # RmenuJsonEditorMixin

      # csvファイルを読み配列を取得する
      $Jlog.debug("JsonSqlEditor") {"call file name: #{csvpathname}"}           # Logファイル Debug用
      csvarray      = readlinesCsv(csvpathname)                                 # RmenuJsonEditorMixin

      # 二次元配列を作成する
      @twoarray     = createArray(csvarray)                                     # RmenuJsonEditorMixin
      $Jlog.debug("JsonSqlEditor") {"call tow array: #{JSON.dump(@twoarray)}"}

      # 配列からJson用配列を作成する
      fromArraytoJsonArray(filename)
      $Jlog.debug("JsonSqlEditor") {"call create Hash size: #{@rmenujson.size}"}
      $Jlog.debug("JsonSqlEditor") {"call create Hash: #{JSON.dump(@rmenujson)}"}

      # Json用配列からJsonファイルを作成する
      fromJsonArraytoJsonStr(filename)

      $Jlog.debug("JsonSqlEditor") {"call normal end"}                          # Logファイル Debug用
    rescue
      # メイン処理 エラーログを出力する
      $Jlog.error("JsonSqlEditor") {"call exception: #{$@}"}                    # Logファイル Debug用
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
        createHashTran(j, filename)

        i = -1
      end

      if @twoarray[j][2].size > 1
        i += 1
        createHashSqls(i, j)
      end

      if @twoarray[j][5].size > 1
        createHashSql(i, j)
      end

      if @twoarray[j][12].size > 1
        createHashInOut(i, j)
      end

      if @twoarray[j][14].size > 1
        createHashItem(i, j)
      end

      j += 1
    end

  end

  # 配列Tranを作成し、直下のタグを作成する
  def createHashTran(j, filename)
    column = @twoarray[j]

    @rmenujson[@tran]  = Hash.new("")
    @tran_name[@tran]  = column[1]

    createHashStart(j, filename)
  end

  # 配列sqlsを作成し、直前のタグを作成する
  def createHashStart(j, filename)
    column1    = @twoarray[1]
    column     = @twoarray[j]

    @rmenujson[@tran]["comment"]           = column1[1]
    @rmenujson[@tran]["ruser_id"]          = ""
    @rmenujson[@tran]["timestamp"]         = ""
    @rmenujson[@tran]["html"]              = filename
    @rmenujson[@tran]["mode"]              = @tran_name[@tran]
    @rmenujson[@tran]["prog"]              = "no"

    @rmenujson[@tran]["message"]           = Hash.new("")
    @rmenujson[@tran]["message"]["status"] = "OK"
    @rmenujson[@tran]["message"]["msg"]    = "データを入力して、実行ボタンを押下して下さい。"
  end

  # sqls直下のタグを作成する
  def createHashSqls(i, j)
    column = @twoarray[j]

    # プログラム有無の判定
    if column[3].size > 1
      @rmenujson[@tran]["prog"] = "yes"
    end
    if column[4].size > 1
      @rmenujson[@tran]["prog"] = "yes"
    end

    if i == 0
      @rmenujson[@tran]["sqls"]                 = Array.new
    end

    @rmenujson[@tran]["sqls"][i]                = Hash.new("")
    @rmenujson[@tran]["sqls"][i]["comment"]     = column[23]
    @rmenujson[@tran]["sqls"][i]["id"]          = column[2]
    @rmenujson[@tran]["sqls"][i]["before"]      = column[3]
    @rmenujson[@tran]["sqls"][i]["after"]       = column[4]
    @rmenujson[@tran]["sqls"][i]["sql"]         = Hash.new("")
  end

  # sql直下のタグを作成する
  def createHashSql(i, j)
    column     = @twoarray[j]

    @rmenujson[@tran]["sqls"][i]["sql"]["type"]             = column[5]
    @rmenujson[@tran]["sqls"][i]["sql"]["freesql"]          = column[6]

    @rmenujson[@tran]["sqls"][i]["sql"]["genesql"]          = Hash.new("")
    @rmenujson[@tran]["sqls"][i]["sql"]["genesql"]["dist"]  = column[8]
    @rmenujson[@tran]["sqls"][i]["sql"]["genesql"]["from"]  = column[7]
    @rmenujson[@tran]["sqls"][i]["sql"]["genesql"]["where"] = column[9]
    @rmenujson[@tran]["sqls"][i]["sql"]["genesql"]["order"] = column[10]
    @rmenujson[@tran]["sqls"][i]["sql"]["genesql"]["limit"] = column[11]
  end

  # in out直下のタグを作成する
  def createHashInOut(i, j)
    column     = @twoarray[j]
    @inout     = column[12]

    @rmenujson[@tran]["sqls"][i][@inout]                   = Hash.new("")
    @rmenujson[@tran]["sqls"][i][@inout]["multiline"]      = column[13]
    @rmenujson[@tran]["sqls"][i][@inout]["record"]         = Hash.new("")
  end

  # 項目タグを作成する
  def createHashItem(i, j)
    column = @twoarray[j]
    item   = column[14]

    @rmenujson[@tran]["sqls"][i][@inout]["record"][item]             = Hash.new("")
    @rmenujson[@tran]["sqls"][i][@inout]["record"][item]["value"]    = Array.new
    @rmenujson[@tran]["sqls"][i][@inout]["record"][item]["value"][0] = ""
    @rmenujson[@tran]["sqls"][i][@inout]["record"][item]["table"]    = column[15]
    @rmenujson[@tran]["sqls"][i][@inout]["record"][item]["field"]    = column[16]
    @rmenujson[@tran]["sqls"][i][@inout]["record"][item]["funct"]    = column[17]
    @rmenujson[@tran]["sqls"][i][@inout]["record"][item]["empty"]    = column[18]
    @rmenujson[@tran]["sqls"][i][@inout]["record"][item]["fromtype"] = column[19]
    @rmenujson[@tran]["sqls"][i][@inout]["record"][item]["fromid"]   = column[20]
    @rmenujson[@tran]["sqls"][i][@inout]["record"][item]["fromio"]   = column[21]
    @rmenujson[@tran]["sqls"][i][@inout]["record"][item]["fromname"] = column[22]
  end

  # Jsonファイルを出力する
  def fromJsonArraytoJsonStr(filename)

    i = 0
    @rmenujson.each do |value|
      @rmenujsonStr = ""
      fromJsonHashtoJsonStr(value)

      # 出力先パス・ファイル名を設定する
      jsonpathname  = getJsonAbsolutePath(filename)                             # RmenuJsonEditorMixin
      jsonpathname << "_" + "#{@tran_name[i]}" + "_sql.json"
      $Jlog.debug("JsonSqlEditor") {"call json file name: #{jsonpathname}"}    # Logファイル Debug用

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

      @rmenujsonStr << "\"#{key}\": "

      if key == "message"
        createJsonMessage(value_data)
        i += 1
        next
      end

      if key == "sqls"
        createJsonSqls(value_data)
        i += 1
        next
      end

      @rmenujsonStr << "\"#{value_data}\"\n"
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
        @rmenujsonStr << "    "
      else
        @rmenujsonStr << "   ,"
      end

      @rmenujsonStr << "\"#{key}\": "
      @rmenujsonStr << "\"#{value_data}\"\n"
      i += 1
    end

    @rmenujsonStr << "  }\n\n"
  end

  # sqlsタグ
  def  createJsonSqls(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "  [\n"

    sql_count = 0
    value.each do |array_data|
      createJsonSqlInoutOutput(array_data, sql_count)
      sql_count += 1
    end

    @rmenujsonStr << "  ]\n"
  end

  # SqlInoutOutputタグ
  def createJsonSqlInoutOutput(array_data, sql_count)
    if sql_count == 0
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

      if key == "sql"
        createJsonSql(value)
        i += 1
        next
      end

      if key == "input"
        createJsonInputOutput(value, "input")
        i += 1
        next
      end

      if key == "output"
        createJsonInputOutput(value, "output")
        i += 1
        next
      end

      @rmenujsonStr << "\"#{value}\"\n"
      i += 1
    end

    @rmenujsonStr << "    }\n\n"
  end

  # sqlタグ
  def createJsonSql(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "      {\n"

    i = 0
    value.each do |key, value_data|
      if i == 0
        @rmenujsonStr << "        "
      else
        @rmenujsonStr << "       ,"
      end

      @rmenujsonStr << "\"#{key}\": "

      if key == "genesql"
        createJsonGeneSql(value_data)
        break
      end

      @rmenujsonStr << "\"#{value_data}\"\n"
      i += 1
    end

    @rmenujsonStr << "      }\n\n"
  end

  # sqlタグ
  def createJsonGeneSql(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "        {\n"

    i = 0
    value.each do |key, value_data|
      if i == 0
        @rmenujsonStr << "          "
      else
        @rmenujsonStr << "         ,"
      end

      @rmenujsonStr << "\"#{key}\": "
      @rmenujsonStr << "\"#{value_data}\"\n"
      i += 1
    end

    @rmenujsonStr << "        }\n"
  end

  # input output タグ
  def createJsonInputOutput(value, io)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "      {\n"

    i = 0
    value.each do |key, value_data|
      if i == 0
        @rmenujsonStr << "        "
      else
        @rmenujsonStr << "       ,"
      end

      @rmenujsonStr << "\"#{key}\": "

      if key == "record"
        createJsonItem(value_data, io)
        break
      end

      @rmenujsonStr << "\"#{value_data}\"\n"
      i += 1
    end

    @rmenujsonStr << "      }\n\n"
  end

  # 項目名タグ
  def createJsonItem(value, io)
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
      if io == "input"
        createJsonItemChild_IN(value_data)
      else
        createJsonItemChild_OUT(value_data)
      end

      i += 1
    end

    @rmenujsonStr << "        }\n"
  end

  # 項目名タグ直下のタグ（INPUT用）
  def createJsonItemChild_IN(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "          {\n"

    i = 0
    value.each do |key, value_data|
      case key
      when "value"
        @rmenujsonStr << "            "
      when "funct"
        @rmenujsonStr << "\n           ,"
      when "empty"
        @rmenujsonStr << "\n           ,"
      when "fromtype"
        @rmenujsonStr << "\n           ,"
      else
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

    @rmenujsonStr << "\n          }\n"
  end

  # 項目名タグ直下のタグ（OUTPUT用）
  def createJsonItemChild_OUT(value)
    @rmenujsonStr << "\n"
    @rmenujsonStr << "          {\n"

    i = 0
    value.each do |key, value_data|
      case key
      when "value"
        @rmenujsonStr << "            "
      when "table"
        @rmenujsonStr << ", "
      when "field"
        @rmenujsonStr << ", "
      when "funct"
        @rmenujsonStr << "\n           ,"
      else
        next
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

    @rmenujsonStr << "\n          }\n"
  end

end

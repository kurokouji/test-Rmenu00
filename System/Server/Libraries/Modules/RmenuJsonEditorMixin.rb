# coding: UTF-8

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'RmenuFilePathMixin'

module RmenuJsonEditorMixin
  include RmenuFilePathMixin


  # TSVファイルの絶対パスを設定する
  def getCsvAbsolutePath(filename)
    temp_path = ""
    if filename.include?("Popup")
      temp_path = $Rconfig['editor_popup_path']
    else
      temp_path = $Rconfig['editor_path']
    end
    
    return temp_path + "/" + filename + "/" + filename
  end

  # CSVファイルを読み込み配列を返す
  def readlinesCsv(csvpathname)
    csvarray     = readlinesFile(csvpathname)                                   # RmenuFilePathMixin
    return csvarray
  end

  # 二次元配列を作成する
  def createArray(csvarray)
    twoarray = Array.new

    i = 0
    csvarray.each do |linedata|
      # 改行文字を取り除く
      utfdata     = linedata.force_encoding("UTF-8")
      newlinedata = utfdata.chomp

      # 区切り文字を指定し配列を作成する
      onearray = newlinedata.split(/\t/)

      # nullのデータに空文字を入れる
      maxsize = onearray.size
      j = 0
      while j < maxsize
        if !onearray[j]
           onearray[j] = ""
        end
        j += 1
      end

      twoarray[i] = onearray
      i += 1
    end

    return twoarray
  end

  # Jsonファイルの絶対パスを設定する
  def getJsonAbsolutePath(filename)
    temp_path = ""
    if filename.include?("Popup")
      temp_path = $Rconfig['jsons_popup_path']
    else
      temp_path = $Rconfig['jsons_path']
    end
    
    return temp_path + "/" + filename + "/" + filename
  end

  # カラムインデックス用ハッシュを作成する
  def getColumnIndex()
    columnIndex      = Hash.new

    columnIndex["A"] = 0
    columnIndex["B"] = 1
    columnIndex["C"] = 2
    columnIndex["D"] = 3
    columnIndex["E"] = 4
    columnIndex["F"] = 5
    columnIndex["G"] = 6
    columnIndex["H"] = 7
    columnIndex["I"] = 8
    columnIndex["J"] = 9
    columnIndex["K"] = 10
    columnIndex["L"] = 11
    columnIndex["M"] = 12
    columnIndex["N"] = 13
    columnIndex["O"] = 14
    columnIndex["P"] = 15
    columnIndex["Q"] = 16
    columnIndex["R"] = 17
    columnIndex["S"] = 18
    columnIndex["T"] = 19
    columnIndex["U"] = 20
    columnIndex["V"] = 21
    columnIndex["W"] = 22
    columnIndex["X"] = 23
    columnIndex["Y"] = 24
    columnIndex["Z"] = 25

    return columnIndex
  end
end

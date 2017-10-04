# -*- coding:utf-8 -*-
begin
    require 'rubygems'
rescue LoadError
end

require 'prawn'
require 'prawn/measurement_extensions'

module RmenuPdfMixin

  # 数字の後ろに単位を付与する
  def convUnit(value, *unit)
    if unit[0]
      convunit = unit[0]
    else
      convunit = @pointUnit
    end

		pos = "#{value}".index(".")
		if pos == 0
		  value = "0" + "#{value}"
		end
		
    case convunit
    when "mm"
      return "#{value}.mm"
    when "cm"
      return "#{value}.cm"
    else
      return "#{value}"
    end
  end

  # ページコントロール・出力コントロールでレコードを取得する
  def getRecordOfPageOutputControl(pagecontrol, outputcontrol, response_data)
    recordArray = Array.new()
    i           = 0

    response_data["records"].each do |record_info|
      if record_info["pdfinfo"]["pagecontrol"] != pagecontrol
        next
      end

      if record_info["pdfinfo"]["outputcontrol"] != outputcontrol
        if record_info["pdfinfo"]["outputcontrol"] != "all_page"
          next
        end
      end

      recordArray[i] = record_info
      i += 1
    end

    return recordArray
  end

  # レコードで項目定義されているか？
  def isItemOfRecord(recordArray)
    if recordArray.length == 0
      return false
    end

    recordArray[0].each do |item_info|
      return true
    end

    return false
  end

  # Prawnオブジェクト作成用のハッシュを作成する
  def createPrawnObjectOfHash(response_data)
    pageSize     = response_data["pdfinfo"]["pagesize"]
    pageLayout   = response_data["pdfinfo"]["pagelayout"]
    leftMargin   = response_data["pdfinfo"]["leftmargin"]
    rightMargin  = response_data["pdfinfo"]["rightmargin"]
    topMargin    = response_data["pdfinfo"]["topmargin"]
    bottomMargin = response_data["pdfinfo"]["bottommargin"]

    options = "{"
    if @pdfTemplate == ""
      options << ":page_size => "
    else
      options << ":template => "
      options << "\"#{@pdfTemplate}\""
      options << ", :page_size => "
    end
    options << "\"#{pageSize}\""
    options << ", :page_layout => "
    options << "#{pageLayout}"
    options << ", :left_margin => "
    options << "#{leftMargin}"
    if @pointUnit != ""
      options << ".#{@pointUnit}"
    end

    options << ", :right_margin => "
    options << "#{rightMargin}"
    if @pointUnit != ""
      options << ".#{@pointUnit}"
    end

    options << ", :top_margin => "
    options << "#{topMargin}"
    if @pointUnit != ""
      options << ".#{@pointUnit}"
    end

    options << ", :bottom_margin => "
    options << "#{bottomMargin}"
    if @pointUnit != ""
      options << ".#{@pointUnit}"
    end

    options << "}"
    return options
  end

  # フォント　ファイルを設定する
  def getFontFile(rpdfinfo, vpdfinfo)
    file = @fontFile
    if rpdfinfo["fontfile"] != ""
      file = rpdfinfo["fontfile"]
    end
    if vpdfinfo["font"]["file"] != ""
      file = vpdfinfo["font"]["file"]
    end

    return file
  end

  # 改ページ用オプションを設定する
  def setNewPage(recordArray)
    nnPage     = recordArray[0]["pdfinfo"]["templatepage"]
    options    = "{"
    options   << ":template => "
    options   << "\"#{@pdfTemplate}\""
    options   << ", :template_page => "
    options   << "#{nnPage}"
    options   << "}"
    return options
  end

  # フォント　オプションを設定する
  def getFontOptions(rpdfinfo, vpdfinfo)
    size = @fontSize
    if rpdfinfo["fontsize"] != ""
      size = rpdfinfo["fontsize"]
    end

    if vpdfinfo["font"]["size"] != ""
      size = vpdfinfo["font"]["size"]
    end

    style = @fontStyle
    if rpdfinfo["fontstyle"] != ""
      style = rpdfinfo["fontstyle"]
    end
    if vpdfinfo["font"]["style"] != ""
      style = vpdfinfo["font"]["style"]
    end

    options = "{"
    options << ":size => "
    options << size

    if style != ""
      options << ", :style => "
      options << style
    end

    options << "}"

    return options
  end

  # カラー　オプションを設定する
  def getColorOption(rpdfinfo, vpdfinfo)
    w_color = @fontColor
    if rpdfinfo["fontcolor"]
      if rpdfinfo["fontcolor"] != ""
        w_color = rpdfinfo["fontcolor"]
      end
    end

    if vpdfinfo["font"]["color"]
      if vpdfinfo["font"]["color"] != ""
        w_color = vpdfinfo["font"]["color"]
      end
    end

    if w_color == ""
      w_color = "000000"
    else
      w_color = w_color
    end

    return w_color
  end

  # 明細テキストボックス　オプションを設定する
  def getDetailTextBoxOptions(vpdfinfo)
    atX    = convUnit(vpdfinfo["axis"]["x"][0])
    #atY    = convUnit(@curYPosition)
    # Y 項目に記述がない場合は @curYPosition を使用
    if vpdfinfo["axis"]["y"][0]  == ""
      atY    = convUnit(@curYPosition)
    else
      # Y 項目が "offsetxxx" の記述であれば @curYPosition からの相対位置を使用
      if /^offset(.+)/ =~ vpdfinfo["axis"]["y"][0]
        atY  = convUnit(@curYPosition + ($1.to_f))
      # Y 項目が 上記以外の記述であれば その値を使用
      else
        atY  = convUnit(vpdfinfo["axis"]["y"][0])
      end
    end

    width  = convUnit(vpdfinfo["box"]["width"])
    height = convUnit(vpdfinfo["box"]["height"])
    align  = vpdfinfo["box"]["align"]

    valign = ""
    if vpdfinfo["box"]["valign"]
      if vpdfinfo["box"]["valign"] != ""
        valign = vpdfinfo["box"]["valign"]
      end
    end

    overflow = ""
    if vpdfinfo["box"]["overflow"]
      if vpdfinfo["box"]["overflow"] != ""
        overflow = vpdfinfo["box"]["overflow"]
      end
    end

    options = "{"
    options << ":at => ["
    options << atX
    options << ", "
    options << atY
    options << "]"
    options << ", :width => "
    options << width
    options << ", :height => "
    options << height
    options << ", :align => "
    options << align

    ## valign options are :top, :center, or :bottom
    if valign != ""
      options << ", :valign => "
      options << valign
    end

    ## overflow options are :truncate, :shrink_to_fit, or :expand
    if overflow != ""
      options << ", :overflow => "
      options << overflow
    end

    options << "}"

    return options
  end

  # 明細以外のテキストボックス　オプションを設定する（multiline = yes 用）
  def getMultilineTextBoxOptions(vpdfinfo)
    atX    = convUnit(vpdfinfo["axis"]["x"][0])
    #atY    = convUnit(@curYPositionOther)
    # Y 項目に記述がない場合は @curYPositionOther を使用
    if vpdfinfo["axis"]["y"][0]  == ""
      atY    = convUnit(@curYPositionOther)
    else
      # Y 項目が "offsetxxx" の記述であれば @curYPositionOther からの相対位置を使用
      if /^offset(.+)/ =~ vpdfinfo["axis"]["y"][0]
        atY  = convUnit(@curYPositionOther + ($1.to_f))
      # Y 項目が 上記以外の記述であれば その値を使用
      else
        atY  = convUnit(vpdfinfo["axis"]["y"][0])
      end
    end

    width  = convUnit(vpdfinfo["box"]["width"])
    height = convUnit(vpdfinfo["box"]["height"])
    align  = vpdfinfo["box"]["align"]

    valign = ""
    if vpdfinfo["box"]["valign"]
      if vpdfinfo["box"]["valign"] != ""
        overflow = vpdfinfo["box"]["valign"]
      end
    end

    overflow = ""
    if vpdfinfo["box"]["overflow"]
      if vpdfinfo["box"]["overflow"] != ""
        overflow = vpdfinfo["box"]["overflow"]
      end
    end

    options = "{"
    options << ":at => ["
    options << atX
    options << ", "
    options << atY
    options << "]"
    options << ", :width => "
    options << width
    options << ", :height => "
    options << height
    options << ", :align => "
    options << align

    ## valign options are :top, :center, or :bottom
    if valign != ""
      options << ", :valign => "
      options << valign
    end

    ## overflow options are :truncate, :shrink_to_fit, or :expand
    if overflow != ""
      options << ", :overflow => "
      options << overflow
    end

    options << "}"

    return options
  end

  # 明細以外のテキストボックス　オプションを設定する（multiline = no 用）
  def getTextBoxOptions(vpdfinfo)
    atX    = convUnit(vpdfinfo["axis"]["x"][0])
    atY    = convUnit(vpdfinfo["axis"]["y"][0])
    width  = convUnit(vpdfinfo["box"]["width"])
    height = convUnit(vpdfinfo["box"]["height"])
    align  = vpdfinfo["box"]["align"]

    valign = ""
    if vpdfinfo["box"]["valign"]
      if vpdfinfo["box"]["valign"] != ""
        valign = vpdfinfo["box"]["valign"]
      end
    end

    overflow = ""
    if vpdfinfo["box"]["overflow"]
      if vpdfinfo["box"]["overflow"] != ""
        overflow = vpdfinfo["box"]["overflow"]
      end
    end

    options = "{"
    options << ":at => ["
    options << atX
    options << ", "
    options << atY
    options << "]"
    options << ", :width => "
    options << width
    options << ", :height => "
    options << height
    options << ", :align => "
    options << align

    ## valign options are :top, :center, or :bottom
    if valign != ""
      options << ", :valign => "
      options << valign
    end

    ## overflow options are :truncate, :shrink_to_fit, or :expand
    if overflow != ""
      options << ", :overflow => "
      options << overflow
    end

    options << "}"

    return options
  end

end

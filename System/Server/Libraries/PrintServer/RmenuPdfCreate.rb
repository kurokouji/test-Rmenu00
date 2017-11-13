# -*- coding:utf-8 -*-
begin
    require 'rubygems'
rescue LoadError
end


require 'prawn'
require 'prawn-svg'
require 'prawn/measurement_extensions'

require 'RmenuLoggerMixin'
#require 'RmenuDefCache'
require 'RmenuAppCache'
require 'RmenuMVCMixin'                                                                             # before after 動的メソッド実行Mixin
require 'date'
require 'RmenuPdfMixin'

class RmenuPdfCreate
  include RmenuLoggerMixin
  include RmenuMVCMixin
  include RmenuPdfMixin

  def initialize(log_file_name, response_data, sql_data, request_data)
    $PDFC             = createLogger(log_file_name)                                                 # view用ログの作成

    begin
      $PDFC.debug("RmenuPdfCreate") {"initialize start"}                                            # Logファイル Debug用

      @app_cache          = RmenuAppCache.new("form.rb")                                            # フォームAPPのキャッシュ
      @app_cache.createCache()

      pdfTempDir        = $Rconfig['apps_path'] + "/" + response_data["html"].gsub(/\/Json\//, '/PdfTemplate/')
      @pdfTemplate        = ""
      if response_data["pdfinfo"]["template"] != ""
        @pdfTemplate      = pdfTempDir + "/" + response_data["pdfinfo"]["template"]
      end

      # 20171017 shimoji update start
      # 20171101 okada add start
      @rmenuImageTemplate = ""
      @rmenuImageTemplateUrl = ""
      if response_data["pdfinfo"]["imageTemplate"]
        if response_data["pdfinfo"]["imageTemplate"] != ""
          @rmenuImageTemplate    = response_data["pdfinfo"]["imageTemplate"]
          @rmenuImageTemplateUrl = pdfTempDir + "/" + response_data["pdfinfo"]["imageTemplate"]
        end
      end

      @rmenuImageTemplateScale = ""
      if @rmenuImageTemplateUrl != ""
        if response_data["pdfinfo"]["imageTemplateDpi"]
          if response_data["pdfinfo"]["imageTemplateDpi"] != ""
            dpi  = response_data["pdfinfo"]["imageTemplateDpi"]
            @rmenuImageTemplateScale = 72.to_f/dpi.to_f
          end
        end
      end

      @rmenuSvgTemplate     = ""
      @rmenuSvgTemplateUrl  = ""
      @rmenuSvgTemplateData = ""
      if response_data["pdfinfo"]["svgTemplate"]
        if response_data["pdfinfo"]["svgTemplate"] != ""
          @rmenuSvgTemplate     = response_data["pdfinfo"]["svgTemplate"]
          @rmenuSvgTemplateUrl  = pdfTempDir + "/" + response_data["pdfinfo"]["svgTemplate"]
          if @rmenuSvgTemplate.match(/.[.]svg$/)
            @rmenuSvgTemplateData = readHtml(@rmenuSvgTemplateUrl)
          end
        end
      end

      @rmenuSvgTemplateX = ""
      if @rmenuSvgTemplateUrl != ""
        if response_data["pdfinfo"]["svgTemplateX"]
          if response_data["pdfinfo"]["svgTemplateX"] != ""
            @rmenuSvgTemplateX = response_data["pdfinfo"]["svgTemplateX"]
          end
        end
      end

      @rmenuSvgTemplateY = ""
      if @rmenuSvgTemplateUrl != ""
        if response_data["pdfinfo"]["svgTemplateY"]
          if response_data["pdfinfo"]["svgTemplateY"] != ""
            @rmenuSvgTemplateY = response_data["pdfinfo"]["svgTemplateY"]
          end
        end
      end

      @rmenuSvgTemplateWidth = ""
      if @rmenuSvgTemplateUrl != ""
        if response_data["pdfinfo"]["svgTemplateWidth"]
          if response_data["pdfinfo"]["svgTemplateWidth"] != ""
            @rmenuSvgTemplateWidth = response_data["pdfinfo"]["svgTemplateWidth"]
          end
        end
      end

      @rmenuSvgTemplateHeight = ""
      if @rmenuSvgTemplateUrl != ""
        if response_data["pdfinfo"]["svgTemplateHeight"]
          if response_data["pdfinfo"]["svgTemplateHeight"] != ""
            @rmenuSvgTemplateHeight = response_data["pdfinfo"]["svgTemplateHeight"]
          end
        end
      end
      # 20171101 okada add end
      # 20171017 shimoji update end

      @fontFile           = response_data["pdfinfo"]["fontfile"]
      @fontSize           = response_data["pdfinfo"]["fontsize"]
      @fontStyle          = response_data["pdfinfo"]["fontstyle"]
      @fontColor          = response_data["pdfinfo"]["fontcolor"]
      @pointUnit          = response_data["pdfinfo"]["pointunit"]

      recordArray         = getRecordOfPageOutputControl("detail", "", response_data)
      @yPosition          = recordArray[0]["pdfinfo"]["yposition"].to_f
      @curYPosition       = 0.0
      @moveDown           = recordArray[0]["pdfinfo"]["movedown"].to_f
      @maxLineCount       = recordArray[0]["pdfinfo"]["pagelines"].to_i
      @totalPageCount     = 0
      @totalRecordCount   = 0
      @controlPageCount   = 0
      @currentLineCount   = 0
      @currentRecordIndex = 0
      @prawnInitSW        = 0
      @printHeaderSW      = 0
      @pageFooterLastSW   = 0

      # ヘッダー・フッターのマルチライン用に使用する（2014.04.02 shimoji　追加）
      @curYPositionOther  = 0.0

      $PDFC.debug("RmenuPdfCreate") {"initialize normal end"}                                       # Logファイル Debug用
    rescue
      # エラーログを出力する
      $PDFC.error("RmenuPdfCreate") {"initialize exception: #{$!}"}                                 # Logファイル Debug用
      raise
    end
  end


  #- getter メソッド ---------------
  # totalRecordCountを加算
  def addTotalRecordCount()
    @totalRecordCount = @totalRecordCount + 1
    return @totalRecordCount
  end

  # totalRecordCount
  def getTotalRecordCount()
    return @totalRecordCount
  end

  # Prawnオブジェクト
  def getPdfObject()
    return @pdf
  end

  # totalPageCount
  def getTotalPageCount()
    return @totalPageCount
  end

  # maxLineCount
  def getMaxLineCount()
    return @maxLineCount
  end

  # pageFooterLastSW
  def getPageFooterLastSW()
    return @pageFooterLastSW
  end

  # currentLineCount
  def getCurrentLineCount()
    return @currentLineCount
  end

  # addCurrentLineCount
  def addCurrentLineCount(counter)
    @currentLineCount = @currentLineCount + counter
    return @currentLineCount
  end

  # setCurrentLineCount
  def setCurrentLineCount(counter)
    @currentLineCount = counter
  end

  # currentRecordIdex
  def getCurrentRecordIndex()
    return @currentRecordIndex
  end

  # curYPosition
  def getCurYPosition()
    return @curYPosition
  end


  #- setter メソッド ---------------
  # currentRecordIdex
  def setCurrentRecordIndex(value)
    @currentRecordIndex = value
    @curYPosition       = value
  end

  # curYPosition
  def setCurYPosition(value)
    @curYPosition       = value
  end


  def start(response_data)
    $PDFC.debug("RmenuPdfCreate") {"start start"}                                                   # Logファイル Debug用

    # pdfオブジェクトを生成
    options = createPrawnObjectOfHash(response_data)
    $PDFC.debug("RmenuPdfCreate") {"start PrawnObjectOption : #{options}"}                          # Logファイル Debug用
    @pdf         = Prawn::Document.new(eval(options))

  # 20171017 shimoji update start
  # 20171102 okada update start
    if @rmenuSvgTemplateUrl != ""
        svgTemplateX      = @rmenuSvgTemplateX.to_s      + '.' + @pointUnit.to_s
        svgTemplateY      = @rmenuSvgTemplateY.to_s      + '.' + @pointUnit.to_s
        svgTemplateWidth  = @rmenuSvgTemplateWidth.to_s  + '.' + @pointUnit.to_s
        svgTemplateHeight = @rmenuSvgTemplateHeight.to_s + '.' + @pointUnit.to_s
        svgOptions = "{"
        svgOptions << ":at => ["
        svgOptions << "#{svgTemplateX}"
        svgOptions << ", "
        svgOptions << "#{svgTemplateY}"
        svgOptions << "]"
        svgOptions << ", :width => "
        svgOptions << "#{svgTemplateWidth}"
        svgOptions << ", :height => "
        svgOptions << "#{svgTemplateHeight}"
        svgOptions << "}"
        $PDFC.debug("RmenuPdfCreate") {"start #{@rmenuSvgTemplateUrl}"}                                              # Logファイル Debug用
        $PDFC.debug("RmenuPdfCreate") {"start #{svgOptions}"}                                              # Logファイル Debug用
        if @rmenuSvgTemplate.match(/.[.]svg$/)
          @pdf.svg(@rmenuSvgTemplateData, eval(svgOptions))
        else
          @pdf.image(@rmenuSvgTemplateUrl, eval(svgOptions))
        end
    end
  # 20171102 okada update end
  # 20171017 shimoji update end

    @prawnInitSW = 0

    $PDFC.debug("RmenuPdfCreate") {"start normal end"}                                              # Logファイル Debug用
  end


  def terminate(response_data)
    $PDFC.debug("RmenuPdfCreate") {"terminate start"}                                               # Logファイル Debug用

    tempTime   = Time.now
    tempNow    = tempTime.strftime("%Y%m%d%H%M%S")
    pdfDir     = $Rconfig['apps_path'] + "/" + response_data["html"].gsub(/\/Json\//, '/DownLoad/')
    pdfNewFile = pdfDir + "/" + response_data["pdfinfo"]["pdffile"].gsub(/.pdf/, "#{tempNow}.pdf")

    # ＰＤＦファイルを出力する
    @pdf.render_file(pdfNewFile)

    # 新しくレスポンスデータを作成する
    newResponse = Hash.new()
    response_data.each{|key, value|
      case key
      when "pdfinfo"
        newResponse["pdfinfo"] = {}
        value.each{|key1, value1|
          if key1 == "pdfname"
            newResponse["pdfinfo"][key1] = value1
          end
          if key1 == "pdffile"
            newResponse["pdfinfo"][key1] = value1
          end
        }
      when "message"
        newResponse["message"] = {}
        value.each{|key2, value2|
          newResponse["message"][key2] = value2
        }
      when "records"
      else
        newResponse[key] = value
      end
    }

    pdfPath  = response_data["html"].gsub(/\/Json\//, '/DownLoad/')
    filename = response_data["pdfinfo"]["pdffile"].gsub(/.pdf/, "#{tempNow}.pdf")
    newResponse["pdfinfo"]["pdffile"] = pdfPath + "/" + filename
    newResponse["pdfinfo"]["pdfname"] = response_data["pdfinfo"]["pdfname"]

    $PDFC.debug("RmenuPdfCreate") {"terminate normal end"}                                          # Logファイル Debug用
    return newResponse
  end

  # 帳票　ヘッダー
  def printHeader(response_data)
    $PDFC.debug("RmenuPdfCreate") {"printHeader start"}                                             # Logファイル Debug用

    recordArray = getRecordOfPageOutputControl("print_header", "first_page", response_data)
    if isItemOfRecord(recordArray)
      @printHeaderSW = 1
      pdfOutputControll(recordArray)
    end

    $PDFC.debug("RmenuPdfCreate") {"printHeader normal end"}                                        # Logファイル Debug用
  end

  # 帳票　フッター
  def printFooter(response_data)
    $PDFC.debug("RmenuPdfCreate") {"printFooter start"}                                             # Logファイル Debug用

    recordArray = getRecordOfPageOutputControl("print_footer", "last_page", response_data)
    if isItemOfRecord(recordArray)
      pdfOutputControll(recordArray)
    end

    $PDFC.debug("RmenuPdfCreate") {"printFooter normal end"}                                        # Logファイル Debug用
  end

  # プリント準備　処理
  def printReady(pdfcreate, response_data, sql_data, request_data)
    $PDFC.debug("RmenuPdfCreate") {"printReady start"}                                              # Logファイル Debug用

    @controlPageCount = 0
    @pageFooterLastSW = 0
    @curYPosition     = @yPosition
    @temp_object      = @app_cache.getFormObject(pdfcreate, response_data, sql_data, request_data)

    $PDFC.debug("RmenuPdfCreate") {"printReady normal end"}                                         # Logファイル Debug用
  end

  # ページヘッダー処理
  def pageHeaderFirst(response_data)
    $PDFC.debug("RmenuPdfCreate") {"pageHeaderFirst start"}                                         # Logファイル Debug用

    recordArray = getRecordOfPageOutputControl("page_header", "first_page", response_data)
    if @prawnInitSW == 1 
      if @pdfTemplate == ""
        @pdf.start_new_page

  # 20171017 shimoji update start
  # 20171102 okada update start
        if @rmenuSvgTemplateUrl != ""
            svgTemplateX      = @rmenuSvgTemplateX.to_s      + '.' + @pointUnit.to_s
            svgTemplateY      = @rmenuSvgTemplateY.to_s      + '.' + @pointUnit.to_s
            svgTemplateWidth  = @rmenuSvgTemplateWidth.to_s  + '.' + @pointUnit.to_s
            svgTemplateHeight = @rmenuSvgTemplateHeight.to_s + '.' + @pointUnit.to_s
            svgOptions = "{"
            svgOptions << ":at => ["
            svgOptions << "#{svgTemplateX}"
            svgOptions << ", "
            svgOptions << "#{svgTemplateY}"
            svgOptions << "]"
            svgOptions << ", :width => "
            svgOptions << "#{svgTemplateWidth}"
            svgOptions << ", :height => "
            svgOptions << "#{svgTemplateHeight}"
            svgOptions << "}"
            $PDFC.debug("RmenuPdfCreate") {"pageHeaderFirst #{@rmenuSvgTemplateUrl}"}                                              # Logファイル Debug用
            $PDFC.debug("RmenuPdfCreate") {"pageHeaderFirst #{svgOptions}"}                                              # Logファイル Debug用
            if @rmenuSvgTemplate.match(/.[.]svg$/)
              @pdf.svg(@rmenuSvgTemplateData, eval(svgOptions))
            else
              @pdf.image(@rmenuSvgTemplateUrl, eval(svgOptions))
            end
        end
  # 20171102 okada update end
  # 20171017 shimoji update start

      else
        options = setNewPage(recordArray)
        @pdf.start_new_page(eval(options))
      end
    end

    @prawnInitSW       = 1
    @totalPageCount   += 1
    @controlPageCount += 1
    @curYPosition      = @yPosition

    if isItemOfRecord(recordArray)
      pdfOutputControll(recordArray)
    end

    $PDFC.debug("RmenuPdfCreate") {"pageHeaderFirst normal end"}                                    # Logファイル Debug用
  end

  def pageHeaderSecond(response_data)
    $PDFC.debug("RmenuPdfCreate") {"pageHeaderSecond start"}                                        # Logファイル Debug用

    recordArray = getRecordOfPageOutputControl("page_header", "all_page", response_data)
    if @pdfTemplate == ""
      @pdf.start_new_page
      
      # 20171017 shimoji update start
      # 20171102 okada update start
      if @rmenuSvgTemplateUrl != ""
          svgTemplateX      = @rmenuSvgTemplateX.to_s      + '.' + @pointUnit.to_s
          svgTemplateY      = @rmenuSvgTemplateY.to_s      + '.' + @pointUnit.to_s
          svgTemplateWidth  = @rmenuSvgTemplateWidth.to_s  + '.' + @pointUnit.to_s
          svgTemplateHeight = @rmenuSvgTemplateHeight.to_s + '.' + @pointUnit.to_s
          svgOptions = "{"
          svgOptions << ":at => ["
          svgOptions << "#{svgTemplateX}"
          svgOptions << ", "
          svgOptions << "#{svgTemplateY}"
          svgOptions << "]"
          svgOptions << ", :width => "
          svgOptions << "#{svgTemplateWidth}"
          svgOptions << ", :height => "
          svgOptions << "#{svgTemplateHeight}"
          svgOptions << "}"
          $PDFC.debug("RmenuPdfCreate") {"pageHeaderSecond #{@rmenuSvgTemplateUrl}"}                                              # Logファイル Debug用
          $PDFC.debug("RmenuPdfCreate") {"pageHeaderSecond #{svgOptions}"}                                              # Logファイル Debug用
          if @rmenuSvgTemplate.match(/.[.]svg$/)
            @pdf.svg(@rmenuSvgTemplateData, eval(svgOptions))
          else
            @pdf.image(@rmenuSvgTemplateUrl, eval(svgOptions))
          end
      end
      # 20171102 okada update end
      # 20171017 shimoji update end

    else
      options = setNewPage(recordArray)
      @pdf.start_new_page(eval(options))
    end

    @totalPageCount   += 1
    @controlPageCount += 1
    @curYPosition      = @yPosition

    if isItemOfRecord(recordArray)
      pdfOutputControll(recordArray)
    end

    $PDFC.debug("RmenuPdfCreate") {"pageHeaderSecond normal end"}                                   # Logファイル Debug用
  end

  # ページフッター処理
  def pageFooterLast(response_data)
    $PDFC.debug("RmenuPdfCreate") {"pageFooterLast start"}                                          # Logファイル Debug用

    @pageFooterLastSW = 1

    recordArray = getRecordOfPageOutputControl("page_footer", "last_page", response_data)
    if isItemOfRecord(recordArray)
      pdfOutputControll(recordArray)
    end

    $PDFC.debug("RmenuPdfCreate") {"pageFooterLast normal end"}                                     # Logファイル Debug用
  end

  def pageFooterSecond(response_data)
    $PDFC.debug("RmenuPdfCreate") {"pageFooterSecond start"}                                        # Logファイル Debug用

    recordArray = getRecordOfPageOutputControl("page_footer", "all_page", response_data)
    if isItemOfRecord(recordArray)
      pdfOutputControll(recordArray)
    end

    $PDFC.debug("RmenuPdfCreate") {"pageFooterSecond normal end"}                                   # Logファイル Debug用
  end

  # コントロールヘッダー処理
  def controlHeaderFirst(response_data)
    $PDFC.debug("RmenuPdfCreate") {"controlHeaderFirst start"}                                      # Logファイル Debug用

    recordArray = getRecordOfPageOutputControl("control_header", "first_page", response_data)
    if isItemOfRecord(recordArray)
      pdfOutputControll(recordArray)
    end

    $PDFC.debug("RmenuPdfCreate") {"controlHeaderFirst normal end"}                                 # Logファイル Debug用
  end

  def controlHeaderSecond(response_data)
    $PDFC.debug("RmenuPdfCreate") {"controlHeaderSecond start"}                                     # Logファイル Debug用

    recordArray = getRecordOfPageOutputControl("control_header", "all_page", response_data)
    if isItemOfRecord(recordArray)
      pdfOutputControll(recordArray)
    end

    $PDFC.debug("RmenuPdfCreate") {"controlHeaderSecond normal end"}                                # Logファイル Debug用
  end

  # コントロールフッター処理
  def controlFooterLast(response_data)
    $PDFC.debug("RmenuPdfCreate") {"controlFooterLast start"}                                       # Logファイル Debug用

    recordArray = getRecordOfPageOutputControl("control_footer", "last_page", response_data)
    if isItemOfRecord(recordArray)
      pdfOutputControll(recordArray)
    end

    $PDFC.debug("RmenuPdfCreate") {"controlFooterLast normal end"}                                  # Logファイル Debug用
  end

  def controlFooterSecond(response_data)
    $PDFC.debug("RmenuPdfCreate") {"controlFooterSecond start"}                                     # Logファイル Debug用

    recordArray = getRecordOfPageOutputControl("control_footer", "all_page", response_data)
    if isItemOfRecord(recordArray)
      pdfOutputControll(recordArray)
    end

    $PDFC.debug("RmenuPdfCreate") {"controlFooterSecond normal end"}                                # Logファイル Debug用
  end

  # 明細以外　処理
  def pdfOutputControll(recordArray)
    $PDFC.debug("RmenuPdfCreate") {"pdfOutputControll start"}                                       # Logファイル Debug用

    recordArray.each{|record_info|
      if record_info["multiline"] == "yes"
        dataSize = 0
        record_info["record"].each{|key, value|
          dataSize = value["value"].length - 1
          break
        }

        @curYPositionOther = record_info["pdfinfo"]["yposition"].to_f
        for num in 0..dataSize do
          dataOutputControll(record_info, num)
          @curYPositionOther = @curYPositionOther - record_info["pdfinfo"]["movedown"].to_f
        end
      else
        dataOutputControll(record_info, 0)
      end
    }

    $PDFC.debug("RmenuPdfCreate") {"pdfOutputControll normal end"}                                  # Logファイル Debug用
  end

  # 明細　処理
  def detailControl(recordArray, num, maxSize, response_data)
    $PDFC.debug("RmenuPdfCreate") {"detailControl start"}                                           # Logファイル Debug用

    @currentRecordIndex = num - 1
    arraySize           = recordArray.size - 1
    currentArrayCount   = 0
    result              = "OK"

    recordArray.each{|record_info|

      if @currentLineCount == 0
        if num != 1
          if result == "OK"
            pageHeaderSecond(response_data)
            controlHeaderSecond(response_data)
          end
        end
      end

      # 明細行を出力する
      result = dataOutputControll(record_info, num - 1)
      if result == "OK"
        @curYPosition     = @curYPosition - @moveDown
        @currentLineCount = @currentLineCount + 1
      end

      if @currentLineCount == @maxLineCount
        if num == maxSize && currentArrayCount == arraySize
          controlFooterLast(response_data)
          pageFooterLast(response_data)
        else
          controlFooterSecond(response_data)
          pageFooterSecond(response_data)
        end

        @currentLineCount = 0
      end

      currentArrayCount = currentArrayCount + 1
    }

    $PDFC.debug("RmenuPdfCreate") {"detailControl normal end"}                                      # Logファイル Debug用
  end

  def dataOutputControll(record_info, num)
    $PDFC.debug("RmenuPdfCreate") {"dataOutputControll start"}                                      # Logファイル Debug用

    # beforeメソッド処理
    result = doBeforeAfterMethod("before", record_info["pdfinfo"], @temp_object)                    # RmenuMVCMixin
    if result != "OK"
      return result
    end

    record_info["record"].each{|key, value|
      dataOutput(record_info, value["value"][num], value["pdfinfo"])
    }

    # afterメソッド処理
    result = doBeforeAfterMethod("after", record_info["pdfinfo"], @temp_object)                     # RmenuMVCMixin

    $PDFC.debug("RmenuPdfCreate") {"dataOutputControll normal end"}                                 # Logファイル Debug用
    return result
  end

  def dataOutput(record_info, value, vpdfinfo)
    $PDFC.debug("RmenuPdfCreate") {"dataOutput start"}                                      # Logファイル Debug用

    case vpdfinfo["type"]
    when "text_box"
      textboxOutput(record_info, value, vpdfinfo)
    when "text"
      textOutput(record_info, value, vpdfinfo)
    when "image"
      imageOutput(record_info, value, vpdfinfo)
    when "line"
      lineOutput(record_info, value, vpdfinfo)
    when "rectangle"
      rectangleOutput(record_info, value, vpdfinfo)
    when "polygon"
      polygonOutput(record_info, value, vpdfinfo)
    when "circle"
      circleOutput(record_info, value, vpdfinfo)
    when "ellipse"
      ellipseOutput(record_info, value, vpdfinfo)
    else
      otherOutput(record_info, value, vpdfinfo)
    end

    $PDFC.debug("RmenuPdfCreate") {"dataOutput normal end"}                                 # Logファイル Debug用
  end

  # テキストボックス　出力
  def textboxOutput(record_info, value, vpdfinfo)
    $PDFC.debug("RmenuPdfCreate") {"textboxOutput start"}                                           # Logファイル Debug用

    file    = getFontFile(record_info["pdfinfo"], vpdfinfo)
    options = getFontOptions(record_info["pdfinfo"], vpdfinfo)

    $PDFC.debug("RmenuPdfCreate") {"textboxOutput file : #{file}"}
    $PDFC.debug("RmenuPdfCreate") {"textboxOutput options : #{options}"}
    @pdf.font(file, eval(options))

    if record_info["pdfinfo"]["pagecontrol"] == "detail"
      options = getDetailTextBoxOptions(vpdfinfo)
      $PDFC.debug("RmenuPdfCreate") {"textboxOutput DetailTextBoxOptions : #{options}"}
    else
      # 20140402 shimoji 修正
      if record_info["multiline"] == "yes"
        options = getMultilineTextBoxOptions(vpdfinfo)
        $PDFC.debug("RmenuPdfCreate") {"textboxOutput MultilineTextBoxOptions : #{options}"}
      else
        options = getTextBoxOptions(vpdfinfo)
        $PDFC.debug("RmenuPdfCreate") {"textboxOutput TextBoxOptions : #{options}"}
      end
    end

    # フォントカラー設定
    w_color = getColorOption(record_info["pdfinfo"], vpdfinfo)
    @pdf.fill_color(w_color)
    $PDFC.debug("RmenuPdfCreate") {"textboxOutput color : #{w_color}"}

    $PDFC.debug("RmenuPdfCreate") {"textboxOutput value : #{value}"}
    @pdf.text_box("#{value}", eval(options))

    $PDFC.debug("RmenuPdfCreate") {"textboxOutput normal end"}                                      # Logファイル Debug用
  end

  # テキスト　出力
  def textOutput(record_info, value, vpdfinfo)
    $PDFC.debug("RmenuPdfCreate") {"textOutput start"}                                           # Logファイル Debug用

    $PDFC.debug("RmenuPdfCreate") {"textOutput normal end"}                                      # Logファイル Debug用
  end

  # イメージ　出力
  def imageOutput(record_info, value, vpdfinfo)
    $PDFC.debug("RmenuPdfCreate") {"imageOutput start"}                                           # Logファイル Debug用

    $PDFC.debug("RmenuPdfCreate") {"imageOutput normal end"}                                      # Logファイル Debug用
  end

  # 線　出力
  def lineOutput(record_info, value, vpdfinfo)
    $PDFC.debug("RmenuPdfCreate") {"lineOutput start"}                                           # Logファイル Debug用

    $PDFC.debug("RmenuPdfCreate") {"lineOutput normal end"}                                      # Logファイル Debug用
  end

  # 長方形　出力
  def rectangleOutput(record_info, value, vpdfinfo)
    $PDFC.debug("RmenuPdfCreate") {"rectangleOutput start"}                                           # Logファイル Debug用

    $PDFC.debug("RmenuPdfCreate") {"rectangleOutput normal end"}                                      # Logファイル Debug用
  end

  # 多角形　出力
  def polygonOutput(record_info, value, vpdfinfo)
    $PDFC.debug("RmenuPdfCreate") {"polygonOutput start"}                                           # Logファイル Debug用

    $PDFC.debug("RmenuPdfCreate") {"polygonOutput normal end"}                                      # Logファイル Debug用
  end

  # 円　出力
  def circleOutput(record_info, value, vpdfinfo)
    $PDFC.debug("RmenuPdfCreate") {"circleOutput start"}                                           # Logファイル Debug用

    $PDFC.debug("RmenuPdfCreate") {"circleOutput normal end"}                                      # Logファイル Debug用
  end

  # 楕円　出力
  def ellipseOutput(record_info, value, vpdfinfo)
    $PDFC.debug("RmenuPdfCreate") {"ellipseOutput start"}                                           # Logファイル Debug用

    $PDFC.debug("RmenuPdfCreate") {"ellipseOutput normal end"}                                      # Logファイル Debug用
  end

  # その他　出力
  def otherOutput(record_info, value, vpdfinfo)
    $PDFC.debug("RmenuPdfCreate") {"otherOutput start"}                                           # Logファイル Debug用

    $PDFC.debug("RmenuPdfCreate") {"otherOutput normal end"}                                      # Logファイル Debug用
  end

end

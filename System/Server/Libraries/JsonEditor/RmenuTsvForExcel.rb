# coding: UTF-8

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'RmenuLoggerMixin'
require 'RmenuFilePathMixin'
require 'win32ole'

class RmenuTsvForExcel
  include RmenuLoggerMixin
  include RmenuFilePathMixin

  def initialize(log_file_name)
    $Jlog               = createLogger(log_file_name)                           # controller用ログの作成

    begin
      # initialize 開始ログを出力する
      $Jlog.debug("TsvForExcel") {"initialize start"}                           # Logファイル Debug用
    
    
      # initialize 終了ログを出力する
      $Jlog.debug("TsvForExcel") {"initialize normal end"}                      # Logファイル Debug用
    rescue
      # エラーログを出力する
      $Jlog.error("TsvForExcel") {"initialize exception: #{$!}"}                # Logファイル Debug用
    end
  end

  def call(filename)
    $Jlog.debug("TsvForExcel") {"call start"}                                   # Logファイル Debug用
    
    abspathname = getAbsolutePath(filename) + ".xls"
    newname     = abspathname.gsub(/\//, '\\')
    $Jlog.debug("TsvForExcel") {"call file name: #{newname}"}                   # Logファイル Debug用

    xl = WIN32OLE.new('Excel.Application')
    book = xl.Workbooks.Open(abspathname)

    begin
      i       = 0

      book.Worksheets.each do |sheet|
        csvdata = ""

        sheet.UsedRange.Rows.each do |row|
          records = []

          row.Columns.each do |cell|
            if cell.Value.is_a?(Float)
              records << cell.Value.to_i
              next
            end

            records << cell.Value
          end
          
          csvdata << records.join("\t")
          csvdata << "\n"
        end

        abspathname = getAbsolutePath(filename)

        i += 1
        case i
        when 1
          abspathname << "_dataset.csv"
        when 2
          abspathname << "_validation.csv"
        when 3
          abspathname << "_tran.csv"
        when 4
          abspathname << "_sql.csv"
        else
          next
        end

        writeFile(abspathname, csvdata)                                         # RmenuFilePathMixin
      end

      $Jlog.debug("TsvForExcel") {"call normal end"}                            # Logファイル Debug用
    rescue
      $Jlog.error("TsvForExcel") {"call exception: #{$!}"}                      # Logファイル Debug用
    ensure
      book.Close
      xl.Quit
    end
  end

  def getAbsolutePath(filename)
    #fso = WIN32OLE.new('Scripting.FileSystemObject')
    #return fso.GetAbsolutePathName(filename)
    
    temp_path = ""
    if filename.include?("Popup")
      temp_path = $Rconfig['editor_popup_path']
    else
      temp_path = $Rconfig['editor_path']
    end
    
    return temp_path + "/" + filename + "/" + filename
  end
end

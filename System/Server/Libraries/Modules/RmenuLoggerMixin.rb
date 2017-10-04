# coding: UTF-8

require 'fileutils'
require 'logger'

module RmenuLoggerMixin
  def createLogger(file)
    filename = $Rconfig["logs_path"] + "/" + file + ".log"  # ログファイル名の設定
    log = Logger.new(filename, "daily")
    
    case $Rconfig["logger_level"]                           # ログレベルの設定
    when "FATAL"
      log.level = Logger::FATAL
    when "ERROR"
      log.level = Logger::ERROR
    when "WARN"
      log.level = Logger::WARN
    when "INFO"
      log.level = Logger::INFO
    else
      log.level = Logger::DEBUG
    end
    
    return log
  end

  def changeLoggerMode(log, jsonData)
    htmlData = jsonData["html"]
	  project  = htmlData.split("/")
	
	  # 開発支援プロジェクトはログを出力しない
	  if project[0] == "RmenuVisualTools"
	    log.level = Logger::FATAL
	    return log
	  end
	
    case $Rconfig["logger_level"]                           # ログレベルの設定
    when "FATAL"
      log.level = Logger::FATAL
    when "ERROR"
      log.level = Logger::ERROR
    when "WARN"
      log.level = Logger::WARN
    when "INFO"
      log.level = Logger::INFO
    else
      log.level = Logger::DEBUG
    end
    
    return log
  end

  # ファイル名（パス情報含む）を使用してHtmlファイルを取得
  def readHtml(fileName)
    begin
      file = File.open(fileName, "r:UTF-8")
      data = file.read
      file.close

      return data
    rescue Exception
      puts Exception.message
    end
  end

  # PDFファイルを取得
  def readPDF(pdfFile)
    begin
      data = File.open(pdfFile){|file|
        file.binmode
        file.read
      }

      return data
    rescue Exception
      puts Exception.message
    end
  end

  # バイナリファイルを取得
  def readBinFile(fileName)
    begin
      data = File.open(fileName){|file|
        file.binmode
        file.read
      }

      return data
    rescue Exception
      puts Exception.message
    end
  end

  # バイナリファイル(外部コード：UTF16)を取得
  def readBinFile16(fileName)
    begin
      file = File.open(fileName, "r:UTF-16:UTF-8")
      data = file.read
      file.close

      return data
    rescue Exception
      puts Exception.message
    end
  end

  # バイナリファイルを出力
  def writeBinFile(fileName, data)
    begin
      File.binwrite(fileName, data)

      return "OK"
    rescue Exception
      puts Exception.message
    end
  end

  # ファイルを削除する
  def deleteFile(fileName)
    begin
      File.delete(fileName)

      return "OK"
    rescue Exception
      puts Exception.message
    end
  end

  # ディレクトリが無ければ作成する
  def createDir(path)
    begin
      FileUtils.mkdir_p(path) unless FileTest.exist?(path)

      return "OK"
    rescue Exception
      puts Exception.message
    end
  end

  # パス（ディレクトリー）内の指定ディレクトリー以外を削除する
  def deleteDir(path, safedir)
    begin
			searchdir = path + "/**"
			
      dirs = Dir.glob(searchdir)
      dirs.each {|readdir|
        if readdir == safedir
			    next
	      end
	      FileUtils.rm_r(readdir)
      }
			
      return "OK"
    rescue Exception
      puts Exception.message
    end
	end
	
end

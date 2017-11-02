# coding: UTF-8

require 'fileutils'

class CacheInitConvert

  def initialize()
    begin
    
      
    rescue Exception
      raise
    end
  end


  
  def convHTML(buffer)
    w_datetime    = Time.now.strftime("%Y%m%d%H%M")
    
    afterScript   = "\?var=" + w_datetime
    
    buffer.gsub!(/\?var=[0-9]{12}/, afterScript)
    
    return buffer
  end

  
  
  def readFile(filename)
    f=File.open(filename,"r:utf-8")
    readBuffer = f.read()
    f.close()
    
    return readBuffer
  end

  
  def writeFile(filename, writeBuffer)
    f=File.open(filename,"wb:utf-8")
    f.write(writeBuffer)
    f.close()
  end
  

  
  # プログラムの呼び出し  
  def call()
    puts "*** CacheInitConvert start ***"
    
    # カレントパスの取得
    appCurrentPath = File.expand_path(File.dirname(__FILE__))


    # 変換テーブルを使用して、文字列の置換を行う
    # カレントディレクトリ内のすべてのディレクトリーとファイルをサーチする
    Dir::glob("**/*").each {|filename|

      # ディレクトリーは処理しない
      if File::ftype(filename) == "directory"
        next
      end

      # 起動プログラムは処理しない
      if filename == "CacheInitConvert.rb"
        next
      end

      # htmlファイル以外は処理しない
      extname = File.extname(filename)
      if extname != ".html"
        next
      end

      # index.htmlファイルを処理する     
      readBuffer  = readFile(filename)
      writeBuffer = convHTML(readBuffer)
      writeFile(filename, writeBuffer)
      
    }

    puts "*** CacheInitConvert end ***"
  end

end


# プログラムの起動
program = CacheInitConvert.new()
program.call()




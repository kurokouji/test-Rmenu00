# coding: UTF-8

require 'fileutils'

class ProgramConvert

  def initialize(convertTable)
    begin
    
      @convertTable = convertTable
      
    rescue Exception
      raise
    end
  end
  

  
  def convHTML(buffer)
    buffer.gsub!(@convertTable["projectName"][0], @convertTable["projectName"][1])
    buffer.gsub!(@convertTable["programName"][0], @convertTable["programName"][1])
    
    return buffer
  end

  
  def convJavaScript(buffer)
    buffer.gsub!(@convertTable["projectName"][0], @convertTable["projectName"][1])
    buffer.gsub!(@convertTable["programName"][0], @convertTable["programName"][1])
    
    return buffer
  end

  
  def convJson(buffer)
    buffer.gsub!(@convertTable["projectName"][0],  @convertTable["projectName"][1])
    buffer.gsub!(@convertTable["programName"][0],  @convertTable["programName"][1])
    buffer.gsub!(@convertTable["databaseName"][0], @convertTable["databaseName"][1])
    
    return buffer
  end

  
  def convRuby(buffer)
    buffer.gsub!(@convertTable["projectName"][0], @convertTable["projectName"][1])
    buffer.gsub!(@convertTable["programName"][0], @convertTable["programName"][1])
    
    return buffer
  end

  
  def convFileName(filename)
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
    puts "*** ProgramConvert start ***"
    
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
      if filename == "ProgramConvert.rb"
        next
      end

      # 拡張子を取得する
      extname = File.extname(filename)
  
      case extname
      when ".html"
        readBuffer  = readFile(filename)
        writeBuffer = convHTML(readBuffer)
        writeFile(filename, writeBuffer)
        
      when ".js"
        readBuffer  = readFile(filename)
        writeBuffer = convJavaScript(readBuffer)
        writeFile(filename, writeBuffer)
        
      when ".json"
        readBuffer  = readFile(filename)
        writeBuffer = convJson(readBuffer)
        writeFile(filename, writeBuffer)
        
      when ".rb"
        readBuffer  = readFile(filename)
        writeBuffer = convRuby(readBuffer)
        writeFile(filename, writeBuffer)
        
      end
      
    }

    # 変換テーブルを使用して、ファイル名の変換を行う
    # カレントディレクトリ内のすべてのディレクトリーとファイルをサーチする
    Dir::glob("**/*").each {|filename|

      # ディレクトリーは処理しない
      if File::ftype(filename) == "directory"
        next
      end

      # 起動プログラムは処理しない
      if filename == "ProgramConvert.rb"
        next
      end

      # 拡張子を取得する
      extname = File.extname(filename)
      
      # HTMLファイルは処理しない
      if extname == ".html"
        next
      end
      

      arrayName = filename.split("\/")
      arrayName.last.gsub!(@convertTable["programName"][0], @convertTable["programName"][1])
      newName   = arrayName.join("\/")

      if filename != newName
        FileUtils.mv(filename , newName)
      end
      
    }
    
    
    # 変換テーブルを使用して、ディレクトリ名の変換を行う
    # カレントディレクトリ内のディレクトリーだけをサーチする
    Dir::glob("**/").each {|directoryname|
      
      case directoryname
      when "Html/"
        next
        
      when "Json/"
        next
        
      when "Server/"
        next
        
      end
      
      pos = directoryname.index("css")
      if pos
        next
      end
      
      newDirectory = directoryname.gsub(@convertTable["programName"][0], @convertTable["programName"][1])
      
      if directoryname != newDirectory
        FileUtils.mv(directoryname , newDirectory)
      end
      
    }

    puts "*** ProgramConvert end ***"
  end
end


# 変換テーブルの定義
convertTable = {}
convertTable["projectName"]  = ["Sesubi",  "Myapp00"]
convertTable["programName"]  = ["R_MainteContractList",   "R_CustomersList"]
convertTable["databaseName"] = ["setubi",    "myapp00"]

# プログラムの起動
program = ProgramConvert.new(convertTable)
program.call()


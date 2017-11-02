# coding: UTF-8

require 'fileutils'

require "tempfile"

class CacheConvert

  def initialize(convertFile)
    begin
		
		  @convertFile = convertFile
			
    rescue Exception
      raise
    end
  end


	
	def convHTML(line)
	  w_datetime = Time.now.strftime("%Y%m%d%H%M")
		jscss      = @convertFile.index(".js")
		
		position   = line.index(@convertFile)
		if position.nil?
		  return line
		end
		
		endPosition = position - 1
		if jscss.nil?
		  str1     = line[0..endPosition]
		  str2     = @convertFile + "?var=" + w_datetime + "\" rel=\"stylesheet\"/>"
		  newLine  = str1 + str2 + "\n"
		else
		  str1     = line[0..endPosition]
		  str2     = @convertFile + "?var=" + w_datetime + "\"></script>"
		  newLine  = str1 + str2 + "\n"
		end
		
		return newLine
	end

	
	
	
  # プログラムの呼び出し	
  def call()
	  puts "*** CacheConvert start ***"
		
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
      if filename == "CacheConvert.rb"
	      next
	    end

      # htmlファイル以外は処理しない
      extname = File.extname(filename)
			if extname != ".html"
	      next
			end


			# テンプファイルを作成
			temp = Tempfile.new("rmenutemp", File.dirname(filename))
			
			# データ変換
			File.open(filename) {|file|
			  while line = file.gets
				  newLine = convHTML(line)
					temp.write(newLine)
				end
				file.close
				temp.close
			}
			
			
			# テンプファイルを元のファイル名でリネイム
			mode = File.stat(filename).mode
			File.rename(temp.path, filename)
			File.chmod(mode, filename)

    }

	  puts "*** CacheConvert end ***"
	end

end


# 変換ファイル名の定義
convertFile = "rmenumvc-2.1.1.js"

# プログラムの起動
program = CacheConvert.new(convertFile)
program.call()




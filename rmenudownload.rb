# coding: UTF-8

require 'rubygems'
require 'rack'
require 'RmenuConfig'                                                           # Rmenu環境設定クラス
require 'RmenuLoggerMixin'                                                      # Logファイル Debug用

class RmenuDownload
  include RmenuLoggerMixin                                                      # Logファイル Debug用

  def initialize()
    # controller用ログを作成する
    $Rlog               = createLogger("rack")                                  # Logファイル Debug用

    # controller用ログを作成する
    $Rlog.debug("Download Rack") {"initialize start"}                           # Logファイル Debug用

    $Rlog.debug("Download Rack") {"initialize end"}                             # Logファイル Debug用
  end

  def call(env)
    begin
      $Rlog.debug("Download Rack") {"call start"}                               # Logファイル Debug用

      # ブラウザからリクエストデータを受信する
      req      = Rack::Request.new(env)

      $Rlog.debug("Download Rack") {"req.params: #{req.params}"}                # Logファイル Debug用
      filename      = req.params["file"]
      filetype      = req.params["type"]
      deletetype    = req.params["delete"]
      download_name = req.params["download"]

      url = $Rconfig["apps_path"] + "/" + filename
      $Rlog.debug("Download Rack") {"ファイルパス: #{url}"}                     # Logファイル Debug用

      if filetype == "pdf"
        content = readPDF(url)
      else
        content = readBinFile(url)
      end
    
      $Rlog.debug("Download Rack") {"call normal end"}
    rescue
      # エラーログを出力する
      $Rlog.debug("Download Rack") {"exception: #{$!}"}                         # Logファイル Debug用
      $Rlog.debug("Download Rack") {"exception: #{$@}"}                         # Logファイル Debug用

      # エラーメッセージを作成する
      content = setErrorMesssage()
      $Rlog.debug("Download Rack") {"call abnormal end"}
    end

    user_agent = msie(req.user_agent)
    $Rlog.debug("Download Rack") {"IE ? : #{user_agent}"}
		
    # ブラウザへレスポンスデータを送信する
    if !download_name
		  if user_agent
        attachment               = "attachment; filename=" + filename.encode("Shift_JIS")
			else
        attachment               = "attachment; filename=" + filename
			end
    else
		  if user_agent
        attachment               = "attachment; filename=" + download_name.encode("Shift_JIS")
			else
        attachment               = "attachment; filename=" + download_name
			end
    end
    res = Rack::Response.new { |r|
      r.status          = 200
      r['Content-Type']        = 'application/octet-stream'
      r['Content-Disposition'] = attachment
      r['Content-Length']      = '#{content.length}'
      r['Pragram']             = 'no-cache'
      r['Cache-Control']       = 'nocache'
      r.write content
    }

    if deletetype
      if deletetype == "yes"
        deleteFile(url)
      end
    else
      deleteFile(url)
    end
    res.finish

  end
	
	def msie(user_agent)
	  status = user_agent.include?("MSIE")
		if status
		  return status
		end
		
	  status = user_agent.include?("Trident")
	  return status
	end
end

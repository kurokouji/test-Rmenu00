# coding: UTF-8

require 'date'
require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する

module SetubiOfPrintOfFormMixin
  include RmenuJsonMixin

  # 日付時間の編集
  def formatDateTime(value,format)
    begin
      $PDFC.debug("SetubiOfPrintOfFormMixin") {"formatDateTime start"}                               # Logファイル Debug用

      ret = ""
      if value != ""

        weekArray = {"w"=>["SUN","MON","TUE","WED","THU","FRI","SAT"],"W"=>["日" ,"月" ,"火" ,"水" ,"木" ,"金","土"]}
        ampmArray = {"p"=>{"AM"=>"AM"  ,"PM"=>"PM"  },"P"=>{"AM"=>"午前","PM"=>"午後"}}

        dateValue = DateTime.parse(value)
        ret = format

        # 西暦年の編集 'YYYY' 4桁 , 'YY' 2桁
        case
         when format.match(/[^Y]*YYYY/) then
          y = dateValue.strftime("%Y").to_s
          ret.sub!(/([^Y]*)(YYYY)/,'\1'+y)
         when format.match(/[^Y]*YY/) then
          y = dateValue.strftime("%Y").to_s[-2, 2]
          ret.sub!(/([^Y]*)(YY)/,'\1'+y)
        end

        # 月の編集 'MM' 左 0 をつけて2桁 表記 , 'M' 1～9月の場合は スペース+月 表記
        case
         when format.match(/[^M]*MM/) then
          m = dateValue.strftime("%m")
          ret.sub!(/([^M]*)(MM)/,'\1'+m)
         when format.match(/[^M]*M/) then
          m = dateValue.strftime("%1m").to_s.rjust(2, " ")
          ret.sub!(/([^M]*)(M)/,'\1'+m)
        end

        # 日の編集 'DD' 左 0 をつけて2桁 表記 , 'D' 1～9日の場合は スペース+日 表記
        case
         when format.match(/[^D]*DD/) then
          d = dateValue.strftime("%d")
          ret.sub!(/([^D]*)(DD)/,'\1'+d)
         when format.match(/[^D]*D/) then
          d = dateValue.strftime("%1d").to_s.rjust(2, " ")
          ret.sub!(/([^D]*)(D)/,'\1'+d)
        end

        # 曜日の編集 'w' 英字3文字省略型表記 , 'W' 日本語表記
        case
         when format.match(/[^w]*w/) then
          w = weekArray["w"][dateValue.wday]
          ret.sub!(/([^w]*)(w)/,'\1'+w)
         when format.match(/[^W]*W/) then
          w = weekArray["W"][dateValue.wday]
          ret.sub!(/([^W]*)(W)/,'\1'+w)
        end

        # 午前午後の編集 'p' 英字(AM,PM)表記 , 'P' 日本語(午前,午後)表記
        case
         when format.match(/[^p]*p/) then
          p = ampmArray["p"][dateValue.strftime("%p")]
          ret.sub!(/([^p]*)(p)/,'\1'+p)
         when format.match(/[^P]*P/) then
          p = ampmArray["P"][dateValue.strftime("%p")]
          ret.sub!(/([^P]*)(P)/,'\1'+p)
        end

        # 24時間表記の編集 'HH' 左 0 をつけて2桁 , 'H' 0～9時の場合は スペース+時
        case
         when format.match(/[^H]*HH/) then
          h = dateValue.strftime("%H")
          ret.sub!(/([^H]*)(HH)/,'\1'+h)
         when format.match(/[^H]*H/) then
          h = dateValue.strftime("%1H").to_s.rjust(2, " ")
          ret.sub!(/([^H]*)(H)/,'\1'+h)
        end

        # 12時間表記の編集 'hh' 左 0 をつけて2桁 , 'h' 0～9時の場合は スペース+時
        case
         when format.match(/[^h]*hh/) then
          h = dateValue.strftime("%I")
          ret.sub!(/([^h]*)(hh)/,'\1'+h)
         when format.match(/[^h]*h/) then
          h = dateValue.strftime("%1I").to_s.rjust(2, " ")
          ret.sub!(/([^h]*)(h)/,'\1'+h)
        end

        # 分の編集 'mm' 左 0 をつけて2桁 , 'm' 0～9分の場合は スペース+分
        case
         when format.match(/[^m]*mm/) then
          m = dateValue.strftime("%M")
          ret.sub!(/([^m]*)(mm)/,'\1'+m)
         when format.match(/[^m]*m/) then
          m = dateValue.strftime("%1M").to_s.rjust(2, " ")
          ret.sub!(/([^m]*)(m)/,'\1'+m)
        end

        # 秒の編集 'ss' 左 0 をつけて2桁 , 's' 0～9分の場合は スペース+秒
        case
         when format.match(/[^s]*ss/) then
          s = dateValue.strftime("%S")
          ret.sub!(/([^s]*)(ss)/,'\1'+s)
         when format.match(/[^s]*s/) then
          s = dateValue.strftime("%1S").to_s.rjust(2, " ")
          ret.sub!(/([^s]*)(s)/,'\1'+s)
        end

      end

      $PDFC.debug("SetubiOfPrintOfFormMixin") {"formatDateTime end"}                                 # Logファイル Debug用
      return ret
    rescue Exception
      $PDFC.error("SetubiOfPrintOfFormMixin") {"formatDateTime: #{$!}"}               # Logファイル Debug用
      raise
    end
  end

end

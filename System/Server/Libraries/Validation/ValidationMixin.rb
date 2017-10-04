# coding: UTF-8

require 'date'

module ValidationMixin
  # （リクエストレコードから項目を取りだし、チェックを行う）
  def checkRecordItem(record, validation_record)
    record.each do |name, value|
      if validation_record.key?(name)
         validatins = validation_record[name]
         
         max_line = value["value"].size - 1
         for i in 0..max_line
         
           # バリデーション チェック
           if validatins.key?("validation")
             valid_count = validatins["validation"].size - 1
             for j in 0..valid_count
               if validatins["validation"][j] == ""
                 next
               end
               str_method = "rmenu_" + validatins["validation"][j] + "(\"#{value['value'][i]}\", \"#{name}\")"
               $Clog.debug("Controller") {"チェックするメソッド情報 : #{str_method}"}

               result = eval(str_method)
               if result == "ERROR"
                 return "ERROR"
               end
             end
           end
         
           # 最少桁数 チェック
           if validatins.key?("min")
             minsize = validatins["min"].to_i
             $Clog.debug("Controller") {"チェックするメソッド情報 : min(#{minsize}, \"#{value["value"][i]}\", \"#{name}\")"}

             result = rmenu_min(minsize, value["value"][i], name)
             if result == "ERROR"
               return "ERROR"
             end
           end
         
           # 最大桁数 チェック
           if validatins.key?("max")
             maxsize = validatins["max"].to_i
             $Clog.debug("Controller") {"チェックするメソッド情報 : max(#{maxsize}, \"#{value["value"][i]}\", \"#{name}\")"}

             result = rmenu_max(maxsize, value["value"][i], name)
             if result == "ERROR"
               return "ERROR"
             end
           end

           # 最少バイト数 チェック
           if validatins.key?("minbyte")
             minsize = validatins["minbyte"].to_i
             $Clog.debug("Controller") {"チェックするメソッド情報 : minbyte(#{minsize}, \"#{value["value"][i]}\", \"#{name}\")"}

             result = rmenu_minbyte(minsize, value["value"][i], name)
             if result == "ERROR"
               return "ERROR"
             end
           end
         
           # 最大バイト数 チェック
           if validatins.key?("maxbyte")
             maxsize = validatins["maxbyte"].to_i
             $Clog.debug("Controller") {"チェックするメソッド情報 : maxbyte(#{maxsize}, \"#{value["value"][i]}\", \"#{name}\")"}

             result = rmenu_maxbyte(maxsize, value["value"][i], name)
             if result == "ERROR"
               return "ERROR"
             end
           end

         end
      end
    end
    
    return "OK"
  end

  # 必須チェック
  def rmenu_required(value, name)
    if value == ""
      return valid_error("#{name} :入力必須項目です。省略できません。")
    else
      return "OK"
    end
  end

  # 省略可チェック
  def rmenu_nonrequired(value, name)
    return "OK"
  end

  # 数字チェック
  def rmenu_integerP(value, name)
    if value == ""
      return "OK"
    end
    
    if value =~ /^[0-9]+$/
      return "OK"
    else
      return valid_error("#{name} :数字以外の文字が入力されています。")
    end
  end

  # 符号付き（+：省略可）数字チェック
  def rmenu_integer(value, name)
    if value == ""
      return "OK"
    end
    
    if value =~ /^[\+|\-]?[0-9]+$/
      return "OK"
    else
      return valid_error("#{name} :符号と数字以外の文字が入力されています。")
    end
  end

  # 小数チェック
  def rmenu_decimals(value, name)
    if value == ""
      return "OK"
    end

    atrAry = value.split(".")
    if atrAry.length > 2
      return valid_error("#{name} :小数の入力が間違っています。")
    end

    if !(atrAry[0] =~ /^[0-9]+$/)
      return valid_error("#{name} :数字以外の文字が入力されています。")
    end

    if atrAry.length == 2
      if !(atrAry[1] =~ /^[0-9]+$/)
        return valid_error("#{name} :数字以外の文字が入力されています。")
      end
    end

    return "OK"
  end

  # 符号付き小数チェック 2017/04/24 Okada
  def rmenu_decimalS(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[+-]?\d+(\.\d+)?$/
      return "OK"
    else
      return valid_error("#{name} :数字と小数点、符号以外の文字が入力されています。")
    end
  end

  # アルファベット（大文字・小文字）チェック
  def rmenu_alphabet(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[a-zA-Z]+$/
      return "OK"
    else
      return valid_error("#{name} :アルファベット（大文字・小文字）以外の文字が入力されています。")
    end
  end

  # アルファベット（小文字）チェック
  def rmenu_alphabetS(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[a-z]+$/
      return "OK"
    else
      return valid_error("#{name} :アルファベット（小文字）以外の文字が入力されています。")
    end
  end

  # アルファベット（大文字）チェック
  def rmenu_alphabetB(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[A-Z]+$/
      return "OK"
    else
      return valid_error("#{name} :アルファベット（大文字）以外の文字が入力されています。")
    end
  end

  # 英数字チェック
  def rmenu_alphanum(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[a-zA-Z0-9]+$/
      return "OK"
    else
      return valid_error("#{name} :英数字以外の文字が入力されています。")
    end
  end

  # 英数字チェック
  def rmenu_alphanumspace(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[a-zA-Z0-9 ]+$/
      return "OK"
    else
      return valid_error("#{name} :英数字、スペース以外の文字が入力されています。")
    end
  end

  # 英数字（0～9と小文字）チェック
  def rmenu_alphanumS(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[a-z0-9]+$/
      return "OK"
    else
      return valid_error("#{name} :英数字（0～9と小文字）以外の文字が入力されています。")
    end
  end

  # 英数字（0～9と大文字）チェック
  def rmenu_alphanumB(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[A-Z0-9]+$/
      return "OK"
    else
      return valid_error("#{name} :英数字（0～9と大文字）以外の文字が入力されています。")
    end
  end

  # ひらがな チェック
  def rmenu_hiragana(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[あ-んが-ぼぁ-ょゎっー　]+$/
      return "OK"
    else
      return valid_error("#{name} :ひらがな以外の文字が入力されています。")
    end
  end

  # カタカナ チェック
  def rmenu_katakana(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[ア-ンァィゥェォャュョッ、。ー・　]+$/
      return "OK"
    else
      return valid_error("#{name} :カタカナ以外の文字が入力されています。")
    end
  end

  # 半角カタカナ チェック
  def rmenu_katakanaH(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｧｨｩｪｫｬｭｮｯｰﾞﾟ ]+$/
      return "OK"
    else
      return valid_error("#{name} :半角カタカナ以外の文字が入力されています。")
    end
  end

  # 半角カタカナ チェック
  def rmenu_katakanaH9(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｧｨｩｪｫｬｭｮｯｰﾞﾟ ]+$/
      return "OK"
    else
      return valid_error("#{name} :半角カタカナ以外の文字が入力されています。")
    end
  end

  # 半角 チェック
  def rmenu_halfchar(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^[ｱｲｳｴｵｧｨｩｪｫｶｷｸｹｺｻｼｽｾｿﾀﾁﾂｯﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖｬｭｮﾗﾘﾙﾚﾛﾜｦﾝﾞﾟｰ･､｡ A-Za-z0-9!"#%&'\(\)=\|;:\+\*_,\.<>\?@\[\]\{\}\\\^\-｢｣\$\/]+$/
      return "OK"
    else
      return valid_error("#{name} :半角文字以外の文字が入力されています。")
    end
  end

  # 漢字チェック
  def rmenu_kanji(value, name)
    return "OK"
  end

  # 西暦日付チェック
  def rmenu_yyyymmdd(value, name)
    if value == ""
      return "OK"
    end

    year  = value.slice(0, 4).to_i
    month = value.slice(4, 2).to_i
    day   = value.slice(6, 2).to_i

    if Date.valid_date?(year, month, day)
      return "OK"
    else
      return valid_error("#{name} :日付が間違っています。")
    end
  end

  # 西暦日付チェック（／付き１０桁）
  def rmenu_yyyysmmsdd(value, name)
    if value == ""
      return "OK"
    end

    year  = value.slice(0, 4).to_i
    s1    = value.slice(4, 1)
    month = value.slice(5, 2).to_i
    s2    = value.slice(7, 1)
    day   = value.slice(8, 2).to_i

    if Date.valid_date?(year, month, day)
      if s1== "/" && s2 == "/"
        return "OK"
      end
    end

    return valid_error("#{name} :日付が間違っています。")
  end

  # 西暦日付チェック（-付き１０桁）
  def rmenu_yyyyhmmhdd(value, name)
    if value == ""
      return "OK"
    end

    year  = value.slice(0, 4).to_i
    s1    = value.slice(4, 1)
    month = value.slice(5, 2).to_i
    s2    = value.slice(7, 1)
    day   = value.slice(8, 2).to_i

    if Date.valid_date?(year, month, day)
      if s1== "-" && s2 == "-"
        return "OK"
      end
    end

    return valid_error("#{name} :日付が間違っています。")
  end

  # 年月チェック
  def rmenu_yyyymm(value, name)
    if value == ""
      return "OK"
    end

    year  = value.slice(0, 4).to_i
    month = value.slice(4, 2).to_i
    day   = 1

    if Date.valid_date?(year, month, day)
      return "OK"
    else
      return valid_error("#{name} :年月が間違っています。")
    end
  end

  # 年月チェック（-付き１０桁）
  def rmenu_yyyyhmm(value, name)
    if value == ""
      return "OK"
    end

    year  = value.slice(0, 4).to_i
    s1    = value.slice(4, 1)
    month = value.slice(5, 2).to_i
    day   = 1

    if Date.valid_date?(year, month, day)
      if s1== "-"
        return "OK"
      end
    end

    return valid_error("#{name} :年月が間違っています。")
  end

  # 月日チェック
  def rmenu_mmdd(value, name)
    if value == ""
      return "OK"
    end

    day = Time.now
    year  = day.year
    month = value.slice(0, 2).to_i
    day   = value.slice(2, 2).to_i

    if Date.valid_date?(year, month, day)
      return "OK"
    else
      return valid_error("#{name} :月日が間違っています。")
    end
  end

  # 時刻チェック
  def rmenu_hhmm(value, name)
    if value == ""
      return "OK"
    end

    hh = value.slice(0, 2).to_i
    mm = value.slice(2, 2).to_i

    if hh >= 0 && hh <= 24
      if mm >= 0 && mm <= 59
        return "OK"
      end
    end

    return valid_error("#{name} :時刻が間違っています。")
  end

  # 時刻チェック（：付き５桁）
  def rmenu_hhcmm(value, name)
    if value == ""
      return "OK"
    end

    hh = value.slice(0, 2).to_i
    cc = value.slice(2, 1)
    mm = value.slice(3, 2).to_i

    if hh >= 0 && hh <= 24
      if mm >= 0 && mm <= 59
        if cc == ":"
          return "OK"
        end
      end
    end

    return valid_error("#{name} :時刻が間違っています。")
  end

  def rmenu_free(value, name)
    return "OK"
  end

  # 郵便番号チェック
  def rmenu_postno(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^\d{3}-\d{4}$|^\d{3}-\d{2}$|^\d{3}$/
      return "OK"
    else
      return valid_error("#{name} :郵便番号が間違っています。")
    end
  end

  # 電話番号チェック
  def rmenu_telno(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^\d{2,4}-\d{2,4}-\d{4}$/
      return "OK"
    else
      return valid_error("#{name} :電話番号が間違っています。")
    end
  end

  # 携帯番号チェック
  def rmenu_keitaino(value, name)
    if value == ""
      return "OK"
    end

    if value =~ /^\d{3,3}-\d{4,4}-\d{4,4}$|^\d{11}$/
      return "OK"
    else
      return valid_error("#{name} :携帯番号が間違っています。")
    end
  end

  # メールアドレスチェック
  def rmenu_mailaddress(value, name)
    return "OK"
  end

  # URLチェック
  def url(value, name)
    return "OK"
  end

  # IPアドレスチェック
  def rmenu_ipaddress(value, name)
    return "OK"
  end

  # 最少桁数チェック
  def rmenu_min(minsize, value, name)
    if value == ""
      return "OK"
    end
    if minsize == 0
      return "OK"
    end
    
    if vintegerString?(value) || vfloatString?(value)
      str_value = value.to_s
    else
      str_value = value
    end

    if str_value.size < minsize
      return valid_error("#{name} :桁数が足りません。")
    else
      return "OK"
    end
  end

  # 最大桁数チェック
  def rmenu_max(maxsize, value, name)
    if value == ""
      return "OK"
    end
    if maxsize == 0
      return "OK"
    end

    if vintegerString?(value) || vfloatString?(value)
      str_value = value.to_s
    else
      str_value = value
    end

    if str_value.size > maxsize
      return valid_error("#{name} :桁数オーバです。")
    else
      return "OK"
    end
  end

  # 最少バイト数チェック
  def rmenu_minbyte(minsize, value, name)
    if value == ""
      return "OK"
    end
    if minsize == 0
      return "OK"
    end
    
    if vintegerString?(value) || vfloatString?(value)
      str_value = value.to_s
    else
      str_value = value
    end

    # 英数字の判定
    if str_value =~ /^[a-zA-Z0-9]+$/
      # 英数字
      if str_value.size < minsize
        return valid_error("#{name} :バイト数が足りません。")
      else
        return "OK"
      end
    else
      # 日本語
      bytesize = minsize * 1.5
      if str_value.bytesize < bytesize
        return valid_error("#{name} :バイト数が足りません。")
      else
        return "OK"
      end
    end
  end

  # 最大バイト数チェック
  def rmenu_maxbyte(maxsize, value, name)
    if value == ""
      return "OK"
    end
    if maxsize == 0
      return "OK"
    end

    if vintegerString?(value) || vfloatString?(value)
      str_value = value.to_s
    else
      str_value = value
    end

    # 英数字の判定
    if str_value =~ /^[a-zA-Z0-9]+$/
      # 英数字
      if str_value.size > maxsize
        return valid_error("#{name} :バイト数オーバです。")
      else
        return "OK"
      end
    else
      # 日本語
      bytesize = maxsize * 1.5
      if str_value.bytesize > bytesize
        return valid_error("#{name} :バイト数オーバです。")
      else
        return "OK"
      end
    end
  end

  # 数字か
  def vintegerString?(str)
    begin
      Integer(str)
      true
    rescue ArgumentError
      false
    end
  end

  # 浮動小数点数字か
  def vfloatString?(str)
    begin
      Float(str)
      true
    rescue ArgumentError
      false
    end
  end

  # リクエストデータにエラー情報を設定する
  def valid_error(error_message)
    @request_data["message"]["status"] = "ERROR"
    @request_data["message"]["msg"]    = error_message
    return "ERROR"
  end
end
# coding: UTF-8

module RmenuDivisionMethodMixin
  
  # 件数分割の開始行を設定する
	# dataSize : データのサイズ
	# division_number : 分割数
	# parallel_division_id : バッチの実行順位
  def setNumberStartRow(parallel_division_id, division_number, dataSize)
    begin
      # キーの行数　/　分割数・・・商：answer[0]  余り：answer[1]
      answer    = dataSize.divmod(division_number)
      start_row = (parallel_division_id - 1) * answer[0] + 1

      return start_row
    rescue
      raise
    end
  end
	
  # 件数分割の終了行を設定する
  def setNumberEndRow(parallel_division_id, division_number, dataSize)
    begin
      # キーの行数　/　分割数・・・商：answer[0]  余り：answer[1]
      answer    = dataSize.divmod(division_number)
      if division_number == parallel_division_id
        end_row = dataSize
      else
        end_row = parallel_division_id * answer[0]
      end

      return end_row
    rescue
      raise
    end
  end
	
  # キー分割の開始行と終了行のハッシュを設定する
	# parallelKey : 全キーが格納されたハッシュ
  def setKeyHash(parallelKey)
    begin
      keyHash          = {}
			keyHash["start"] = []
			keyHash["end"]   = []
			
      parallelKey.each {|key, value|
        max                   = value["value"].length - 1
			  strValue              = value["value"][0]
				idx                   = 0
				keyHash["start"][idx] = 1
				
				for num in 0..max do
					if strValue != value["value"][num]
						keyHash["end"][idx]   = num
						idx                   = idx + 1
						keyHash["start"][idx] = num + 1
				  end
				end
				
				keyHash["end"][idx] = max + 1
				break
      }

      return keyHash
    rescue
      raise
    end
  end
	
end

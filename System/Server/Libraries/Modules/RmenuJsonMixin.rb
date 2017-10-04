# coding: UTF-8

module RmenuJsonMixin

  # JSONオブジェクト(ハッシュであること)から、
  # 1) 一旦、任意のセクション名を持つ要素(ハッシュの配列)を探し、
  # 2) 更に、任意のid を持つ要素を求めて、
  # 3) 返却します
  # 該当要素がない場合は false を返却します
  #
  # 基本的な説明(こう使ってもらえばよいです)
  # 入力値:
  #   json_obj: 検索対象のJSONオブジェクト(ハッシュ)
  #   section_name: セクション名(文字列)
  #   id: 検索id(文字列)
  # 出力値:
  #   検索された要素
  #
  # 使用例:
  #   json_data = {
  #                 ...
  #                ,"sqls"=>
  #                 [
  #                   {"id"=>"query_1", "type"=>"select", ...}  ⇒ 要素1
  #                  ,{"id"=>"query_2", "type"=>"insert", ...}  ⇒ 要素2
  #                 ]
  #                , ...
  #               }
  #   result = getJsonChunkById(json_data, "sqls", "query_1")
  #     ⇒ 要素1 を返却
  #   result = getJsonChunkById(json_data, "reqults", "query_1")
  #     ⇒ false を返却(results はない)
  #   result = getJsonChunkById(json_data, "sqls", "query_3")
  #     ⇒ false を返却(query_3 はない)
  #
  #----------------------------------------------------------------------------
  # もう少し複雑な説明(本当はこうなっています)
  # 入力値:
  #   json_obj: 検索対象のJSONオブジェクト(ハッシュ)
  #   section_name: セクション名
  #     (文字列・正規表現・インデックス / 又はこれらを含む配列)
  #   id: 検索id(文字列)
  #   *child: 検索された要素の内部を、更に検索する場合に指定
  #     (文字列・正規表現・インデックス / 可変引数)
  # 出力値:
  #   検索された要素
  #
  # section_name は配列で指定できるようになっていて、
  # JSONオブジェクトの最上位から順に指定できます
  # 使用例で、
  #   JSON1 - sqls のセクションを id の検索対象とする場合は
  #     section_name = ["JSON1", "sqls"]
  #   JSON2 - sqls のセクションを id の検索対象とする場合は
  #     section_name = ["JSON2", "sqls"]
  #   と指定します
  #
  # 使用例:
  #   json_data = {
  #                 "JSON1" =>
  #                 {
  #                   ...
  #                  ,"sqls"=>
  #                   [
  #                     {"id"=>"query_11", "type"=>"select", ...}  ⇒ 要素1
  #                    ,{"id"=>"query_12", "type"=>"insert", ...}  ⇒ 要素2
  #                   ]
  #                  , ...
  #                 }
  #               }
  #              ,{
  #                 "JSON2" =>
  #                 {
  #                   ...
  #                  ,"sqls"=>
  #                   [
  #                     {"id"=>"query_21", "type"=>"select", ...}  ⇒ 要素3
  #                    ,{"id"=>"query_22", "type"=>"insert", ...}  ⇒ 要素4
  #                   ]
  #                  , ...
  #                 }
  #               }
  #   result = getJsonChunkById(json_data, ["JSON1", "sqls"], "query_12")
  #     ⇒ 要素2 を返却
  #   result = getJsonChunkById(json_data, ["JSON2", "sqls"], "query_21")
  #     ⇒ 要素3 を返却
  #   result = getJsonChunkById(json_data, ["JSON3", "sqls"], "query_31")
  #     ⇒ false を返却(JSON3 - sqls はない)
  #   result = getJsonChunkById(json_data, ["JSON1"], "query_12")
  #     ⇒ false を返却(JSON1 で id 検索を行っても失敗する)
  #
  # *child (可変引数)を設定すると、検索した要素に対して、二次検索を行えます
  # 検索した要素が
  #   {"key_1"=>{"key_1_1"=>"data_1_1", "key_1_2"=>"data_1_2"}}
  # となっている場合の二次検索として、
  # "key_1" を設定すると {"key_1_1"=>"data_1_1", "key_1_2"=>"data_1_2"}
  # "key_1","key_1_2" を設定すると "data_1_2"
  # が得られます
  #
  #   result =
  #     getJsonChunkById(json_data, ["JSON1", "sqls"], "query_12", "type")
  #     ⇒ 要素2 の "type" 要素である、"insert" を返却
  #   result =
  #     getJsonChunkById(json_data, ["JSON2", "sqls"], "query_21", "type")
  #     ⇒ 要素3 の "type" 要素である、"select" を返却
  #   result =
  #     getJsonChunkById(json_data, ["JSON2", "sqls"], "query_21", "name")
  #     ⇒ false を返却(要素3 に "name" 要素はない)
  #
  def getJsonChunkById(json_obj, section_name, id, *child)
    result = false
    # セクション(ハッシュの配列)を求める
    if section_obj = digHashArrayByKey(json_obj, section_name)
      # セクションが配列であること
      if section_obj.instance_of?(Array)
        # セクション内を検索
        section_obj.each do |temp|
          # 配列要素がハッシュであり、キー「id」を持つものを戻り値とする
          if temp.instance_of?(Hash)
            if temp["id"] == id
              result = temp
            end
          end
        end
      end
    end

    # *child が設定されている場合は、更に戻り値に対しての検索を行う
    if result && child.length > 0
      result = digHashArrayByKey(result, child)
    end

    # 戻り値の返却
    return result
  end

  # ハッシュオブジェクト・配列オブジェクトから、
  # 任意のキーに該当する要素を求めて返却します
  # 該当要素がない場合は false を返却します
  #
  # 入力値:
  #   data_obj: 検索対象のオブジェクト(ハッシュ・配列)
  #   key_obj: 検索キー(文字列・正規表現・インデックス / 又はこれらを含む配列)
  # 出力値:
  #   検索された要素
  #
  # 基本的な使用例:
  #   data_obj_1 = {"A"=>"a", "B"="b"}
  #   part_of_obj = digHashArrayByKey(data_obj_1, "A")  ⇒ "a"
  #   part_of_obj = digHashArrayByKey(data_obj_1, "C")  ⇒ false
  #   data_obj_2 = ["A", "B"]
  #   part_of_obj = digHashArrayByKey(data_obj_2, 0)  ⇒ "A"
  #   part_of_obj = digHashArrayByKey(data_obj_2, 2)  ⇒ false
  #
  # 複雑な使用例:
  #   key_obj に複数の値を設定した場合は、要素を再帰的に検索します
  #   data_obj_3 = {"A"=>{"Aa"=>"aa", "Ab"=>"ab"},"B"=>["BA", "BB"]}
  #   part_of_obj = digHashArrayByKey(data_obj_3, ["A", "Ab"])  ⇒ "ab"
  #   part_of_obj = digHashArrayByKey(data_obj_3, ["B", 1])  ⇒ "BB"
  #   part_of_obj = digHashArrayByKey(data_obj_3, ["B", 2])  ⇒ false
  #   part_of_obj = digHashArrayByKey(data_obj_3, ["C"])  ⇒ false
  #
  def digHashArrayByKey(data_obj, key_obj)
    result = false
    key_length = 0
    #-- 検索キーを求める -----
    # 検索キーのクラスに応じて処理を分ける
    case key_obj.class.name
    # 配列の場合は、先頭要素を検索キーとする
    when "Array"
      search_key = key_obj.shift
      key_length = key_obj.length
    # 整数・文字列・正規表現の場合はそのまま検索キーとする
    when "Fixnum", "String", "Regexp"
      search_key = key_obj
    # 上記以外は処理終了
    else
      return result
    end
    #-- 検索実行 -----
    # 検索対象のクラスに応じて処理を分ける
    case data_obj.class.name
    # 検索対象がハッシュの場合はキーで検索
    when "Hash"
      # 検索キーのクラスにより、処理を分ける
      case search_key.class.name
      # 文字列による検索
      when "String"
        temp = data_obj.select{|key, val| search_key == key}.values[0]
      # 正規表現による検索
      when "Rgexp"
        temp = data_obj.select{|key, val| search_key =~ key}.values[0]
      end
    # 検索対象が配列の場合はインデックスで検索
    when "Array"
      if search_key.class.name == "Fixnum"
        temp = data_obj[search_key]
      end
    end
    #-- 戻り値の返却・再帰検索 -----
    if temp
      if key_length > 0
        result = digHashArrayByKey(temp, key_obj)
      else
        result = temp
      end
    end
    return result
  end

end

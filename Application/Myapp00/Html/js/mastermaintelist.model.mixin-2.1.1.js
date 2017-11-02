/* ************************************************************************* */
/*  マスターメンテ　一覧表　パターン                                         */
/*  モデル　ミックスイン                                                     */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.MasterMainteListModelMixin = {
    // --------
    // 処理開始
    // --------
    initExecute: function() {
      $R.log("Model initExecute : start");

      this.dataset.clearDataValue();                   // Datasetの値をクリアする
      this.dataset.clearFormElementNo();               // フォームオブジェクトの要素番号をクリアする
      this.dataset.setFormElementNo();                 // フォームオブジェクトの要素番号を設定する

      $R.log("Model initExecute : end");
    }
    // -------------------------------------------------------------------
    //  セッションストレージからログイン情報を取得し表示イベントを発行する
    // -------------------------------------------------------------------
   ,getログイン情報: function() {
      $R.log("Model getログイン情報 : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + ".Login");

      var username = sessionStorage.loadItem("ユーザ名称");
      var datetime = sessionStorage.loadItem("ログイン時刻");
      var jdate    = "";
      if ( sessionStorage.isKeyExists("ログイン和暦") ) {
        jdate      = sessionStorage.loadItem("ログイン和暦");
      }
      var arg      = {ユーザ名称: username, ログイン時刻: datetime, ログイン和暦: jdate};
      this.pubsub.publish("showログイン情報", arg);

      $R.log("Model getログイン情報 : end");
    }
    // -------------------------------------------------------------------
    //  初期処理
    // -------------------------------------------------------------------
   ,on初期処理: function() {
      $R.log("Model on初期処理 : start");

      var arg = {};
      this.pubsub.publish("show初期処理", arg);

      $R.log("Model on初期処理 : end");
    }
    // -----------------------------------------------------------------
    //  ページ情報を編集し、表示イベントを発行する
    // -----------------------------------------------------------------
   ,onDeriveトータル件数: function(arg) {
      $R.log("Model onDeriveトータル件数 : start");

      var pageline   = this.dataset.getElementData("ページライン数");
      var curpage    = this.dataset.getElementData("カレントページ");
      var maxpage    = this.dataset.getElementData("最大ページ");
      var totalcount = this.dataset.getElementData("トータル件数");
      if (totalcount == "") {
        totalcount   = "0";
      }
      var arg = {ページライン数: pageline, カレントページ: curpage, 最大ページ: maxpage, トータル件数: totalcount};
      this.pubsub.publish("showページ情報", arg);

      $R.log("Model onDeriveトータル件数 : end");
    }
    // -------------------------------------------
    //  ページネーション最初処理
    // -------------------------------------------
   ,on最初のページ: function() {
      $R.log("Model on最初のページ : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      var dataset    = this.dataset.getData();
      var detailInfo = this.appspec.getJSONChunkByIdAtRecords(dataset, "detail");
      var pageline   = detailInfo["defaultline"];
      sessionStorage.saveItem("ページライン数", pageline);
      sessionStorage.saveItem("カレントページ", 1);

      this.dataset.setElementData(pageline, "ページライン数");
      this.dataset.setElementData(1, "カレントページ");

      sessionStorage.saveItem("処理モード", "");

      $R.log("Model on最初のページ : end");
    }
    // -------------------------------------------
    //  ページネーション前へ処理
    // -------------------------------------------
   ,on前のページ: function() {
      $R.log("Model on前のページ : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      var pageline = sessionStorage.loadItem("ページライン数");
      this.dataset.setElementData(pageline, "ページライン数");

      var pageno = parseInt(sessionStorage.loadItem("カレントページ"));
      pageno     = pageno - 1;
      if (pageno < 1) {
        pageno   = 1;
      }
      sessionStorage.saveItem("カレントページ", pageno);
      this.dataset.setElementData(pageno, "カレントページ");

      sessionStorage.saveItem("処理モード", "");

      $R.log("Model on前のページ : end");
    }
    // -------------------------------------------
    //  ページネーション次へ処理
    // -------------------------------------------
   ,on次のページ: function() {
      $R.log("Model on次のページ : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      var pageline = sessionStorage.loadItem("ページライン数");
      this.dataset.setElementData(pageline, "ページライン数");

      var maxpage = parseInt(this.dataset.getElementData("最大ページ"));
      var pageno  = parseInt(sessionStorage.loadItem("カレントページ"));
      pageno      = pageno + 1;
      if (pageno > maxpage) {
        pageno    = maxpage;
      }
      sessionStorage.saveItem("カレントページ", pageno);
      this.dataset.setElementData(pageno, "カレントページ");

      sessionStorage.saveItem("処理モード", "");

      $R.log("Model on次のページ : end");
    }
    // -------------------------------------------
    //  ページネーション最後処理
    // -------------------------------------------
   ,on最後のページ: function() {
      $R.log("Model on最後のページ : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      var pageline = sessionStorage.loadItem("ページライン数");
      this.dataset.setElementData(pageline, "ページライン数");

      var pageno = this.dataset.getElementData("最大ページ");
      sessionStorage.saveItem("カレントページ", pageno);
      this.dataset.setElementData(pageno, "カレントページ");

      sessionStorage.saveItem("処理モード", "");

      $R.log("Model on最後のページ : end");
    }
    // -------------------------------------------
    //  ページネーションリロード処理
    // -------------------------------------------
   ,onリロード: function() {
      $R.log("Model onリロード : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      var pageline = sessionStorage.loadItem("ページライン数");
      var pageno   = sessionStorage.loadItem("カレントページ");

      this.dataset.setElementData(pageline, "ページライン数");
      this.dataset.setElementData(pageno, "カレントページ");

      $R.log("Model onリロード : end");
    }
    // ---------------------------------
    //  セッション情報をクリアする
    // ---------------------------------
   ,clearセッション情報: function() {
      $R.log("Model clearページ情報 : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      sessionStorage.deleteAll("");

      // セッションデータに識別名を設定する 2015.10.07 shimoji 追加
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.nextname);
      sessionStorage.deleteAll("");

      $R.log("Model clearページ情報 : end");
    }
    // -------------------------------------------------------
    //  処理モードをセッションストレージに格納する
    // -------------------------------------------------------
   ,set処理モード: function(mode) {
      $R.log("Model set処理モード : start");

      // セッションデータに識別名を設定する 2015.10.07 shimoji 訂正
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      sessionStorage.saveItem("処理モード", mode);

      var row        = sessionStorage.loadItem("クリック行");
			var id         = 0;
			var fromNumber = 0;  // 2015.10.14 追加（shimoji）
			var toNumber   = 0;  // 2015.10.14 追加（shimoji）
			if (row != "") {
        var dataset    = this.dataset.getData();
        var detailInfo = this.appspec.getJSONChunkByIdAtRecords(dataset, "detail");
        id             = detailInfo["record"]["テーブルＩＤ"]["value"][row]
        fromNumber     = detailInfo["record"]["表示順"]["value"][row]              // 2015.10.14 追加（shimoji）
        toNumber       = detailInfo["record"]["表示順"]["value"][Number(row) + 1]  // 2015.10.14 追加（shimoji）
			}

      // セッションデータに識別名を設定する 2015.10.07 shimoji 訂正
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.nextname);
      sessionStorage.saveItem("処理モード", mode);
      sessionStorage.saveItem("テーブルＩＤ", id);
      sessionStorage.saveItem("fromNumber", fromNumber);
      sessionStorage.saveItem("toNumber", toNumber);

      $R.log("Model set処理モード : end");
      return true;
    }
    // -------------------------------------------------------
    //  テーブルの選択行をセッションストレージに格納する
    // -------------------------------------------------------
   ,onテーブル行クリック: function(arg) {
      $R.log("Model onテーブル行クリック : start");

      var clickRow  = arg["クリック行"] - 1;

      var dataset    = this.dataset.getData();
      var detailInfo = this.appspec.getJSONChunkByIdAtRecords(dataset, "detail");
      var value      = detailInfo["record"]["テーブルＩＤ"]["value"][clickRow];
      if (value == "0") {
        this.pubsub.publish("onテーブル行クリック", arg);
        $R.log("Model onテーブル行クリック : end");
        return;
      }
      if (value) {
        this.pubsub.publish("onテーブル行クリック", arg);
      }

      $R.log("Model onテーブル行クリック : end");
    }
    // -------------------------------------------------------
    //  データが選択されているかチェックする
    // -------------------------------------------------------
   ,check行選択: function() {
      $R.log("Model check行選択 : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      var value = sessionStorage.loadItem("クリック行");
      if (value) return true;

			// 2015.10.14 追加（shimoji）
      var dataset    = this.dataset.getData();
      var detailInfo = this.appspec.getJSONChunkByIdAtRecords(dataset, "detail");
			if (detailInfo["record"]["テーブルＩＤ"]["value"].length != 0) {
				if (value != "") {
				  return true;
				}
			}
			
      var arg = {};
      arg["title"]   = "選択エラー";
      arg["status"]  = "ERROR";
      arg["message"] = "行が選択されていません。選択して下さい。";
      this.pubsub.publish("alertDialog", arg);

      $R.log("Model check行選択 : end");
      return false;
    }
    // ---------------------------------------------------
    //  メンテナンス画面呼び出し（次画面呼び出し）準備処理
    // ---------------------------------------------------
   ,onメンテナンス画面表示: function() {
      $R.log("Model onメンテナンス画面表示 : start");

      $R.log("Model onメンテナンス画面表示 : end");
    }
    // -----------------------------------
    //  リクエストデータ　チェック処理
    // -----------------------------------
   ,onメインテーブル照会OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller onメインテーブル照会OfCheckRequestData : start");

      $R.log("Controller onメインテーブル照会OfCheckRequestData : end");
      return true;
    }
   ,on表示順再設定OfCheckRequestData: function(requestData, mode) {
      $R.log("Model on表示順再設定OfCheckRequestData : start");

      $R.log("Model on表示順再設定OfCheckRequestData : end");
      return true;
    }
    // -------------------------------------------------------
    //  メインテーブル照会　レスポンスデータ　編集処理
    // -------------------------------------------------------
   ,onメインテーブル照会OfEditResponseData: function(responseData) {
      $R.log("Model onメインテーブル照会OfEditResponseData : start");

      var tableData = this.appspec.getJSONChunkByIdAtRecords(responseData, "detail");
      var arg       = {テーブルＩＤ: "mainTable", テーブルデータ: tableData};
      this.pubsub.publish("onテーブル表示", arg);

      $R.log("Model onメインテーブル照会OfEditResponseData : end");
    }
   ,on表示順再設定OfEditResponseData: function(responseData) {
      $R.log("Model on表示順再設定OfEditResponseData : start");

      this.onメインテーブル照会OfEditResponseData(responseData);
			
      $R.log("Model on表示順再設定OfEditResponseData : end");
    }

  };
}(jQuery, Rmenu));

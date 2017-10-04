/* ************************************************************************* */
/*  マスター　選択画面　パターン                                             */
/*  モデル　ミックスイン                                                     */
/*  （明細の削除行をサーバに送信し、テーブルの削除フラッグを更新する）       */
/*  2017/09/06 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.DataSelectionModelMixin = {
    // --------
    // 処理開始
    // --------
    initExecute: function() {
      $R.log("Model initExecute : start");

      var dataSet = this.dataset.getData();
      this.clearDatasetJson(dataSet);

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
      var jdate    = sessionStorage.loadItem("ログイン和暦");
      var arg      = {ユーザ名称: username, ログイン時刻: datetime, ログイン和暦: jdate};

      $R.log("Model getログイン情報 : end");
      return arg;
    }
    // -------------------------------------------------------------------
    //  初期処理
    // -------------------------------------------------------------------
   ,on初期処理: function() {
      $R.log("Model on初期処理 : start");

      var arg             = {};
      var dataSet         = this.dataset.getData();
      arg["データセット"] = dataSet;

      $R.log("Model on初期処理 : end");
      return arg;
    }

    // ---------------------------------------
    // ボタン・ファンクションキー イベント処理
    // ---------------------------------------
   ,onクリア: function() {
      $R.log("Model onクリア : start");

      // データセットを設定する
      var dataSet = this.dataset.getData();

      this.clearSessionStorageOfKeyInfo(this.appspec.sessionStorageHeaderKey);
      this.setFromSessionStorageToDatasetOfKeyInfo(dataSet, this.appspec.sessionStorageHeaderKey);
      
      $R.log("Model onクリア : end");
      return dataSet;
    }

    // -------------------------------------------------------
    //  テーブルの選択行をセッションストレージに格納する
    // -------------------------------------------------------
   ,onテーブル行クリック: function(arg) {
      $R.log("Model onテーブル行クリック : start");

      var clickRow = arg["クリック行"] - 1;

      // データセットを取得する
      var dataSet = this.dataset.getData();

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      // 画面明細　キー定義情報をセッションストレージにセイブする
      var datasetID     = this.appspec.sessionStorageDetailKey[0]["datasetid"];
      var datasetRecord = this.appspec.getJSONChunkByIdAtRecords(dataSet, datasetID)["record"];
      var maxSize       = this.appspec.sessionStorageDetailKey[0]["dataname"].length;
      for (var i = 0; i < maxSize; i++) {
        var itemName = this.appspec.sessionStorageDetailKey[0]["dataname"][i]
        sessionStorage.saveItem(itemName, datasetRecord[itemName]["value"][clickRow]);
      }

      $R.log("Model onテーブル行クリック : end");
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
      sessionStorage.deleteItem("クリック行");

      this.dataset.setElementData(pageline, "ページライン数");
      this.dataset.setElementData(1, "カレントページ");

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
      sessionStorage.deleteItem("クリック行");

      this.dataset.setElementData(pageno, "カレントページ");

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
      sessionStorage.deleteItem("クリック行");

      this.dataset.setElementData(pageno, "カレントページ");

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
      sessionStorage.deleteItem("クリック行");

      this.dataset.setElementData(pageno, "カレントページ");

      $R.log("Model on最後のページ : end");
    }
    
    // ---------------------------------
    //  セッション情報をクリアする
    // ---------------------------------
   ,clearセッション情報: function() {
      $R.log("Model clearページ情報 : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      sessionStorage.deleteAll("");

      $R.log("Model clearページ情報 : end");
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

      var arg = {};
      arg["title"]   = "選択エラー";
      arg["status"]  = "ERROR";
      arg["message"] = "行が選択されていません。選択して下さい。";
      this.pubsub.publish("alertDialog", arg);

      $R.log("Model check行選択 : end");
      return false;
    }

    // -------------------------------------------------------
    //  メインテーブル照会　レスポンスデータ　編集処理
    // -------------------------------------------------------
   ,onメインテーブル照会OfEditResponseData: function(responseData, mode) {
      $R.log("Model onメインテーブル照会OfEditResponseData : start");

      var dataSet = this.dataset.getData();
      this.setJsonRecordsToDataset(responseData, dataSet, this.pubsub);

      $R.log("Model onメインテーブル照会OfEditResponseData : end");
      return dataSet;
    }
    
    // -----------------------------------
    //  サーバ処理確認ダイアログを表示する
    // -----------------------------------
   ,onサーバ処理確認ダイアログ: function(responseData) {
      $R.log("Model onサーバ処理確認ダイアログ : start");

      var status = responseData["message"]["status"];
      var msg    = responseData["message"]["msg"];
      var arg    = {title: "サーバ処理確認", status: status, message: msg};
      this.pubsub.publish("serverDialog", arg);

      $R.log("Model onサーバ処理確認ダイアログ : end");
    }
    // ------------------------------------------------------------------------
    // 処理起動確認ダイアログ後の処理
    // ------------------------------------------------------------------------
   ,onConfirmDialogAfter: function() {
      $R.log("Model onConfirmDialogAfter : start");

      $R.log("Model onConfirmDialogAfter : end");
    }
   ,onExecuteDialogAfter: function() {
      $R.log("Model onExecuteDialogAfter : start");

      $R.log("Model onExecuteDialogAfter : end");
    }
   ,onServerDialogAfter: function() {
      $R.log("Model onServerDialogAfter : start");

      $R.log("Model onServerDialogAfter : end");
    }

  };
}(jQuery, Rmenu));

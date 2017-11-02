/* ************************************************************************* */
/*  基本名称メンテ　パターン                                                 */
/*  モデル　ミックスイン                                                     */
/*  （明細の削除行をサーバに送信し、テーブルの削除フラッグを更新する）       */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.BaseNameMainteModelMixin = {
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
      var jdate    = sessionStorage.loadItem("ログイン和暦");
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
    // ---------------------------------
    //  セッション情報をクリアする
    // ---------------------------------
   ,clearページ情報: function() {
      $R.log("Model clearページ情報 : start");

      $R.log("Model clearページ情報 : end");
    }
    // ---------------------------------------
    // 行追加 クリックイベント処理
    // ---------------------------------------
   ,on行追加クリック: function(row) {
      $R.log("Model on行追加クリック : start");

      // デフォルトラインを設定する
      var dataSet       = this.dataset.getData();
      var dataSetRecord = this.appspec.getJSONChunkByIdAtRecords(dataSet, "detail");
      var defaultline   = dataSetRecord["defaultline"];

      // 項目名でハッシュを作成し、配列を格納する
      var detailRecord  = dataSetRecord["record"];
      var detailHash    = {};
      var name;
      for (name in detailRecord) {
        detailHash[name] = [];
      }

      // 空行を除いたデータの配列を作成する
      var deleteCheckBox = $(".削除");
      for (var i = 0; i < defaultline; i++) {
        // 行の全項目が空かを判定する
        var emptySW = true;
        for (name in detailRecord) {
          if ( (name == "更新日時") || (name == "行追加") || (name == "削除") ) {
            continue;
          }
          
          var value = detailRecord[name]["value"][i];
          if (value === undefined) {
            continue;
          }
          if (value != "") {
            emptySW = false;
            break;
          }
        }

        // 空行かの判定、空行の時次の行へ
        if (emptySW) {
          continue;
        }

        // データを配列に追加する
        for (name in detailRecord) {
          if (name == "削除") {           
            if ( $(deleteCheckBox[i] ).is(':checked') ) {
              detailHash["削除"].push("9");
            }
            else {
              detailHash["削除"].push("0");
            }
            
            // 行追加
            if (i == row) {
              detailHash["削除"].push("0");
            }
          }
          else {
            detailHash[name].push(detailRecord[name]["value"][i]);
            if (i != row) {
              continue;
            }
            
            if (name.indexOf("表示順") == -1) {
              detailHash[name].push("");
              continue;
            }
            
            var value1 = detailRecord[name]["value"][i];
            var value2 = detailRecord[name]["value"][i + 1];
            var line   = 0;
            if (value2) {
              line = new BigNumber(value1).plus(value2).div(2).round(0,1).toPrecision();
            }
            else {
              line = new BigNumber(value1).plus(10).toPrecision();
            }
            detailHash[name].push(line);
          }
        }
      }

      // 作成した配列をリクエストデータにセットする
      for (name in detailRecord) {
        detailRecord[name]["value"] = detailHash[name];
      }

      var arg = {"テーブルＩＤ": "mainTable", "テーブルデータ": dataSetRecord};
      
      $R.log("Model on行追加クリック : end");
      return arg;
    }
    // ---------------------------------------------------
    //  リクエストデータ　編集・チェック処理
    // ---------------------------------------------------
   ,onメインテーブル照会OfCheckRequestData: function(requestData, mode) {
      $R.log("Model onメインテーブル照会OfCheckRequestData : start");

      $R.log("Model onメインテーブル照会OfCheckRequestData : end");
      return true;
    }
   ,on表示順再設定OfCheckRequestData: function(requestData, mode) {
      $R.log("Model on表示順再設定OfCheckRequestData : start");

      $R.log("Model on表示順再設定OfCheckRequestData : end");
      return true;
    }
   ,on実行処理OfCheckRequestData: function(requestData, mode) {
      $R.log("Model on実行処理OfCheckRequestData : start");
      
      // ログイン情報を設定する
      var requestRecord = this.appspec.getJSONChunkByIdAtRecords(requestData, "login");
      var loginRecord   = requestRecord["record"];

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + ".Login");
      loginRecord["ユーザＩＤ"]["value"][0] = sessionStorage.loadItem("ユーザＩＤ");
      loginRecord["ユーザ名称"]["value"][0] = sessionStorage.loadItem("ユーザ名称");
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      // デフォルトラインを設定する
      var dataSet       = this.dataset.getData();
      var dataSetRecord = this.appspec.getJSONChunkByIdAtRecords(dataSet, "detail");
      var defaultline   = 1;
      if (dataSetRecord["multiline"] == "yes") {
        defaultline   = dataSetRecord["defaultline"];
      }

      // 項目名でハッシュを作成し、配列を格納する
      var requestRecord = this.appspec.getJSONChunkByIdAtRecords(requestData, "detail");
      var detailRecord  = requestRecord["record"];
      var detailHash    = {};
      var name;
      for (name in detailRecord) {
        detailHash[name] = [];
      }

      // 空行を除いたデータの配列を作成する
      var deleteCheckBox = $(".削除");
      for (var i = 0; i < defaultline; i++) {
        // 行の全項目が空かを判定する
        var emptySW = true;
        for (name in detailRecord) {
          if (name == "削除") {
            continue;
          }
          
          var value = detailRecord[name]["value"][i];
          if (value === undefined) {
            continue;
          }
          if (value != "") {
            emptySW = false;
            break;
          }
        }

        // 空行かの判定、空行の時次の行へ
        if (emptySW) {
          continue;
        }

        // データを配列に追加する
        for (name in detailRecord) {
          if (name == "削除") {
            if ( $(deleteCheckBox[i] ).is(':checked') ) {
              detailHash["削除"].push("9");
            }
            else {
              detailHash["削除"].push("0");
            }
          }
          else {
            detailHash[name].push(detailRecord[name]["value"][i]);
          }
        }
      }

      // 作成した配列をリクエストデータにセットする
      for (name in detailRecord) {
        detailRecord[name]["value"] = detailHash[name];
      }

      $R.log("Model on実行処理OfCheckRequestData : end");
      return true;
    }
    // -------------------------------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------------------------------
   ,onメインテーブル照会OfEditResponseData: function(responseData) {
      $R.log("Model onメインテーブル照会OfEditResponseData : start");

      var dataSet     = this.dataset.getData();
      var detailData  = this.appspec.getJSONChunkByIdAtRecords(dataSet, "detail");
      var defaultline = detailData["defaultline"];

      // データセットと削除チェックボックスに値を設定する
      var deleteCheckBox = $(".削除");
      if (deleteCheckBox.length > 0) {
        for (var i = 0; i < defaultline; i++) {
          detailData["record"]["削除"]["value"][i] = "";
          $(deleteCheckBox[i]).prop("checked", false);
        }
      }

      $R.log("Model onメインテーブル照会OfEditResponseData : end");
    }
   ,on表示順再設定OfEditResponseData: function(responseData) {
      $R.log("Model on表示順再設定OfEditResponseData : start");

      var dataSet     = this.dataset.getData();
      var detailData  = this.appspec.getJSONChunkByIdAtRecords(dataSet, "detail");
      var defaultline = detailData["defaultline"];

      // データセットと削除チェックボックスに値を設定する
      var deleteCheckBox = $(".削除");
      if (deleteCheckBox.length > 0) {
        for (var i = 0; i < defaultline; i++) {
          detailData["record"]["削除"]["value"][i] = "";
          $(deleteCheckBox[i]).prop("checked", false);
        }
      }

      $R.log("Model on表示順再設定OfEditResponseData : end");
    }
   ,on実行処理OfEditResponseData: function(responseData) {
      $R.log("Model on実行処理OfEditResponseData : start");

      this.onメインテーブル照会OfEditResponseData(responseData);
      this.onサーバ処理確認ダイアログ(responseData);

      $R.log("Model on実行処理OfEditResponseData : end");
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

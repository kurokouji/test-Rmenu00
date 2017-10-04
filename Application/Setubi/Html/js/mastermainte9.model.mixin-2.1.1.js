/* ************************************************************************* */
/*  マスター　メンテ　パターン                                               */
/*  モデル　ミックスイン                                                     */
/*  （明細の削除行はサーバに送信しない。）                                   */
/*  （サーバ側の処理は、削除＆登録処理を行う）                               */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.MasterMainteModelMixin9 = {
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

      // セッションデータに識別名を設定する
			// 20151007 shimoji 訂正
      //sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.beforename);
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var mode = sessionStorage.loadItem("処理モード");

      var arg = {処理モード: mode};
      this.pubsub.publish("showヘッダータイトル", arg);
      this.pubsub.publish("show初期処理", arg);

      $R.log("Model on初期処理 : end");
    }
    // ----------------------------------------
    // テーブルＩＤをデータセットに格納する
    // ----------------------------------------
   ,setテーブルＩＤ: function() {
      $R.log("Model setテーブルＩＤ : start");

      // セッションデータに識別名を設定する
			// 20151007 shimoji 訂正
      //sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.beforename);
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      var id = sessionStorage.loadItem("テーブルＩＤ");
      this.dataset.setElementData(id, "テーブルＩＤ");

      $R.log("Model setテーブルＩＤ : end");
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
    // -------------------------------------
    //  リクエストデータ　編集・チェック処理
    // -------------------------------------
   ,on照会OfCheckRequestData: function(requestData, mode) {
      $R.log("Model on照会OfCheckRequestData : start");

      $R.log("Model on照会OfCheckRequestData : end");
      return true;
    }
   ,on登録OfCheckRequestData: function(requestData, mode) {
      $R.log("Model on登録OfCheckRequestData : start");

      var status = this.on訂正OfCheckRequestData(requestData, mode);

      $R.log("Model on登録OfCheckRequestData : end");
      return status;
    }
   ,on訂正OfCheckRequestData: function(requestData, mode) {
      $R.log("Model on訂正OfCheckRequestData : start");

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

      // 空行・削除行を除いたデータの配列を作成する
      var deleteCheckBox = $(".削除");
      for (var i = 0; i < defaultline; i++) {
        // 削除行かを判定する　削除行の時次の行へ
        if ( $(deleteCheckBox[i] ).is(':checked') ) {
          continue;
        }

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

        // 空行の判定、空行の時次の行へ
        if (emptySW) {
          continue;
        }

        // データを配列に追加する
        for (name in detailRecord) {
          detailHash[name].push(detailRecord[name]["value"][i]);
        }
      }

      // 作成した配列をリクエストデータにセットする
      for (name in detailRecord) {
        detailRecord[name]["value"] = detailHash[name];
      }

      $R.log("Model on訂正OfCheckRequestData : end");
      return true;
    }
   ,on削除OfCheckRequestData: function(requestData, mode) {
      $R.log("Model on削除OfCheckRequestData : start");

      // ログイン情報を設定する
      var requestRecord = this.appspec.getJSONChunkByIdAtRecords(requestData, "login");
      var loginRecord   = requestRecord["record"];

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + ".Login");
      loginRecord["ユーザＩＤ"]["value"][0] = sessionStorage.loadItem("ユーザＩＤ");
      loginRecord["ユーザ名称"]["value"][0] = sessionStorage.loadItem("ユーザ名称");
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      $R.log("Model on削除OfCheckRequestData : end");
      return true;
    }
    // -------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------
   ,on照会OfEditResponseData: function(responseData, mode) {
      $R.log("Model on照会OfEditResponseData : start");

      $R.log("Model on照会OfEditResponseData : end");
    }
   ,on登録OfEditResponseData: function(responseData, mode) {
      $R.log("Model on登録OfEditResponseData : start");
			
			this.on訂正OfEditResponseData(responseData, mode);

      $R.log("Model on登録OfEditResponseData : end");
    }
   ,on訂正OfEditResponseData: function(responseData, mode) {
      $R.log("Model on訂正OfEditResponseData : start");

			// デフォルトラインを設定する
      var dataSet       = this.dataset.getData();
      var dataSetRecord = this.appspec.getJSONChunkByIdAtRecords(dataSet, "detail");
      var defaultline   = 1;
      if (dataSetRecord["multiline"] == "yes") {
        defaultline   = dataSetRecord["defaultline"];
      }

      // 空行・削除行を除いたデータの配列を作成する
      var deleteCheckBox = $(".削除");
      for (var i = 0; i < defaultline; i++) {
        // チェックボックスをクリアする
        if ( $(deleteCheckBox[i]) ) {
				  $(deleteCheckBox[i]).prop("checked", false);
        }
      }

			this.onサーバ処理確認ダイアログ(responseData);

      $R.log("Model on訂正OfEditResponseData : end");
    }
   ,on削除OfEditResponseData: function(responseData, mode) {
      $R.log("Model on削除OfEditResponseData : start");

			this.onサーバ処理確認ダイアログ(responseData);

      $R.log("Model on削除OfEditResponseData : end");
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

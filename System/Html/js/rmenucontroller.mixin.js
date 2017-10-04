(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.ControllerMixin = {
    // フレームワーク内部イベント設定（イベント名・実行コンテキスト・コールバック関数）
   pubsubRmenuEvent: [
      ["dataformat",         "view",       "onDataFormat"]
     ,["dataunformat",       "view",       "onDataUnformat"]
     ,["guidemessage",       "view",       "onGuideMessage"]
     ,["errorToolTip",       "view",       "onErrorToolTip"]
     ,["removeToolTip",      "view",       "onRemoveToolTip"]
     ,["alertDialog",        "view",       "onAlertDialog"]
     ,["confirmDialog",      "view",       "onConfirmDialog"]
     ,["confirmDialogAfter", "model",      "onConfirmDialogAfter"]
     ,["executeDialog",      "view",       "onExecuteDialog"]
     ,["executeDialogAfter", "controller", "onExecuteDialogAfter"]
     ,["serverDialog",       "view",       "onServerDialog"]
     ,["serverDialogAfter",  "model",      "onServerDialogAfter"]
    ]
    // Focus処理
   ,onControllerFocus: function(event) {
      $R.log("ControllerMixin onControllerFocus : start");

      this.focusName;                                                 // Focus された要素の name 属性
      this.focusCurRow    = 0;                                        // Focus されたセルの行位置
      this.focusCurCell   = 0;                                        // Focus されたセルの列位置
                                                                      // ※セルの位置は dataset 上の並び順と無関係であることに注意
      this.focusIndex     = 0;                                        // dataset 上の、該当データの位置

      this.focusName  = event.target.name;                            // 対象要素から name 属性を取得
      var isMultiline = this.model.dataset.isMultilineByName(this.focusName);
                                                                      // dataset を走査して multiline かどうかを求める
      // multiline の場合
      if (isMultiline) {
        // データが次の条件で表示されているものと想定して処理します
        // ・表形式であること
        // ・各セル内が、更に個別の表になっていないこと

        //- テーブル上のセル位置を求める ----------
        var targetRowObj = $(event.target).closest('tr');             // 該当要素を含む tr 要素を求める
        var targetCellObj = $(event.target).closest('td,th');         // 該当要素を含む td / th 要素を求める
        if (targetRowObj && targetCellObj) {                          // セル位置を求める
          this.focusCurRow = targetRowObj[0].rowIndex;
          this.focusCurCell = targetCellObj[0].cellIndex;
        }
        //- dataset 上の該当位置を求める ----------
        var sameNameRowObjs = $(document).find('[name="' + this.focusName + '"]').closest('tr');
                                                                      // 同じ name 属性の要素を含む、tr 要素の集合を求める
        this.focusIndex = sameNameRowObjs.index(targetRowObj);        // sameNameRowObjs 上の targetRowObj の位置が
                                                                      // dataset 上の位置に相当します
      }
      // view へコピー
      this.view.focusName    = this.focusName;
      this.view.focusCurRow  = this.focusCurRow;
      this.view.focusCurCell = this.focusCurCell;
      this.view.focusIndex   = this.focusIndex;

      var value = this.model.onFocus(event, this.focusIndex);         // 入力項目の値をdatasetから取得する
      this.view.onFocus(event, value);                                // 値を画面に表示する

      var message = this.model.onFocusMessage(event);                 // 入力ガイドメッセージを作成する
      var arg = {status: "OK", message: message};
      this.view.onGuideMessage(arg);                                  // ガイドメッセージを表示する

      $R.log("ControllerMixin onControllerFocus : end");
    }
    // Blur処理
   ,onControllerBlur: function(event) {
      $R.log("ControllerMixin onControllerBlur : start");

      this.blurName;                                                  // Blur された要素の name 属性
      this.blurCurRow    = 0;                                         // Blur されたセルの行位置
      this.blurCurCell   = 0;                                         // Blur されたセルの列位置
                                                                      // ※セルの位置は dataset と無関係であることに注意
      this.blurIndex     = 0;                                         // dataset 上の、該当データの位置

      this.blurName  = event.target.name;                             // 対象要素から name 属性を取得
      var isMultiline = this.model.dataset.isMultilineByName(this.blurName);
                                                                      // dataset を走査して multiline かどうかを求める
      // multiline の場合
      if (isMultiline) {
        // データが次の条件で表示されているものと想定して処理します
        // ・表形式であること
        // ・各セル内が、更に個別の表になっていないこと

        //- テーブル上のセル位置を求める ----------
        var targetRowObj = $(event.target).closest('tr');             // 該当要素を含む tr 要素を求める
        var targetCellObj = $(event.target).closest('td,th');         // 該当要素を含む td / th 要素を求める
        if (targetRowObj && targetCellObj) {                          // セル位置を求める
          this.blurCurRow = targetRowObj[0].rowIndex;
          this.blurCurCell = targetCellObj[0].cellIndex;
        }
        //- dataset 上の該当位置を求める ----------
        var sameNameRowObjs = $(document).find('[name="' + this.blurName + '"]').closest('tr');
                                                                      // 同じ name 属性の要素を含む、tr 要素の集合を求める
        this.blurIndex = sameNameRowObjs.index(targetRowObj);         // sameNameRowObjs 上の targetRowObj の位置が
                                                                      // dataset 上の位置に相当します
      }
      // view へコピー
      this.view.blurName    = this.blurName;
      this.view.blurCurRow  = this.blurCurRow;
      this.view.blurCurCell = this.blurCurCell;
      this.view.blurIndex   = this.blurIndex;

      this.model.onBlur(event, this.blurIndex);                       // 入力データをdatasetに設定する

      var message = this.model.onBlurDataCheck(event);                // 入力データをチェックする
      if (message["status"] == "OK" || message["no_display_message"] == "yes") {
        this.view.onRemoveToolTip(message);
      }
      else {
        this.view.onErrorToolTip(message);
      }

      this.view.onBlur(event);                                        // 入力データをフォーマットし再表示する

      if (message["status"] == "OK") {
        var target = event.target;
        this.model.onBlurDerive(target, target.value);                // 導出項目編集処理
      }

      $R.log("ControllerMixin onControllerBlur : end");
    }
    // データセットとフォームの値をクリアする
   ,clearFormData: function() {
      $R.log("ControllerMixin clearFormData : start");

      this.model.dataset.clearDataValue();                            // Datasetの値をクリアする
      this.view.clearDataValue();                                     // フォームの値をクリアする

      $R.log("ControllerMixin clearFormData : end");
    }
    // トランザクションを実行する
   ,ajaxExecute: function(mode) {
      $R.log("ControllerMixin ajaxExecute : start");

      var transaction = this.model.getTransaction(mode);
      transaction.clearDataValue();                                   // トランザクションの値をクリアする
      transaction.setDataValue(this.model.dataset);                   // トランザクションに値を設定する
      transaction.ajax(this, mode);

      $R.log("ControllerMixin ajaxExecute : end");
    }
    // リクエストデータをチェックする
   ,checkRequestData: function(data) {
      $R.log("ControllerMixin checkRequestData : start");

      var status = this.model.transactionCheck(data);

      $R.log("ControllerMixin checkRequestData : end");
      return status;
    }
    // レスポンスデータをデータセットとフォームに設定する
   ,editResponseData: function(data) {
      $R.log("ControllerMixin editResponseData : start");

      this.model.dataset.clearResponseValue(data);
      this.view.clearResponseValue(data);
      this.model.dataset.setResponseValue(data, this.pubsub);         // Datasetに値を設定する
      this.view.setResponseValue(data);                               // フォームに値を表示する

      $R.log("ControllerMixin editResponseData : end");
      return data;
    }
    // レスポンスエラー
   ,errorResponseData: function(data) {
      $R.log("ControllerMixin errorResponseData : start");

      var msg = data["message"]["msg"];
      var arg = {title: "サーバエラー", status: "ERROR", message: msg};
      this.pubsub.publish("guidemessage", arg);
      this.pubsub.publish("alertDialog", arg);

      $R.log("ControllerMixin errorResponseData : end");
    }
    // サーバとの接続エラー
   ,connectError: function(XMLHttpRequest, textStatus, errorThrown) {
      $R.log("ControllerMixin responseError : start");

      var arg = {};
      arg["title"]   = "通信エラー";
      arg["status"]  = "ERROR";
      arg["message"] = "サーバとの接続に失敗しました。担当者に連絡して下さい。";
      this.pubsub.publish("guidemessage", arg);
      this.pubsub.publish("alertDialog", arg);

      $R.log("ControllerMixin responseError : end");
    }
    // Dataset同期チェック
   ,synchroCheckDataset: function() {
      $R.log("ControllerMixin synchroCheckDataset : start");

      this.pubsub.model      = this.model;
      this.pubsub.view       = this.view;
      this.pubsub.controller = this;

      this.model.pubsub      = this.pubsub;
      this.view.pubsub       = this.pubsub;

      if (this.model.dataset) {
        this.model.dataset.synchroData(this, "synchroCheckValidation");
      }
      else {
        this.synchroCheckValidation();
      }

      $R.log("ControllerMixin synchroCheckDataset : end");
    }
    // Validation同期チェック
   ,synchroCheckValidation: function() {
      $R.log("ControllerMixin synchroCheckValidation : start");

      if (this.model.dataset) {
        this.view.initExecute(this.model.dataset.data);
      }
      else {
        this.view.initExecute();
      }
      this.model.initExecute();
      var validation = this.model.getValidation();
      if (validation) {
        validation.synchroData(this, "synchroCheckTransaction");
      }
      else {
        this.synchroCheckTransaction();
      }

      $R.log("ControllerMixin synchroCheckValidation : end");
    }
    // Transaction同期チェック
   ,synchroCheckTransaction: function() {
      $R.log("ControllerMixin synchroCheckTransaction : start");

      var dataset = this.model.getDataset();
      if (dataset) {
        this.view.copyFormElementNo(dataset.elementno);
      }

      var validation = this.model.getValidation();
      if (validation) {
        this.view.copyFormat(validation.getData());
      }

      var requestInfo   = this.appspec.requestInfo;
      if (requestInfo.length > 0) {
        var tranname    = requestInfo[0][0];
        var transaction = this.model.getTransaction(tranname);
        transaction.synchroData(this, "initExecute");
      }
      else {
        this.initExecute();
      }

      $R.log("ControllerMixin synchroCheckTransaction : end");
    }
  };
}(jQuery, Rmenu));

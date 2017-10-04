/* ************************************************************************* */
/*  マスター　メンテ　パターン                                               */
/*  コントローラ　ミックスイン                                               */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.MasterMainte2ControllerMixin = {
    // --------
    // 処理開始
    // --------
    initExecute: function() {
      $R.log("Controller initExecute : start");

      var arg = this.model.getログイン情報();
      this.view.showログイン情報(arg);
      
      this.on初期処理();

      $R.log("Controller initExecute : end");
    }
    
    // ---------------------------------------
    // 初期処理
    // ---------------------------------------
   ,on初期処理: function() {
      $R.log("Controller on初期処理 : start");

      var arg = this.model.on初期処理();
      this.view.on初期処理(arg);
      
      var status = this.model.on選択画面戻り();
      
      // 初期処理を実行するか、選択画面戻り処理を実行する判定する
      if (!status) {
        // 初期処理：前画面の引き継ぎデータをデータセットに設定する
        var status1 = this.model.setFromBeforeStorageDataToDataset();
        //if (status1 == "OK") {
        //  this.ajaxExecute("init");
        //}
        
        sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
        var mode = sessionStorage.loadItem("処理モード");

        if (mode != "insert") {
          this.ajaxExecute("select");
        }

        $R.log("Controller on初期処理 : end");
        return;
      }
      
      // 選択画面の戻り処理
      // データセットを使って、遷移前の画面を復元する
      var dataSet = this.model.dataset.getData();
      
      // ヘッダー部・明細部　復元
      this.view.on照会OfEditResponseData(dataSet, dataSet, "");

      $R.log("Controller on初期処理 : end");
    }
    
    // ------------------------
    // Focus・Blue イベント処理
    // ------------------------
   ,onFocus: function(event) {
      $R.log("Controller onFocus : start");

      this.onControllerFocus(event);

      $R.log("Controller onFocus : end");
    }
    
   ,onBlur: function(event) {
      $R.log("Controller onBlur : start");

      this.onControllerBlur(event);

      $R.log("Controller onBlur : end");
    }
    
    // ---------------------------------------
    // ボタン・ファンクションキー イベント処理
    // ---------------------------------------
   ,on戻る: function(event) {
      $R.log("Controller on戻る : start");

      this.model.clearセッション情報();
      this.model.previousTransition();

      $R.log("Controller on戻る : end");
    }
    
   ,on実行: function(event) {
      $R.log("Controller on実行 : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var mode = sessionStorage.loadItem("処理モード");

      if (mode == "select") return;

      if (mode == "convert") {
        mode = "insert";
      }
      this.ajaxExecute(mode);

      $R.log("Controller on実行 : end");
    }
    
    // ---------------------------------------
    // 行追加 クリックイベント処理
    // データセット：detail
    // 明細テーブル：#mainTable
    // ---------------------------------------
   ,on行追加クリック: function(event) {
      $R.log("Controller on行追加クリック : start");
      
      var row = event.currentTarget.parentNode.parentNode.rowIndex;
      var dataSet = this.model.on行追加クリック(row);
      this.view.on行追加クリック(dataSet);
      
      $R.log("Controller on行追加クリック : end");
    }

    // ---------------------------------------
    // テーブル行　クリック処理処理
    // ---------------------------------------
   ,onテーブル行クリック: function(event, arg) {
      $R.log("Controller onテーブル行クリック : start");

      var row = event.currentTarget.parentNode.parentNode.rowIndex;
      var idName = event.currentTarget.offsetParent.id;
      var arg    = {クリック行: row, セレクタ名: idName};
      this.model.onテーブル行クリック(arg);

      $R.log("Controller onテーブル行クリック : end");
    }
    
    // ------------------------------------------
    // 削除　チェンジ イベント処理（追加処理）
    // ------------------------------------------
   ,onChange削除: function(event) {
      $R.log("Controller onChange削除 : start");
      
      var row = event.currentTarget.parentNode.parentNode.rowIndex;
      this.model.onChangeTableCheckBox(event, row, this.appspec.checkboxDetail);
      
      $R.log("Controller onChange削除 : end");
    }

    // -------------------------------------
    //  リクエストデータ　編集・チェック処理
    // -------------------------------------
   ,on照会OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on照会OfCheckRequestData : start");

      var status = this.model.on照会OfCheckRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller on照会OfCheckRequestData : end");
      return status;
    }
    
   ,on登録OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on登録OfCheckRequestData : start");

      var status = this.model.on登録OfCheckRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller on登録OfCheckRequestData : end");
      return status;
    }
    
   ,on訂正OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on訂正OfCheckRequestData : start");

      var status = this.model.on訂正OfCheckRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller on訂正OfCheckRequestData : end");
      return status;
    }
    
   ,on削除OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on削除OfCheckRequestData : start");

      var status = this.model.on削除OfCheckRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller on削除OfCheckRequestData : end");
      return status;
    }

    // -------------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------------
   ,on照会OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on照会OfEditResponseData : start");
      
      var dataSet = this.model.on照会OfEditResponseData(responseData, mode);
      this.view.on照会OfEditResponseData(dataSet, responseData, mode);

      $R.log("Controller on照会OfEditResponseData : end");
    }
    
   ,on登録OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on登録OfEditResponseData : start");
      
      var jsonRecords = responseData["records"];
      if (jsonRecords === undefined) {
        this.model.onサーバ処理確認ダイアログ(responseData);
        
        $R.log("Controller on登録OfEditResponseData : end");
        return;
      }

      var dataSet = this.model.on登録OfEditResponseData(responseData, mode);
      this.view.on登録OfEditResponseData(dataSet, responseData, mode);
      this.model.onサーバ処理確認ダイアログ(responseData);

      $R.log("Controller on登録OfEditResponseData : end");
    }

    ,on訂正OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on訂正OfEditResponseData : start");

      var jsonRecords = responseData["records"];
      if (jsonRecords === undefined) {
        this.model.onサーバ処理確認ダイアログ(responseData);
        
        $R.log("Controller on訂正OfEditResponseData : end");
        return;
      }

      var dataSet = this.model.on訂正OfEditResponseData(responseData, mode);
      this.view.on訂正OfEditResponseData(dataSet, responseData, mode);
      this.model.onサーバ処理確認ダイアログ(responseData);

      $R.log("Controller on訂正OfEditResponseData : end");
    }

   ,on削除OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on削除OfEditResponseData : start");

      var jsonRecords = responseData["records"];
      if (jsonRecords === undefined) {
        this.model.onサーバ処理確認ダイアログ(responseData);
        
        $R.log("Controller on削除OfEditResponseData : end");
        return;
      }

      var dataSet = this.model.on削除OfEditResponseData(responseData, mode);
      this.view.on削除OfEditResponseData(dataSet, responseData, mode);
      this.model.onサーバ処理確認ダイアログ(responseData);

      $R.log("Controller on削除OfEditResponseData : end");
    }

    // ---------------------------
    //  レスポンス　エラー処理
    // ---------------------------
   ,onErrorResponseData: function(responseData, mode) {
      $R.log("Controller onErrorResponseData : start");

      this.errorResponseData(responseData);

      $R.log("Controller onErrorResponseData : end");
    }

  };
}(jQuery, Rmenu));

/* ************************************************************************* */
/*  基本名称メンテ　パターン                                                 */
/*  コントローラ　ミックスイン                                               */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.BaseDataMainteControllerMixin = {
    // --------
    // 処理開始
    // --------
    initExecute: function() {
      $R.log("Controller initExecute : start");

      var arg = this.model.getログイン情報();
      this.view.setログイン情報(arg);
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
      
      var arg = this.model.on選択画面戻り();
      
      // 選択画面処理終り
      if (arg["status"] == "OK") {
        // 選択画面で選択データ無し
        if (arg["selected"] == "CANCEL") {
          var dataSet = this.model.dataset.getData();
          this.view.on照会OfEditResponseData(dataSet, dataSet, "");
        }
        // 選択画面で選択データ有りで後処理無し
        if (arg["selected"] == "NONFUNCTIN") {
          var dataSet = this.model.dataset.getData();
          this.view.on照会OfEditResponseData(dataSet, dataSet, "");
        }
        
        $R.log("Controller on初期処理 : end");
        return;
      }

      // 初期処理：前画面の引き継ぎデータをデータセットに設定する
      var status1 = this.model.setFromBeforeStorageDataToDataset();
      if (status1 == "OK") {
        var dataSet = this.model.dataset.getData();
        this.view.fromJsonDataToView(dataSet);
      }
        
      this.ajaxExecute("select");

      
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

      this.model.clearページ情報();
      this.model.previousTransition();

      $R.log("Controller on戻る : end");
    }
   ,on実行: function(event) {
      $R.log("Controller on実行 : start");

      this.ajaxExecute("execute");

      $R.log("Controller on実行 : end");
    }
    // ---------------------------------------
    // 行追加 クリックイベント処理
    // ---------------------------------------
   ,on行追加クリック: function(event, arg) {
      $R.log("Controller on行追加クリック : start");

      var row     = event.currentTarget.parentNode.parentNode.rowIndex;
      var dataSet = this.model.on行追加クリック(row);
      this.view.on行追加クリック(dataSet);
      
      $R.log("Controller on行追加クリック : end");
    }
    // ---------------------------------------
    // 表示順再設定 クリックイベント処理
    // ---------------------------------------
   ,on表示順再設定: function(event, arg) {
      $R.log("Controller on表示順再設定 : start");

      this.ajaxExecute("renumber");
      
      $R.log("Controller on表示順再設定 : end");
    }
    // ---------------------------------------
    // チェンジ イベント処理
    // ---------------------------------------
   ,on削除: function(event, arg) {
      $R.log("Controller on削除 : start");

      var row = event.currentTarget.parentNode.parentNode.rowIndex;
      this.model.onChangeTableCheckBox(event, row, this.appspec.checkboxDetail);
      
      $R.log("Controller on削除 : end");
    }
    
   ,on行チェック: function(event, arg) {
      $R.log("Controller on行チェック : start");

      var name = event.currentTarget.name;
      var row  = event.currentTarget.parentNode.parentNode.rowIndex;
      this.model.on行チェック(name, row);
      this.view.on行チェック(name, row);
      
      $R.log("Controller on行チェック : end");
    }
    
    // -----------------------------------
    //  リクエストデータ　チェック処理
    // -----------------------------------
   ,on照会OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on照会OfCheckRequestData : start");

      var status = this.model.on照会OfCheckRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller on照会OfCheckRequestData : end");
      return status;
    }

    ,on実行OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on実行OfCheckRequestData : start");

      var status = this.model.on実行OfCheckRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller on実行OfCheckRequestData : end");
      return status;
    }
    
   ,on表示順再設定OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on表示順再設定OfCheckRequestData : start");

      var status = this.model.on表示順再設定OfCheckRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller on表示順再設定OfCheckRequestData : end");
      return status;
    }
    // -------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------
   ,on照会OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on照会OfEditResponseData : start");

      var dataSet = this.model.on照会OfEditResponseData(responseData, mode);
      this.view.on照会OfEditResponseData(dataSet, responseData, mode);
      
      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var row = sessionStorage.loadItem("クリック行");
      if (row === undefined) {
      }
      else {
        var name = sessionStorage.loadItem("クリック名");
        this.model.on行チェック(name, row);
        this.view.on行チェック(name, row);
      }

      $R.log("Controller on照会OfEditResponseData : end");
    }

    ,on実行OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on実行OfEditResponseData : start");

      var dataSet = this.model.on照会OfEditResponseData(responseData, mode);
      this.view.on照会OfEditResponseData(dataSet, responseData, mode);

      this.model.onサーバ処理確認ダイアログ(responseData);

      $R.log("Controller on実行OfEditResponseData : end");
    }
    
   ,on表示順再設定OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on表示順再設定OfEditResponseData : start");

      var dataSet = this.model.on照会OfEditResponseData(responseData, mode);
      this.view.on照会OfEditResponseData(dataSet, responseData, mode);

      this.model.onサーバ処理確認ダイアログ(responseData);

      $R.log("Controller on表示順再設定OfEditResponseData : end");
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

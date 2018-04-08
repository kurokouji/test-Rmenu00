/* ************************************************************************* */
/*  マスターメンテ　一覧表（登録・訂正用）　パターン                         */
/*  コントローラ　ミックスイン                                               */
/*  2017/06/12 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.DataMainteListControllerMixin = {
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

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var currentpage = sessionStorage.loadItem("カレントページ");
      
      if (currentpage === undefined) {
        // メニュー画面または別一覧画面から呼び出された時
        // 別の一覧画面からの引き継ぎデータをデータセットに設定する
        this.model.setFromBeforeStorageDataToDataset();
        this.on最初のページ();
      }
      else {
        // 次画面から戻って来た時
        var dataSet = this.model.on初期リロード前処理();
        this.view.on初期リロード前処理(dataSet);
        this.onリロード();
      }

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
    
   ,on検索: function(event) {
      $R.log("Controller on検索 : start");
      
      this.on最初のページ();
      
      $R.log("Controller on検索 : end");
    }
    
   ,onクリア: function(event) {
      $R.log("Controller onクリア : start");

      var dataSet = this.model.onクリア();
      this.view.onクリア(dataSet);

      $R.log("Controller onクリア : end");
    }

    ,on登録: function(event) {
      $R.log("Controller on登録 : start");
      
      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode(this.appspec.nextname, "insert");
      
      // 次画面に画面遷移する
      this.model.on次画面表示(this.appspec.nextname, "insert");

      $R.log("Controller on登録 : end");
    }
    
    ,on訂正: function(event) {
      $R.log("Controller on訂正 : start");
      
      if (!this.model.check行選択()) return;
      
      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode(this.appspec.nextname, "update");
      
      // 次画面に画面遷移する
      this.model.on次画面表示(this.appspec.nextname, "update");

      $R.log("Controller on訂正 : end");
    }
    
    ,on削除: function(event) {
      $R.log("Controller on削除 : start");
      
      if (!this.model.check行選択()) return;
      
      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode(this.appspec.nextname, "delete");
      
      // 次画面に画面遷移する
      this.model.on次画面表示(this.appspec.nextname, "delete");

      $R.log("Controller on削除 : end");
    }
    
   ,on照会: function(event) {
      $R.log("Controller on照会 : start");
      
      if (!this.model.check行選択()) return;

      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode(this.appspec.nextname, "select");

      // 次画面に画面遷移する
      this.model.on次画面表示(this.appspec.nextname, "select");

      $R.log("Controller on照会 : end");
    }
    
   ,on転用: function(event) {
      $R.log("Controller on転用 : start");

      if (!this.model.check行選択()) return;

      this.model.saveSessionStorageOfNextMode(this.appspec.nextname, "convert");
      
      // 次画面に画面遷移する
      this.model.on次画面表示(this.appspec.nextname, "convert");

      $R.log("Controller on転用 : end");
    }

    // -------------------------------
    //  ページネーション　イベント処理
    // -------------------------------
   ,on最初のページ: function(event) {
      $R.log("Controller on最初のページ : start");

      this.model.on最初のページ();
      this.ajaxExecute("select");

      $R.log("Controller on最初のページ : end");
    }
   ,on前のページ: function(event) {
      $R.log("Controller on前のページ : start");

      this.model.on前のページ();
      this.ajaxExecute("select");

      $R.log("Controller on前のページ : end");
    }
   ,on次のページ: function(event) {
      $R.log("Controller on次のページ : start");

      this.model.on次のページ();
      this.ajaxExecute("select");

      $R.log("Controller on次のページ : end");
    }
   ,on最後のページ: function(event) {
      $R.log("Controller on最後のページ : start");

      this.model.on最後のページ();
      this.ajaxExecute("select");

      $R.log("Controller on最後のページ : end");
    }
    // ---------------------------
    //  リロード処理
    // ---------------------------
   ,onリロード: function() {
      $R.log("Controller onリロード : start");

      this.model.onリロード();
      this.ajaxExecute("select");

      $R.log("Controller onリロード : end");
    }
    // ---------------------------------------
    // テーブル行　クリック処理処理
    // ---------------------------------------
   ,onテーブル行クリック: function(event, arg) {
      $R.log("Controller onテーブル行クリック : start");

      var row    = event.currentTarget.parentNode.rowIndex;
      var idName = event.currentTarget.offsetParent.id;
      var arg    = {クリック行: row, セレクタ名: idName};
      this.model.onテーブル行クリック(arg);
      this.view.onテーブル行クリック(arg);

      $R.log("Controller onテーブル行クリック : end");
    }
    
    // -------------------------------------
    //  リクエストデータ　編集・チェック処理
    // -------------------------------------
   ,on照会OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on照会OfCheckRequestData : start");

      var status = this.checkRequestData(requestData);

      $R.log("Controller on照会OfCheckRequestData : end");
      return status;
    }

    // -------------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------------
   ,on照会OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on照会OfEditResponseData : start");

      var dataSet = this.model.on照会OfEditResponseData(responseData, mode);
      this.view.on照会OfEditResponseData(dataSet, responseData, mode);
      
      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var mode = sessionStorage.loadItem("処理モード");
      if (mode != "delete") {
        var clickRow = sessionStorage.loadItem("クリック行");
        if (clickRow === undefined) {
        }
        else {
          var arg = {クリック行: parseInt(clickRow, 10)};
          this.model.onテーブル行クリック(arg);
          this.view.onテーブル行クリック(arg);
        }
      }
      else {
        sessionStorage.deleteItem("クリック行");
      }
      sessionStorage.saveItem("処理モード", "");

      $R.log("Controller on照会OfEditResponseData : end");
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

/* ************************************************************************* */
/*  マスターメンテ　一覧表　パターン                                         */
/*  コントローラ　ミックスイン                                               */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.MasterMainteListControllerMixin = {
    // --------
    // 処理開始
    // --------
    initExecute: function() {
      $R.log("Controller initExecute : start");

      this.model.getログイン情報();
      this.on初期処理();

      $R.log("Controller initExecute : end");
    }
    // ---------------------------------------
    // 初期処理
    // ---------------------------------------
   ,on初期処理: function() {
      $R.log("Controller on初期処理 : start");

      this.model.on初期処理();

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      var currentpage = sessionStorage.loadItem("カレントページ");
      if (currentpage){
        this.onリロード();
      }
      else {
        this.on最初のページ();
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
   ,on登録: function(event) {
      $R.log("Controller on登録 : start");

			// 2015.10.14 追加（shimoji）
      if (!this.model.check行選択()) return;

      var status = this.model.set処理モード("insert");
      if (status) {
        this.onメンテナンス画面表示();
      }

      $R.log("Controller on登録 : end");
    }
   ,on訂正: function(event) {
      $R.log("Controller on訂正 : start");

      if (!this.model.check行選択()) return;

      var status = this.model.set処理モード("update");
      if (status) {
        this.onメンテナンス画面表示();
      }

      $R.log("Controller on訂正 : end");
    }
   ,on照会: function(event) {
      $R.log("Controller on照会 : start");

      if (!this.model.check行選択()) return;

      var status = this.model.set処理モード("select");
      if (status) {
        this.onメンテナンス画面表示();
      }

      $R.log("Controller on照会 : end");
    }
   ,on転用: function(event) {
      $R.log("Controller on転用 : start");

      if (!this.model.check行選択()) return;

      var status = this.model.set処理モード("convert");
      if (status) {
        this.onメンテナンス画面表示();
      }

      $R.log("Controller on転用 : end");
    }
   ,on削除: function(event) {
      $R.log("Controller on削除 : start");

      if (!this.model.check行選択()) return;

      var status = this.model.set処理モード("delete");
      if (status) {
        this.onメンテナンス画面表示();
      }

      $R.log("Controller on削除 : end");
    }
    // ---------------------------------------
    // 表示順再設定 クリックイベント処理
    // ---------------------------------------
   ,on表示順再設定: function(row, arg, event) {
      $R.log("Controller on表示順再設定 : start");

      this.model.onリロード();
      this.ajaxExecute("renumber");
			
      $R.log("Controller on表示順再設定 : end");
    }
    // -------------------------------
    //  ページネーション　イベント処理
    // -------------------------------
   ,on最初のページ: function(event) {
      $R.log("Controller on最初のページ : start");

      this.model.on最初のページ();
      this.ajaxExecute("selectmaintable");

      $R.log("Controller on最初のページ : end");
    }
   ,on前のページ: function(event) {
      $R.log("Controller on前のページ : start");

      this.model.on前のページ();
      this.ajaxExecute("selectmaintable");

      $R.log("Controller on前のページ : end");
    }
   ,on次のページ: function(event) {
      $R.log("Controller on次のページ : start");

      this.model.on次のページ();
      this.ajaxExecute("selectmaintable");

      $R.log("Controller on次のページ : end");
    }
   ,on最後のページ: function(event) {
      $R.log("Controller on最後のページ : start");

      this.model.on最後のページ();
      this.ajaxExecute("selectmaintable");

      $R.log("Controller on最後のページ : end");
    }
    // ---------------------------
    //  リロード処理
    // ---------------------------
   ,onリロード: function() {
      $R.log("Controller onリロード : start");

      this.model.onリロード();
      this.ajaxExecute("selectmaintable");

      $R.log("Controller onリロード : end");
    }
    // ---------------------------------------
    // テーブル行　クリック処理処理
    // ---------------------------------------
   ,onテーブル行クリック: function(event, arg) {
      $R.log("Controller onテーブル行クリック : start");

			var row    = event.currentTarget.parentNode.rowIndex;
			var idName = event.currentTarget.offsetParent.id;
      var arg9   = {クリック行: row, セレクタ名: idName};
      this.model.onテーブル行クリック(arg9);

      $R.log("Controller onテーブル行クリック : end");
    }
    // -----------------------------------------------
    //  メンテナンス画面呼び出し処理（次画面呼び出し）
    // -----------------------------------------------
   ,onメンテナンス画面表示: function() {
      $R.log("Controller onメンテナンス画面表示 : start");

      this.model.onメンテナンス画面表示();

      var currName  = this.appspec.urlInfo[0]["app"];
      var nextArray = currName.split("/"); 
      nextArray[3]  = this.appspec.nextname;
      var nextName  = nextArray.join("/");

      this.model.setTransitionData(currName.slice(0, -1));
      this.model.postHtmlTransition(nextName.slice(0, -1));

      $R.log("Controller onメンテナンス画面表示 : end");
    }
    // ---------------------------------------------------
    //  メインテーブル照会　リクエストデータ　チェック処理
    // ---------------------------------------------------
   ,onメインテーブル照会OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller onメインテーブル照会OfCheckRequestData : start");

      var status = this.model.onメインテーブル照会OfCheckRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller onメインテーブル照会OfCheckRequestData : end");
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
    // -----------------------------------------------
    //  メインテーブル照会　レスポンスデータ　編集処理
    // -----------------------------------------------
   ,onメインテーブル照会OfEditResponseData: function(responseData, mode) {
      $R.log("Controller onメインテーブル照会OfEditResponseData : start");

      this.editResponseData(responseData);
      this.model.onメインテーブル照会OfEditResponseData(responseData);

      $R.log("Controller onメインテーブル照会OfEditResponseData : end");
    }
   ,on表示順再設定OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on表示順再設定OfEditResponseData : start");

      this.editResponseData(responseData);
      this.model.on表示順再設定OfEditResponseData(responseData);

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

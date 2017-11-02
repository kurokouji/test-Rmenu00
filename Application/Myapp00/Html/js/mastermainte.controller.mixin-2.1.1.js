/* ************************************************************************* */
/*  マスター　メンテ　パターン                                               */
/*  コントローラ　ミックスイン                                               */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.MasterMainteControllerMixin = {
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
			// 2015.10.07 shimoji 訂正
      //sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.beforename);
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var mode = sessionStorage.loadItem("処理モード");

      if (mode == "insert") {
				var arg = this.model.set表示順();
				this.view.set表示順(arg);
			}
			else {
        this.model.setテーブルＩＤ();
        this.ajaxExecute("select");
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
   ,on実行: function(event) {
      $R.log("Controller on実行 : start");

      // セッションデータに識別名を設定する
			// 20151007 shimoji 訂正
      //sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.beforename);
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var mode = sessionStorage.loadItem("処理モード");

      if (mode == "select") return;

      if (mode == "convert") {
        mode = "insert";
      }
      this.ajaxExecute(mode);

      $R.log("Controller on実行 : end");
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
    // -------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------
   ,on照会OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on照会OfEditResponseData : start");
			
      this.editResponseData(responseData);
      this.model.on照会OfEditResponseData(responseData, mode);

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var save_mode = sessionStorage.loadItem("処理モード");

			if (save_mode == "convert") {
				var arg = this.model.set表示順();
				this.view.set表示順(arg);
			}

      $R.log("Controller on照会OfEditResponseData : end");
    }
   ,on登録OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on登録OfEditResponseData : start");

      this.editResponseData(responseData);
      this.model.on登録OfEditResponseData(responseData, mode);
      this.model.onサーバ処理確認ダイアログ(responseData);

      $R.log("Controller on登録OfEditResponseData : end");
    }
   ,on訂正OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on訂正OfEditResponseData : start");

      this.editResponseData(responseData);
      this.model.on訂正OfEditResponseData(responseData, mode);
      this.model.onサーバ処理確認ダイアログ(responseData);

      $R.log("Controller on訂正OfEditResponseData : end");
    }
   ,on削除OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on削除OfEditResponseData : start");

      this.editResponseData(responseData);
      this.model.on削除OfEditResponseData(responseData, mode);
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

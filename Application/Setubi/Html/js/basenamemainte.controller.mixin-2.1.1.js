/* ************************************************************************* */
/*  基本名称メンテ　パターン                                                 */
/*  コントローラ　ミックスイン                                               */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.BaseNameMainteControllerMixin = {
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
      this.ajaxExecute("selectmaintable");

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

			var row = event.currentTarget.parentNode.parentNode.rowIndex - 1;
      var arg = this.model.on行追加クリック(row);
		  this.view.on行追加クリック(arg);
			
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
    // -----------------------------------
    //  リクエストデータ　チェック処理
    // -----------------------------------
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
   ,on実行処理OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on実行処理OfCheckRequestData : start");

      var status = this.model.on実行処理OfCheckRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller on実行処理OfCheckRequestData : end");
      return status;
    }
    // -------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------
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
   ,on実行処理OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on実行処理OfEditResponseData : start");

      this.editResponseData(responseData);
      this.model.on実行処理OfEditResponseData(responseData);

      this.model.onサーバ処理確認ダイアログ(responseData);

      $R.log("Controller on実行処理OfEditResponseData : end");
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

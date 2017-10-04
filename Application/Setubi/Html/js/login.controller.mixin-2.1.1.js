/* ************************************************************************* */
/*  ログイン　パターン                                         */
/*  コントローラ　ミックスイン                                               */
/*  2014/10/01 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.LoginControllerMixin = {
    // --------
    // 処理開始
    // --------
    initExecute: function() {
      $R.log("Controller initExecute : start");

      $R.log("Controller initExecute : end");
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
   ,onクリア: function(event) {
      $R.log("Controller onクリア : start");

      this.clearFormData();                                           // フォームデータの値をクリアする

      $R.log("Controller onクリア : end");
    }
   ,onログイン: function(event) {
      $R.log("Controller onログイン : start");

      this.ajaxExecute("check");

      $R.log("Controller onログイン : end");
    }
    // -----------------------------------
    //  リクエストデータ　チェック処理
    // -----------------------------------
   ,onチェックOfCheckRequestData: function(requestData, mode) {
      $R.log("Controller onチェックOfCheckRequestData : start");

      var status = this.checkRequestData(requestData);

      $R.log("Controller onチェックOfCheckRequestData : end");
      return status;
    }
    // -------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------
   ,onチェックOfEditResponseData: function(responseData, mode) {
      $R.log("Controller onチェックOfEditResponseData : start");

      this.editResponseData(responseData);
      this.model.onチェックOfEditResponseData(responseData);          // セッションストレージにユーザ情報を格納する

      // 次画面を表示する
      var currName  = this.appspec.urlInfo[0]["app"];
      var nextArray = currName.split("/"); 
      nextArray[3]  = this.appspec.nextname;
      var nextName  = nextArray.join("/");

      this.model.clearTransitionData();
      this.model.setTransitionData(currName.slice(0, -1));
      this.model.postHtmlTransition(nextName.slice(0, -1));

      $R.log("Controller onチェックOfEditResponseData : end");
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

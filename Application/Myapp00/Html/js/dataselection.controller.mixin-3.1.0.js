/* ************************************************************************* */
/*  マスター　選択画面　パターン                                             */
/*  コントローラ　ミックスイン                                               */
/*  2017/09/06 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.DataSelectionControllerMixin = {
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
      
      // 選択画面リクエストデータとレスポンスデータを設定する
      this.model.setリクエストデータOf選択画面();
      
      // 初期処理：前画面の引き継ぎデータをデータセットに設定する
      var status = this.model.setFromBeforeStorageDataToDataset();
      if (status == "OK") {
        var dataSet = this.model.dataset.getData();
        this.view.fromJsonDataToView(dataSet);
      }
      
      this.on最初のページ();

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

      // 前画面のレスポンスデータを設定
      this.model.set戻るレスポンスデータOf選択画面();
      
      // セッションストレージ情報をクリアし、前画面に戻る
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

   ,on選択: function(event) {
      $R.log("Controller on選択 : start");

      // 前画面のレスポンスデータを設定
      this.model.set選択レスポンスデータOf選択画面();
      
      // セッションストレージ情報をクリアし、前画面に戻る
      this.model.clearセッション情報();
      this.model.previousTransition();
      
      $R.log("Controller on選択 : end");
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
   ,onメインテーブル照会OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller onメインテーブル照会OfCheckRequestData : start");

      var status = this.checkRequestData(requestData);

      $R.log("Controller onメインテーブル照会OfCheckRequestData : end");
      return status;
    }

    // -------------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------------
   ,onメインテーブル照会OfEditResponseData: function(responseData, mode) {
      $R.log("Controller onメインテーブル照会OfEditResponseData : start");

      var dataSet = this.model.onメインテーブル照会OfEditResponseData(responseData, mode);
      this.view.onメインテーブル照会OfEditResponseData(dataSet, responseData, mode);
      
      $R.log("Controller onメインテーブル照会OfEditResponseData : end");
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

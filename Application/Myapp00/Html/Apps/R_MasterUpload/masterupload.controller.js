(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MasterUpload;

  // インスタンスプロパティを追加する
  var Controller = App.Controller = new $R.Class($R.Controller);
  Controller.fn.init = function(appspec, model, view) {
    $R.log("Controllerr init : start");

    this.appspec = appspec;
    this.model   = model;
    this.view    = view;
    this.createPubSubEvent();

    $R.log("Controllerr init : end");
  };

  // 共通モジュールを追加する
  Controller.include($R.Library.EnterTabPFKeyMixin);
  Controller.include($R.Library.ControllerMixin);

  // 関数を追加する
  Controller.include({
    // --------
    // 処理開始
    // --------
    initExecute: function() {
      $R.log("Controller initExecute : start");

      this.model.getログイン情報();

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
   ,on戻る: function(event) {
      $R.log("Controller on戻る : start");

      this.model.clearページ情報();
      this.model.previousTransition();

      $R.log("Controller on戻る : end");
    }
   ,on得意先登録: function(event) {
      $R.log("Controller on得意先登録 : start");

      this.model.on得意先登録(this);

      $R.log("Controller on得意先登録 : end");
    }
    // -----------------------------------
    //  CVSアップロード　コールバック処理
    // -----------------------------------
   ,onCVSアップロードコールバック: function(responseData, mode) {
      $R.log("Controller onCVSアップロードコールバック : start");

      var status = responseData["message"]["status"];
      if (status != "OK") {
        this.onErrorResponseData(responseData, mode);
        return;
      }

      this.ajaxExecute(mode);

      $R.log("Controller onCVSアップロードコールバック : end");
    }
    // -----------------------------------
    //  リクエストデータ　チェック処理
    // -----------------------------------
   ,onSetRequestData: function(requestData, mode) {
      $R.log("Controller onSetRequestData : start");

      var status = this.model.onSetRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller onSetRequestData : end");
      return status;
    }
    // -------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------
   ,onEditResponseData: function(responseData, mode) {
      $R.log("Controller onEditResponseData : start");

      this.editResponseData(responseData);
      this.model.onEditResponseData(responseData, mode);

      $R.log("Controller onEditResponseData : end");
    }
    // ---------------------------
    //  レスポンス　エラー処理
    // ---------------------------
   ,onErrorResponseData: function(responseData, mode) {
      $R.log("Controller onErrorResponseData : start");

      this.errorResponseData(responseData);

      $R.log("Controller onErrorResponseData : end");
    }
  });
}(jQuery, Rmenu));
/* ************************************************************************* */
/*  タブ　メニュー　パターン                                                 */
/*  コントローラ　ミックスイン                                               */
/*  2017/09/17 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.TabMenuControllerMixin = {
    // --------
    // 処理開始
    // --------
    initExecute: function() {
      $R.log("Controller initExecute : start");

      var arg = this.model.getログイン情報();
      this.view.setログイン情報(arg);

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      var tabname = sessionStorage.loadItem("ターゲットタブ");
      if (tabname === undefined){
        this.ajaxExecute("init");
      }
      else {
        this.view.openメニュータブ(tabname);
      }

      $R.log("Controller initExecute : end");
    }
    
    // ------------------------
    // イベント処理
    // ------------------------
   ,onメニュータブ: function(event) {
      $R.log("Controller onメニュータブ : start");

      var tabName = $(event.target).attr("id");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      sessionStorage.saveItem("ターゲットタブ", tabName);

      $R.log("Controller onメニュータブ : end");
    }
    
   ,onメニュー項目: function(event) {
      $R.log("Controller onメニュー項目 : start");

      var htmlName  = $(event.target).attr("name");
      if (htmlName != "") {
        var arg = {次画面名: htmlName};
        this.model.onメニュー項目(arg);
        this.ajaxExecute("userinfo");
      }

      $R.log("Controller onメニュー項目 : end");
    }
    
   ,on戻る: function(event) {
      $R.log("Controller on戻る : start");

      this.ajaxExecute("term");

      $R.log("Controller on戻る : end");
    }

    // -----------------------------------
    //  リクエストデータ　チェック処理
    // -----------------------------------
   ,on初期処理OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on初期処理OfCheckRequestData : start");
      
      var status = this.model.on初期処理OfCheckRequestData(requestData, mode);

      $R.log("Controller on初期処理OfCheckRequestData : end");
      return status;
    }
    
   ,onユーザ情報OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller onユーザ情報OfCheckRequestData : start");
      
      var status = this.model.onユーザ情報OfCheckRequestData(requestData, mode);

      $R.log("Controller onユーザ情報OfCheckRequestData : end");
      return status;
    }
    
   ,on終了処理OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on終了処理OfCheckRequestData : start");
      
      var status = this.model.on終了処理OfCheckRequestData(requestData, mode);

      $R.log("Controller on終了処理OfCheckRequestData : end");
      return status;
    }
    
    // -------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------
   ,on初期処理OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on初期処理OfEditResponseData : start");

      $R.log("Controller on初期処理OfEditResponseData : end");
    }
    
   ,onユーザ情報OfEditResponseData: function(responseData, mode) {
      $R.log("Controller onユーザ情報OfEditResponseData : start");

      var htmlName  = this.model.onユーザ情報OfEditResponseData(responseData, mode);
      var currName  = this.appspec.urlInfo[0]["app"];
      this.model.setTransitionData(currName.slice(0, -1));
      this.model.postHtmlTransition(htmlName);

      $R.log("Controller onユーザ情報OfEditResponseData : end");
    }
    
   ,on終了処理OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on終了処理OfEditResponseData : start");

      this.model.on終了処理OfEditResponseData();
      this.model.previousTransition();

      $R.log("Controller on終了処理OfEditResponseData : end");
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
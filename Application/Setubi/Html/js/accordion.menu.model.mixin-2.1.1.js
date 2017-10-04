/* ************************************************************************* */
/*  アコーディオン　メニュー　パターン                                       */
/*  モデル　ミックスイン                                                     */
/*  2014/10/05 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.AccordionMenuModelMixin = {
    // --------
    // 処理開始
    // --------
    initExecute: function() {
      $R.log("Model initExecute : start");

      this.dataset.clearDataValue();                   // Datasetの値をクリアする
      this.dataset.clearFormElementNo();               // フォームオブジェクトの要素番号をクリアする
      this.dataset.setFormElementNo();                 // フォームオブジェクトの要素番号を設定する

      $R.log("Model initExecute : end");
    }
    // -------------------------------------------------------------------
    //  セッションストレージからログイン情報を取得し表示イベントを発行する
    // -------------------------------------------------------------------
   ,getログイン情報: function() {
      $R.log("Model getログイン情報 : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + ".Login");

      var username = sessionStorage.loadItem("ユーザ名称");
      var datetime = sessionStorage.loadItem("ログイン時刻");
      var jdate    = sessionStorage.loadItem("ログイン和暦");
      var arg      = {ユーザ名称: username, ログイン時刻: datetime, ログイン和暦: jdate};
      this.pubsub.publish("showログイン情報", arg);

      $R.log("Model getログイン情報 : end");
    }
    // -------------------------------------------------
    //  セッションスト（ログイン情報）をレージクリアする
    // -----------------------------------------------  
   ,clearセッション情報: function() {
      $R.log("Model clearセッション情報 : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      sessionStorage.deleteAll("");

      // セッションデータにログイン識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + ".Login");
      sessionStorage.deleteAll("");

      $R.log("Model clearセッション情報 : end");
    }

  };
}(jQuery, Rmenu));
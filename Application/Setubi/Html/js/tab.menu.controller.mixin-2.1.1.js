/* ************************************************************************* */
/*  タブ　メニュー　パターン                                                 */
/*  コントローラ　ミックスイン                                               */
/*  2014/10/05 tadashi shimoji                                               */
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

      this.model.getログイン情報();

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      var tabname = sessionStorage.loadItem("ターゲットタブ");
      if (tabname){
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

      var currName  = this.appspec.urlInfo[0]["app"];
      this.model.setTransitionData(currName.slice(0, -1));

      var htmlName = $(event.target).attr("name");
      this.model.postHtmlTransition(htmlName);

      $R.log("Controller onメニュー項目 : end");
    }
   ,on戻る: function(event) {
      $R.log("Controller on戻る : start");

      this.model.clearセッション情報();
      this.model.previousTransition();

      $R.log("Controller on戻る : end");
    }

  };
}(jQuery, Rmenu));
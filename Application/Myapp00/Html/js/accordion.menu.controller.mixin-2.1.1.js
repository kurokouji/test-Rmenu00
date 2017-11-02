/* ************************************************************************* */
/*  アコーディオン　メニュー　パターン                                       */
/*  コントローラ　ミックスイン                                               */
/*  2014/10/05 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.AccordionMenuControllerMixin = {
    // --------
    // 処理開始
    // --------
    initExecute: function() {
      $R.log("Controller initExecute : start");

      this.model.getログイン情報();

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var targetID = sessionStorage.loadItem("ターゲットＩＤ");
      if (targetID){
        this.view.openメニューアイテム(targetID);
      }

      $R.log("Controller initExecute : end");
    }
    // ------------------------
    // イベント処理
    // ------------------------
   ,onメニュー項目: function(event) {
      $R.log("Controller onメニュー項目 : start");

      var parentID = $(event.target.parentNode.parentNode.parentElement).attr("id");
      var htmlName = $(event.target).attr("id");
      var procName = $(event.target).html();

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      sessionStorage.saveItem("ターゲットＩＤ", parentID);
      sessionStorage.saveItem("プログラム名称", procName);

      // 画面遷移
      var currName  = this.appspec.urlInfo[0]["app"];
      this.model.setTransitionData(currName.slice(0, -1));
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
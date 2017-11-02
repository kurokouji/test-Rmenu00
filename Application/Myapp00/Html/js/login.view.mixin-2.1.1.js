/* ************************************************************************* */
/*  ログイン　パターン                                                       */
/*  ビュー　ミックスイン                                                     */
/*  2014/10/01 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.LoginViewMixin = {
    // --------
    // 処理開始
    // --------
    initExecute: function() {
      $R.log("View initExecute : start");

      //$(".firstfocus").focus();                                       // 画面の最初の項目にフォーカスを当てる

      this.initテンプレートロード();
      this.initAlertDialog();                                         // 警告メッセージ用ダイアログ 初期処理
      this.initConfirmDialog(this);                                   // 確認メッセージ用ダイアログ 初期処理
      this.initExecuteDialog(this);                                   // 実行確認メッセージ用ダイアログ 初期処理
      this.initServerDialog(this);                                    // サーバ確認メッセージ用ダイアログ 初期処理

      $R.log("View initExecute : end");
    }
		
    // -------------------------
    //  テンプレートをロードする
    // -------------------------
   ,initテンプレートロード: function() {
      $R.log("View initテンプレートロード : start");

      $('body').fadeIn("normal");

      $R.log("View initテンプレートロード : end");
    }
		
    // -------------------------------------------
    //  ユーザ情報をデータセットに設定する
    // -------------------------------------------
   ,setユーザ情報: function(userObj) {
      $R.log("View setユーザ情報 : start");
			
			
			$("#ログインＩＤ").val("");
			$("#パスワード").val("");

			if (userObj["ログインＩＤ"]) {
			  $("#ログインＩＤ").val(userObj["ログインＩＤ"]);
			}
			if (userObj["パスワード"]) {
			  $("#パスワード").val(userObj["パスワード"]);
			}
			
      $R.log("View setユーザ情報 : end");
    }


  };
}(jQuery, Rmenu));

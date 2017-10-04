/* ************************************************************************* */
/*  マスター　メンテ　パターン                                               */
/*  ビュー　ミックスイン                                                     */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.MasterMainteViewMixin = {
    // --------
    // 処理開始
    // --------
    initExecute: function(dataset) {
      $R.log("View initExecute : start");

      this.initテンプレートロード();
      this.initAlertDialog();                     // 警告メッセージ用ダイアログ 初期処理
      this.initConfirmDialog(this);               // 確認メッセージ用ダイアログ 初期処理
      this.initExecuteDialog(this);               // 実行確認メッセージ用ダイアログ 初期処理
      this.initServerDialog(this);                // サーバ確認メッセージ用ダイアログ 初期処理

      // テーブルの空行を作成する
      var detailInfo  = this.appspec.getJSONChunkByIdAtRecords(dataset, "detail");
      if (detailInfo) {
        if (detailInfo["multiline"] == "yes") {
          var defaultline = detailInfo["defaultline"];
          this.createTableRows("#mainTable", defaultline);
        }
      }

      $R.log("View initExecute : end");
    }
    // -------------------------
    //  テンプレートをロードする
    // -------------------------
   ,initテンプレートロード: function() {
      $R.log("View initテンプレートロード : start");

      // ＣＳＳファイル名をセッションストレージから取得しロードする
      sessionStorage.setIdName(this.appspec.sysname + ".Login");
      var cssName = sessionStorage.loadItem("ＣＳＳファイル名");

      if (cssName) {
        var arg = {cssName: cssName};
        this.appendCSS(arg);
      }

      $('body').fadeIn("normal");

      $R.log("View initテンプレートロード : end");
    }
    // -----------------------
    //  ログイン情報を表示する
    // -----------------------
   ,showログイン情報: function(arg) {
      $R.log("View showログイン情報 : start");

      if ( arg["ログイン和暦"] != "") {
        $("#ログイン和暦").html(arg["ログイン和暦"]); 
      }

      $("#ログイン日時").html(arg["ログイン時刻"]); 
      $("#ユーザ氏名").html(arg["ユーザ名称"]); 

      $R.log("View showログイン情報 : end");
    }
    // -----------------------
    //  初期処理
    // -----------------------
   ,show初期処理: function(arg) {
      $R.log("View show初期処理 : start");

      $R.log("View show初期処理 : end");
    }
    // -------------------------
    //  ヘッダタイトルを表示する
    // -------------------------
   ,showヘッダータイトル: function(arg) {
      $R.log("View showヘッダータイトル : start");

      var title = $("#ヘッダータイトル").html();
      var mode  = arg["処理モード"];

      switch (mode) {
        case "select":
          title   += "（照会）";
          $("#実行").attr("disabled","disabled");
          break;
        case "insert":
          title   += "（新規）";
          break;
        case "convert":
          title   += "（転用）";
          break;
        case "update":
          title   += "（訂正）";
          break;
        case "delete":
          title   += "（削除）";
      }
      $("#ヘッダータイトル").html(title); 

      $R.log("View showヘッダータイトル : end");
    }
		
    // -----------------------------------
    //  表示順の設定
    // -----------------------------------
   ,set表示順: function(arg) {
      $R.log("View set表示順 : start");

      var targetName = arg["項目名"];
      var value      = arg["表示順"];
			
			if (targetName != "") {
				$("#" + targetName).val(value);
			}

      $R.log("View set表示順 : end");
    }

  };
}(jQuery, Rmenu));

/* ************************************************************************* */
/*  基本名称メンテ　パターン                                                 */
/*  ビュー　ミックスイン                                                     */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.BaseNameMainteViewMixin = {
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
    // -------------------------------------------------------------------
    //  テンプレートをロードする
    // -------------------------------------------------------------------
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
    // -------------------------------------------------------------------
    //  ログイン情報を表示する
    // -------------------------------------------------------------------
   ,showログイン情報: function(arg) {
      $R.log("View showログイン情報 : start");

      $("#ログイン和暦").html(arg["ログイン和暦"]); 
      $("#ログイン日時").html(arg["ログイン時刻"]); 
      $("#ユーザ氏名").html(arg["ユーザ名称"]); 

      $R.log("View showログイン情報 : end");
    }
    // -------------------------------------------------------------------
    //  初期処理
    // -------------------------------------------------------------------
   ,show初期処理: function() {
      $R.log("View show初期処理 : start");

      $R.log("View show初期処理 : end");
    }
    // ---------------------------------------
    // 行追加 クリックイベント処理
    // ---------------------------------------
    ,on行追加クリック: function(arg) {
      $R.log("View on行追加クリック : start");

      var tableID     = arg["テーブルＩＤ"];
      var tableData   = arg["テーブルデータ"];
      var defaultline = tableData["defaultline"];

      // 表示するデータの行数を取得する
      var max = 0;
      for (var name in tableData["record"]) {
        max = tableData["record"][name]["value"].length;
        break;
      }

			// 表示中のデータをクリアする
      var table = document.getElementById(tableID);  
      for (var i = 0; i < defaultline; i++ ) {  
        for (var name in tableData["record"]) {
					if ( (name == "更新日時") || (name == "行追加") || (name == "削除") ) {
						continue;
					}
					
					// クリア
					var targetObj = $("." + name);
					if ( targetObj[i].type == "checkbox" ) {
						$(targetObj[i]).prop("checked", false )
					}
					else {
					  $(targetObj[i]).val("");
					}
        }
      } 
			
      // データを表示する
      for (var i = 0; i < max; i++ ) {  
        for (var name in tableData["record"]) {
					if ( (name == "更新日時") || (name == "行追加") ) {
						continue;
					}

					// データ表示
					var targetObj = $("." + name);
					if (name == "削除") {
						if (tableData["record"][name]["value"][i] == "1") {
							$(targetObj[i]).prop("checked", true )
						}
						else {
							$(targetObj[i]).prop("checked", false )
						}
						continue;
					}
					
					if ( targetObj[i].type == "checkbox" ) {
						if (tableData["record"][name]["value"][i] == "1") {
							$(targetObj[i]).prop("checked", true )
						}
						else {
							$(targetObj[i]).prop("checked", false )
						}
					}
					else {
					  $(targetObj[i]).val(tableData["record"][name]["value"][i]);
					}
        }
      }
			
      $R.log("View on行追加クリック : end");
    }
    // -------------------------------------------------------
    // テーブルにデータを表示する
    // -------------------------------------------------------
   ,onテーブル表示: function(arg) {
      $R.log("View onテーブル表示 : start");

      $R.log("View onテーブル表示 : end");
    }

  };
}(jQuery, Rmenu));

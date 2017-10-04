/* ************************************************************************* */
/*  マスターメンテ　一覧表　パターン                                         */
/*  ビュー　ミックスイン                                                     */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.MasterMainteListViewMixin = {
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
      var defaultline = detailInfo["defaultline"];
      this.createTableRows("#mainTable", defaultline);

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
    // ---------------------
    //  ページ情報を表示する
    // ---------------------
   ,showページ情報: function(arg) {
      $R.log("View showページ情報 : start");

      var pageline   = arg["ページライン数"];
      var curpage    = arg["カレントページ"];
      var maxpage    = arg["最大ページ"];
      var totalcount = arg["トータル件数"];
      var pagedata   = curpage + "/" + maxpage + "ページ(" + totalcount + "件)";
      $("#mainForm input[name='ページ情報']").val(pagedata);
      $("#mainForm input[name='ページ情報']").attr("disabled","disabled");

      $("#最初のページ").removeAttr("disabled");
      $("#前のページ").removeAttr("disabled");
      $("#次のページ").removeAttr("disabled");
      $("#最後のページ").removeAttr("disabled");
      if (curpage == 1) {
        $("#最初のページ").attr("disabled","disabled");
        $("#前のページ").attr("disabled","disabled");
      }
      if (curpage == maxpage) {
        $("#最後のページ").attr("disabled","disabled");
        $("#次のページ").attr("disabled","disabled");
      }

      $R.log("View showページ情報 : end");
    }
    // -------------------------
    //  テーブル行　クリック処理
    // -------------------------
    ,onテーブル行クリック: function(arg) {
      $R.log("View onTableRowClick : start");

      var clickRow  = arg["クリック行"] - 1;

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);

      // 選択行にCSSクラスを設定する
      var j, k;
      var beforeRow = sessionStorage.loadItem("クリック行");
      var rows = $("#mainTable")[0].rows;
      jQuery.each(rows, function(j) {
        k = j - 1;
        var cells = rows[j].cells;
        jQuery.each(cells, function() {
          if (k == beforeRow) {
            $(this).removeClass("rowBackground");
           }
          if (k == clickRow) {
            $(this).addClass("rowBackground");
          }
        });
      });

      sessionStorage.saveItem("クリック行", clickRow);

      $R.log("View onTableRowClick : end");
     }
    // -------------------------------------------------------
    // テーブルにデータを表示する
    // -------------------------------------------------------
   ,onテーブル表示: function(arg) {
      $R.log("View onテーブル表示 : start");

      var rows = $("#mainTable")[0].rows;
      jQuery.each(rows, function(j) {
        k = j -1;
        var cells = rows[j].cells;
        jQuery.each(cells, function() {
          $(this).removeClass("rowBackground");
        });
      });

      // テーブルにデータを表示する
      this.showTableData(arg);

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var mode     = sessionStorage.loadItem("処理モード");
      var clickRow = sessionStorage.loadItem("クリック行");
      var arg = {クリック行: parseInt(clickRow, 10) + 1};
      switch (mode) {
        case "select":
          this.pubsub.publish("onテーブル行クリック", arg);
          break;
        case "insert":
          //sessionStorage.saveItem("処理モード", "");
          sessionStorage.saveItem("クリック行", "");
          break;
        case "convert":
          //sessionStorage.saveItem("処理モード", "");
          sessionStorage.saveItem("クリック行", "");
          break;
        case "update":
          this.pubsub.publish("onテーブル行クリック", arg);
          break;
        case "delete":
          //sessionStorage.saveItem("処理モード", "");
          sessionStorage.saveItem("クリック行", "");
          break;
        default:
          //sessionStorage.saveItem("処理モード", "");
          sessionStorage.saveItem("クリック行", "");
          break;
      }

      $R.log("View onテーブル表示 : end");
    }

  };
}(jQuery, Rmenu));

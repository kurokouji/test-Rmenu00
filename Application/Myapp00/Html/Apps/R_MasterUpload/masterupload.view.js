(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MasterUpload;

  // インスタンスプロパティを追加する
  var View = App.View = new $R.Class($R.View);
  View.fn.init = function(appspec) {
    $R.log("View init : start");

    this.appspec = appspec;

    $R.log("View init : end");
  }

  // 共通モジュールを追加する
  View.include($R.Library.FormatMixin);
  View.include($R.Library.OutlineMixin);
  View.include($R.Library.ViewMixin);

  View.include({
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

      $R.log("View initExecute : end");
    }
    // CSSファイルを追加する
   ,appendCSS: function(arg) {
      $R.log("LoadTemplateMixin appendCSS : start");

      if (arg["cssName"]) {
        //var url = $R.ApplicationURL + "/" + arg["cssName"];
        var url = $R.ApplicationURL + arg["cssName"];

        $("head").append("<link>");
        css = $("head").children(":last");
        css.attr({
            rel: "stylesheet",
            type: "text/css",
            href: url
        });

      }

      $R.log("LoadTemplateMixin appendCSS : end");
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
    // ---------------------
    //  ページ情報を表示する
    // ---------------------
   ,showページ情報: function(arg) {
      $R.log("View showページ情報 : start");

      $R.log("View showページ情報 : end");
    }

  });
}(jQuery, Rmenu));
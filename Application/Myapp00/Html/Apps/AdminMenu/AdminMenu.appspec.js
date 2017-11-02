(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.AdminMenu = {};

  // インスタンスプロパティを追加する
  var AppSpec = App.AppSpec = new $R.Class($R.AppSpec);
  AppSpec.fn.init = function(name) {
    $R.log("AppSpec init : start");

    this.name = name;

    $R.log("AppSpec init : end");
  }

  // 共通モジュールを追加する
  AppSpec.include($R.Library.AppSpecMixin);

  AppSpec.include({
    // -----------------------------------------------------------------------------------------------
    // プログラム・JSONファイルのURL情報を定義する（サブシステム名・種類・Apps・プログラムフォルダ名）
    // -----------------------------------------------------------------------------------------------
    urlInfo: [
      {app:  "Myapp00/Html/Apps/AdminMenu/"}
     ,{json: "Myapp00/Json/Apps/AdminMenu/"}
    ]
    // --------------------------
    // JSONファイル情報を定義する
    // --------------------------
   ,jsonInfo: [
      {dataset:     "yes"}
     ,{validation:  "yes"}
    ]
    // ----------------------------------------------------------------------------------------
    // トランザクション・リクエストチェック・レスポンス編集・エラーのコールバック関数を定義する
    // ----------------------------------------------------------------------------------------
   ,requestInfo: [
      ["init",      "on初期処理OfCheckRequestData",   "on初期処理OfEditResponseData",   "onErrorResponseData"]
     ,["userinfo",  "onユーザ情報OfCheckRequestData", "onユーザ情報OfEditResponseData", "onErrorResponseData"]
     ,["term",      "on終了処理OfCheckRequestData",   "on終了処理OfEditResponseData",   "onErrorResponseData"]
    ]
    // --------------------------------------------------
    // エンター・タブとPFキーのコールバック関数を定義する
    // --------------------------------------------------
   ,enterTabPFKey: {
      Enter:true
     ,Tab:true
     ,F1:null
     ,F2:null
     ,F3:null
     ,F4:null
     ,F5:null
     ,F6:null
     ,F7:null
     ,F8:null
     ,F9:null
     ,F10:null
     ,F11:null
     ,F12:null
     ,ESC:"on戻る"
     ,Forms:0
    }
    // ----------------------------------------------------------------
    // イベント設定はセレクタ・イベント・コールバック関数の順に指定する
    // ----------------------------------------------------------------
    // NAVボタンイベントを定義する
   ,navButtonEvent: [
      ["#戻る",         "click", "on戻る"]
     ,[".メニュータブ", "click", "onメニュータブ"]
     ,[".メニュー",     "click", "onメニュー項目"]
    ]
    // バリデーションイベントを定義する
   ,validationEvent: [
    ]
    // その他セレクターイベントを定義する
   ,selectorEvent: [
    ]
    // ------------------------------------------------------------------------
    // テーブルイベント設定はセレクタ・イベント・コールバック関数の順に指定する
    // ------------------------------------------------------------------------
    // テーブルRow　イベントを定義する
   ,tableRowEvent: [
    ]
    // テーブルオブジェクト　イベントを定義する
   ,tableObjectEvent: [
    ]
    // ----------------------------------------------------------------------------------
    // カスタムイベント設定はイベント名・実行コンテキスト・コールバック関数の順に指定する
    // ----------------------------------------------------------------------------------
    // チェック用カスタムイベントを定義する
   ,pubsubCheckEvent: [
    ]
    // 導出項目編集用カスタムイベントを定義する
   ,pubsubDeriveEvent: [
    ]
    // その他カスタムイベントを定義する
   ,pubsubOtherEvent: [
    ]
  });
}(jQuery, Rmenu));
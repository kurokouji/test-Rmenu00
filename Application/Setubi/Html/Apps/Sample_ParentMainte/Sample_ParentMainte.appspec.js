(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.Sample_ParentMainte = {};

  // インスタンスプロパティを追加する
  var AppSpec = App.AppSpec = new $R.Class($R.AppSpec);
  AppSpec.fn.init = function(name) {
    $R.log("AppSpec init : start");

    this.name       = name;
    this.nextname   = "Sample_ChildMainte";
    this.beforename = "Sample_ParentList";

    $R.log("AppSpec init : end");
  }

  // 共通モジュールを追加する
  AppSpec.include($R.Library.AppSpecMixin);

  AppSpec.include({
    // -----------------------------------------------------------------------------------------------
    // プログラム・JSONファイルのURL情報を定義する（サブシステム名・種類・Apps・プログラムフォルダ名）
    // -----------------------------------------------------------------------------------------------
    urlInfo: [
      {app:  "Setubi/Html/Apps/Sample_ParentMainte/"}
     ,{json: "Setubi/Json/Apps/Sample_ParentMainte/"}
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
      ["select",      "on照会OfCheckRequestData",            "on照会OfEditResponseData",           "onErrorResponseData"]
     ,["insert",      "on登録OfCheckRequestData",            "on登録OfEditResponseData",           "onErrorResponseData"]
     ,["update",      "on訂正OfCheckRequestData",            "on訂正OfEditResponseData",           "onErrorResponseData"]
     ,["delete",      "on削除OfCheckRequestData",            "on削除OfEditResponseData",           "onErrorResponseData"]
    // ここから追加処理
    ]
    // --------------------------------------------------
    // エンター・タブとPFキーのコールバック関数を定義する
    // --------------------------------------------------
   ,enterTabPFKey: {
      Enter:true
     ,Tab:true
     ,F1:"on実行"
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
    // NAVボタンのイベントを定義する
   ,navButtonEvent: [
      ["#戻る",           "click", "on戻る"]
     ,["#実行",           "click", "on実行"]
    // ここから追加処理
     ,["#サンプル子メンテ", "click", "onサンプル子メンテ"]
     ,["#サンプル検索",     "click", "onサンプル検索"]
    ]
    // ----------------------------------------------------------------
    // 権限情報の設定（使用不可のロールを設定する）
    // ----------------------------------------------------------------
   ,roleInfo: [
      ["#戻る",             [""]]
     ,["#実行",             [""]]
    // ここから追加処理
    ]
    // バリデーションのイベントを定義する
   ,validationEvent: [
      ["#mainForm", "focus", "onFocus"]
     ,["#mainForm", "blur",  "onBlur"]
    ]
    // その他セレクターイベントを定義する
   ,selectorEvent: [
      [".削除",              "change", "onChange削除"]
    // ここから追加処理
    ]
    // ----------------------------------------------------------------------------------
    // カスタムイベント設定はイベント名・実行コンテキスト・コールバック関数の順に指定する
    // ----------------------------------------------------------------------------------
    // チェック用カスタムイベントを定義する
   ,pubsubCheckEvent: [
    // ここから追加処理
    ]
    // 導出項目編集用カスタムイベントを定義する
   ,pubsubDeriveEvent: [
    // ここから追加処理
    ]
    // その他カスタムイベントを定義する
   ,pubsubOtherEvent: [
      ["showヘッダータイトル",  "view",       "showヘッダータイトル"]
    // ここから追加処理
     ,["onサンプル検索後処理",  "controller", "onサンプル検索後処理"]
    ]
    // ----------------------------------------------------------------------------------
    // 画面ヘッダ　キー定義
    // （自画面のセッションストレージに設定される）
    // datasetid  : datasetのidを指定する
    // dataname   : datasetの項目名を指定する
    // classname  : HTMLのクラス名を指定する
    // typename   : datasetもしくはHTMLのTYPEを指定する
    // ----------------------------------------------------------------------------------
   ,sessionStorageHeaderKey: [
      {
         datasetid: "header"
        ,dataname:  ["サンプル_ヘッダＩＤ"]
        ,classname: ["サンプル_ヘッダＩＤ"]
        ,typename:  ["text"]
      }
    ]
    // ----------------------------------------------------------------------------------
    // 画面明細　キー定義
    // テーブル明細行をクリックしたときに設定するキー項目名を指定する
    // （自画面のセッションストレージに設定される）
    // datasetid  : datasetのidを指定する
    // dataname   : datasetの項目名を指定する
    // typename   : datasetもしくはHTMLのTYPEを指定する
    // ----------------------------------------------------------------------------------
   ,sessionStorageDetailKey: [
      {
         datasetid: "detail"
        ,dataname:  ["サンプル_明細行番号"]
        ,typename:  ["dataset"]
      }
    ]
    // ----------------------------------------------------------------------------------
    // 画面フッター　キー定義
    // （自画面のセッションストレージに設定される）
    // datasetid  : datasetのidを指定する
    // dataname   : datasetの項目名を指定する
    // typename   : datasetもしくはHTMLのTYPEを指定する
    // ----------------------------------------------------------------------------------
   ,sessionStorageFooterKey: [
    ]
    // ----------------------------------------------------------------------------------
    // 次画面への引き継ぎデータ定義
    // （次画面のセッションストレージに設定される）
    // datasetid  : datasetのidを指定する
    // dataname   : datasetの項目名を指定する
    // validation : required(必須)もしくはnonrequired(省略可能)を指定する
    // titlename  : エラーメッセージのタイトルを指定する
    // ----------------------------------------------------------------------------------
   ,nextStorageData: [
      {
         datasetid:   "header"
        ,dataname:    ["サンプル_ヘッダＩＤ"]
        ,validation:  ["nonrequired"]
        ,titlename:   ["サンプル_ヘッダＩＤ"]
      }
    ]
    // ----------------------------------------------------------------------------------
    // 前画面からの引き継ぎデータ定義
    // datasetid  : datasetのidを指定する
    // dataname   : datasetの項目名を指定する
    // classname  : HTMLのクラス名を指定する
    // typename   : datasetもしくはHTMLのTYPEを指定する
    // ----------------------------------------------------------------------------------
   ,beforeStorageData: [
      {
         datasetid: "header"
        ,dataname:  ["サンプル_ヘッダＩＤ"]
        ,classname: ["サンプル_ヘッダＩＤ"]
        ,typename:  ["dataset"]
      }
    ]
    // ----------------------------------------------------------------------------------
    // 選択画面への引き渡しデータ定義
    // requestname : 選択画面名を指定する
    // datasetid   : datasetのidを指定する
    // dataname    : datasetの項目名を指定する
    // value       : 空白（項目名の値がセットされ選択画面へ渡される）
    // ----------------------------------------------------------------------------------
   ,selectStorageRequestData: [
      {
         requestname: "Sample_Selection"
        ,datasetid:   ""
        ,dataname:   []
        ,value:      []
      }
    ]
    // ----------------------------------------------------------------------------------
    // 選択画面からの引き渡しデータ定義
    // responsename  : 自画面名を指定する
    // datasetid     : datasetのidを指定する
    // dataname      : datasetの項目名を指定する
    // value         : 空白（選択画面からの引き渡しデータの値がセットされる）
    // afterfunction : 後処理関数を指定する（同時に、pubsubOtherEventにも設定する）
    // ----------------------------------------------------------------------------------
   ,selectStorageResponseData: [
      {
         responsename: "Sample_ParentMainte"
        ,datasetid:    "header"
        ,dataname:    ["サンプルＩＤ", "サンプル項目１"]
        ,value:       ["",             ""]
        ,afterfunction: ""
      }
    ]
  });
}(jQuery, Rmenu));
(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_CustomersSelection = {};

  // インスタンスプロパティを追加する
  var AppSpec = App.AppSpec = new $R.Class($R.AppSpec);
  AppSpec.fn.init = function(name) {
    $R.log("AppSpec init : start");

    this.name       = name;
    this.nextname   = "";
    this.beforename = "";

    $R.log("AppSpec init : end");
  }

  // 共通モジュールを追加する
  AppSpec.include($R.Library.AppSpecMixin);

  AppSpec.include({
    // -----------------------------------------------------------------------------------------------
    // プログラム・JSONファイルのURL情報を定義する（サブシステム名・種類・Apps・プログラムフォルダ名）
    // -----------------------------------------------------------------------------------------------
    urlInfo: [
      {app:  "Myapp00/Html/Apps/R_CustomersSelection/"}
     ,{json: "Myapp00/Json/Apps/R_CustomersSelection/"}
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
      ["select",  "on照会OfCheckRequestData",        "on照会OfEditResponseData",        "onErrorResponseData"]
    // ここから追加処理
    ]
    // --------------------------------------------------
    // エンター・タブとPFキーのコールバック関数を定義する
    // --------------------------------------------------
   ,enterTabPFKey: {
      Enter:true
     ,Tab:true
     ,F1:"on選択"
     ,F2:null
     ,F3:null
     ,F4:null
     ,F5:null
     ,F6:null
     ,F7:null
     ,F8:null
     ,F9:"on最初のページ"
     ,F10:"on前のページ"
     ,F11:"on次のページ"
     ,F12:"on最後のページ"
     ,ESC:"on戻る"
     ,Forms:0
    }
    // ----------------------------------------------------------------
    // イベント設定はセレクタ・イベント・コールバック関数の順に指定する
    // ----------------------------------------------------------------
    // NAVボタンのイベントを定義する
   ,navButtonEvent: [
      ["#戻る",             "click", "on戻る"]
     ,["#選択",             "click", "on選択"]
     ,["#最初のページ",     "click", "on最初のページ"]
     ,["#前のページ",       "click", "on前のページ"]
     ,["#次のページ",       "click", "on次のページ"]
     ,["#最後のページ",     "click", "on最後のページ"]
     ,["#検索",                 "click", "on検索"]
     ,["#クリア",               "click", "onクリア"]
     ,["#mainTable td",     "click", "onテーブル行クリック"]
     // ここから追加処理
     ]
    // ----------------------------------------------------------------
    // 権限情報の設定（使用不可のロールを設定する）
    // ----------------------------------------------------------------
   ,roleInfo: [
      ["#戻る",                 [""]]
     ,["#選択",                 [""]]
     ,["#最初のページ",         [""]]
     ,["#前のページ",           [""]]
     ,["#次のページ",           [""]]
     ,["#最後のページ",         [""]]
     ,["#検索",                 [""]]
     ,["#クリア",               [""]]
     // ここから追加処理
    ]
    // バリデーションのイベントを定義する
   ,validationEvent: [
      ["#mainForm", "focus", "onFocus"]
     ,["#mainForm", "blur",  "onBlur"]
    ]
    // その他セレクターイベントを定義する
   ,selectorEvent: [
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
      ["deriveトータル件数", "model", "onDeriveトータル件数"]
    // ここから追加処理
    ]
    // その他カスタムイベントを定義する
   ,pubsubOtherEvent: [
      ["showページ情報",       "view", "showページ情報"]
     // ここから追加処理
    ]
    // ----------------------------------------------------------------------------------
    // 画面ヘッダ　キー定義
    // （自画面のセッションストレージに設定される）
    // datasetid  : datasetのidを指定する
    // dataname   : datasetの項目名を指定する
    // classname  : HTMLのクラス名を指定する
    // typename   : HTMLのTYPEを指定する
    // ----------------------------------------------------------------------------------
   ,sessionStorageHeaderKey: [
      {
         datasetid: "header"
        ,dataname:  ["検索得意先名称", "検索郵便番号", "検索住所"]
        ,classname: ["検索得意先名称", "検索郵便番号", "検索住所"]
        ,typename:  ["text",                 "text",     "text"]
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
        ,dataname:  ["得意先ＩＤ", "得意先名称"]
        ,typename:  ["dataset",  "dataset"]
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
      {
         datasetid: "header"
        ,dataname: ["カレントページ", "ページライン数"]
        ,typename: ["dataset",        "dataset"]
      }
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
    ]
    // ----------------------------------------------------------------------------------
    // 前画面からの引き継ぎデータ定義
    // datasetid  : datasetのidを指定する
    // dataname   : datasetの項目名を指定する
    // classname  : HTMLのクラス名を指定する
    // typename   : datasetもしくはHTMLのTYPEを指定する
    // ----------------------------------------------------------------------------------
   ,beforeStorageData: [
    ]
    // ----------------------------------------------------------------------------------
    // 選択画面への引き渡しデータ定義
    // requestname : 選択画面名を指定する
    // datasetid   : datasetのidを指定する
    // dataname    : datasetの項目名を指定する
    // value       : 空白（項目名の値がセットされ選択画面へ渡される）
    //
    // 呼び出し元画面がセットしたデータがここにセットされる
    // ----------------------------------------------------------------------------------
   ,selectStorageRequestData: [
      {
         responsename: ""
        ,datasetid:    ""
        ,dataname:    [""]
        ,value:       [""]
      }
    ]
    // ----------------------------------------------------------------------------------
    // 選択画面からの引き渡しデータ定義
    // responsename  : 自画面名を指定する
    // datasetid     : datasetのidを指定する
    // dataname      : datasetの項目名を指定する
    // value         : 空白（選択画面からの引き渡しデータの値がセットされる）
    // afterfunction : 後処理関数を指定する（同時に、pubsubOtherEventにも設定する）
    //
    // 画面明細キー定義のデータがセットされ、呼び出し元画面に渡される
    // ----------------------------------------------------------------------------------
   ,selectStorageResponseData: [
      {
         responsename: ""
        ,datasetid:    ""
        ,dataname:    [""]
        ,value:       [""]
        ,afterfunction: ""
      }
    ]
  });
}(jQuery, Rmenu));
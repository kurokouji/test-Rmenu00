(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MainteContractList = {};

  // インスタンスプロパティを追加する
  var AppSpec = App.AppSpec = new $R.Class($R.AppSpec);
  AppSpec.fn.init = function(name) {
    $R.log("AppSpec init : start");

    this.name       = name;
    this.nextname   = "R_MainteContractHD";
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
      {app:  "Setubi/Html/Apps/R_MainteContractList/"}
     ,{json: "Setubi/Json/Apps/R_MainteContractList/"}
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
      ["select",    "on照会OfCheckRequestData",    "on照会OfEditResponseData",    "onErrorResponseData"]
    // ここから追加処理
    ]
    // --------------------------------------------------
    // エンター・タブとPFキーのコールバック関数を定義する
    // --------------------------------------------------
   ,enterTabPFKey: {
      Enter:true
     ,Tab:true
     ,F1:"on登録"
     ,F2:"on転用"
     ,F3:"on訂正"
     ,F4:"on削除"
     ,F5:"on照会"
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
     ,["#登録",             "click", "on登録"]
     ,["#転用",             "click", "on転用"]
     ,["#訂正",             "click", "on訂正"]
     ,["#削除",             "click", "on削除"]
     ,["#照会",             "click", "on照会"]
     ,["#最初のページ",     "click", "on最初のページ"]
     ,["#前のページ",       "click", "on前のページ"]
     ,["#次のページ",       "click", "on次のページ"]
     ,["#最後のページ",     "click", "on最後のページ"]
     ,["#検索",             "click", "on検索"]
     ,["#クリア",           "click", "onクリア"]
     ,["#mainTable td",     "click", "onテーブル行クリック"]
     // ここから追加処理
     ,["#契約保守作業明細照会", "click", "on契約保守作業明細照会"]
     ,["#契約保守諸掛明細照会", "click", "on契約保守諸掛明細照会"]
     ,["#保守サービス指示一覧", "click", "on保守サービス指示一覧"]
     ]
    // ----------------------------------------------------------------
    // 権限情報の設定（使用不可のロールを設定する）
    // ----------------------------------------------------------------
   ,roleInfo: [
      ["#戻る",                 [""]]
     ,["#登録",                 [""]]
     ,["#転用",                 [""]]
     ,["#訂正",                 [""]]
     ,["#削除",                 [""]]
     ,["#照会",                 [""]]
     ,["#最初のページ",         [""]]
     ,["#前のページ",           [""]]
     ,["#次のページ",           [""]]
     ,["#最後のページ",         [""]]
     ,["#検索",                 [""]]
     ,["#クリア",               [""]]
     // ここから追加処理
     ,["#契約保守作業明細照会", [""]]
     ,["#契約保守諸掛明細照会", [""]]
     ,["#保守サービス指示一覧", [""]]
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
      ["showページ情報",     "view", "showページ情報"]
     // ここから追加処理
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
        ,dataname:  ["検索顧客名称", "検索設備タイプ名称", "検索設備名称", "検索業者名称", "検索作業区分"]
        ,classname: ["検索顧客名称", "検索設備タイプ名称", "検索設備名称", "検索業者名称", "検索作業区分"]
        ,typename:  ["text",         "text",               "text",         "text",         "text"]
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
        ,dataname:  ["契約ＮＯ", "設備行番", "設備タイプ", "作業区分"]
        ,typename:  ["dataset",  "dataset",  "dataset",    "dataset"]
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
      {
         datasetid:   "header"
        ,dataname:    ["検索顧客名称",    "検索業者名称"]
        ,validation:  ["nonrequired",     "nonrequired"]
        ,titlename:   ["検索顧客名称",    "検索業者名称"]
      },
      {
         datasetid:   "detail"
        ,dataname:    ["契約ＮＯ",    "設備行番",    "設備タイプ",  "作業区分"]
        ,validation:  ["nonrequired", "nonrequired", "nonrequired", "nonrequired"]
        ,titlename:   ["契約ＮＯ",    "設備行番",    "設備タイプ",  "作業区分"]
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
        ,dataname:  ["検索顧客名称", "検索業者名称"]
        ,classname: ["検索顧客名称", "検索業者名称"]
        ,typename:  ["dataset",      "dataset"]
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
    ]
  });
}(jQuery, Rmenu));
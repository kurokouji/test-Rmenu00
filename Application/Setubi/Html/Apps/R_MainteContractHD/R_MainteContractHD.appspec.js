(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MainteContractHD = {};

  // インスタンスプロパティを追加する
  var AppSpec = App.AppSpec = new $R.Class($R.AppSpec);
  AppSpec.fn.init = function(name) {
    $R.log("AppSpec init : start");

    this.name       = name;
    this.nextname   = "";
    this.beforename = "R_MainteContractList";

    $R.log("AppSpec init : end");
  }

  // 共通モジュールを追加する
  AppSpec.include($R.Library.AppSpecMixin);

  AppSpec.include({
    // -----------------------------------------------------------------------------------------------
    // プログラム・JSONファイルのURL情報を定義する（サブシステム名・種類・Apps・プログラムフォルダ名）
    // -----------------------------------------------------------------------------------------------
    urlInfo: [
      {app:  "Setubi/Html/Apps/R_MainteContractHD/"}
     ,{json: "Setubi/Json/Apps/R_MainteContractHD/"}
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
     ,["init",        "on初期処理OfCheckRequestData",        "on初期処理OfEditResponseData",       "onErrorResponseData"]
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
     ,["#顧客検索",       "click", "on顧客検索"]
     ,[".標準業者",       "click", "on標準業者"]
     ,[".作業明細",       "click", "on作業明細"]
    ]
    // ----------------------------------------------------------------
    // 権限情報の設定（使用不可のロールを設定する）
    // ----------------------------------------------------------------
   ,roleInfo: [
      ["#戻る",             [""]]
     ,["#実行",             [""]]
     // ここから追加処理
     ,["#顧客検索",         [""]]
     ,[".標準業者",         [""]]
     ,[".作業明細",         [""]]
    ]
    // バリデーションのイベントを定義する
   ,validationEvent: [
      ["#mainForm", "focus", "onFocus"]
     ,["#mainForm", "blur",  "onBlur"]
    ]
    // その他セレクターイベントを定義する
   ,selectorEvent: [
      [".削除",        "change", "onChange削除"]
    // ここから追加処理
     ,[".設備タイプ",  "change", "onChange設備タイプ"]
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
     ,["on顧客検索後処理",      "controller", "on顧客検索後処理"]
     ,["on標準業者後処理",      "controller", "on標準業者後処理"]
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
        ,dataname:  ["契約ＮＯ"]
        ,classname: ["契約ＮＯ"]
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
        ,dataname:  ["設備行番", "設備タイプ"]
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
        ,dataname:    ["契約ＮＯ"]
        ,validation:  ["required"]
        ,titlename:   ["契約ＮＯ"]
      },
      {
         datasetid:   "detail"
        ,dataname:    ["設備行番", "設備タイプ"]
        ,validation:  ["required", "required"]
        ,titlename:   ["設備行番", "設備タイプ"]
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
        ,dataname:  ["契約ＮＯ"]
        ,classname: ["契約ＮＯ"]
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
         requestname: "R_CustomersSelection"
        ,datasetid:   ""
        ,dataname:   []
        ,value:      []
      },
      {
         requestname: "R_TraderSelection"
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
         responsename: "R_MainteContractHD"
        ,datasetid:    "header"
        ,dataname:    ["顧客ＩＤ", "顧客名称"]
        ,value:       ["",         ""]
        ,afterfunction: ""
      },
      {
         responsename: "R_MainteContractHD"
        ,datasetid:    "detail"
        ,dataname:    ["業者ＩＤ", "業者名称"]
        ,value:       ["",             ""]
        ,afterfunction: ""
      }
    ]
    // ----------------------------------------------------------------------------------
    // セレクトボックス　定義
    // selectorid  : HTMLのIDを指定する
    // selectorname: HTMLのnameを指定する（テーブル内で使用する時に定義する）
    // init        :
    // initvalue   : 初期値（０）
    // inithtml    : 初期表示（～選択）
    // datasetid   : datasetのID名を指定する
    // valuename   : datasetに定義されているキー値の項目名
    // htmlname    : datasetに定義されている表示用データの項目名
    // change      :
    // datasetid   : datasetのID名を指定する
    // valuename   : 選択したキー値を格納するdatasetの項目名
    // htmlname    : 選択した表示値を格納するdatasetの項目名
    // ----------------------------------------------------------------------------------
   ,selectbox: [
      {
          selectorid: "設備タイプ"
         ,selectorname: "設備タイプ"
         ,init:     {initvalue: "", inithtml: "設備タイプ選択", datasetid: "選択設備タイプ", valuename: "選択設備タイプ", htmlname: "選択設備タイプ名称"}
         ,change:   {datasetid: "detail", valuename: "設備タイプ", htmlname: ""}
      }
    ]
    // ----------------------------------------------------------------------------------
    // 明細行　削除チェックボックス　定義
    // selectorid  : HTMLのIDを指定する
    // selectorname: HTMLのnameを指定する（テーブル内で使用する時に定義する）
    // datasetid   : チェックボックスの値が設定されるdatasetのＩＤ名を指定する
    // datasetname : チェックボックスの値が設定されるdatasetの項目名を指定する
    // value       :
    // on          : チェックされた時に取る値を指定する
    // off         : チェックが外された時に取る値を指定する
    // ----------------------------------------------------------------------------------
   ,checkboxDetail: [
      {
          selectorid: "", selectorname: "削除", datasetid: "detail", datasetname: "削除"
         ,value:     {on: "9", off: "0"}
      }
    ]
  });
}(jQuery, Rmenu));
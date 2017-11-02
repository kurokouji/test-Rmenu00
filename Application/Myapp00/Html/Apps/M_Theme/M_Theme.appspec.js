(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.M_Theme = {};

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
      {app:  "Myapp00/Html/Apps/M_Theme/"}
     ,{json: "Myapp00/Json/Apps/M_Theme/"}
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
      ["select",    "on照会OfCheckRequestData",  "on照会OfEditResponseData",  "onErrorResponseData"]
     ,["execute",   "on実行OfCheckRequestData",  "on実行OfEditResponseData",  "onErrorResponseData"]
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
      ["#戻る",               "click", "on戻る"]
     ,["#実行",               "click", "on実行"]
     ,[".使用",               "click", "on使用行クリック"]
    ]
    // バリデーションのイベントを定義する
   ,validationEvent: [
      ["#mainForm", "focus", "onFocus"]
     ,["#mainForm", "blur",  "onBlur"]
    ]
    // その他セレクターイベントを定義する
   ,selectorEvent: [
      [".削除",              "change", "on削除"]
    // ここから追加処理
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
      // ここから追加
    ]
    // ----------------------------------------------------------------------------------
    // 画面ヘッダ　キー定義
    // （自画面のセッションストレージに設定される）
    // ----------------------------------------------------------------------------------
   ,sessionStorageHeaderKey: [
    ]
    // ----------------------------------------------------------------------------------
    // 画面明細　キー定義
    // テーブル明細行をクリックしたときに設定するキー項目名を指定する
    // （自画面のセッションストレージに設定される）
    // ----------------------------------------------------------------------------------
   ,sessionStorageDetailKey: [
      {
         datasetid: "detail"
        ,dataname:  ["テーマコード"]
        ,typename:  ["dataset"]
      }
    ]
    // ----------------------------------------------------------------------------------
    // 画面フッター　キー定義
    // （自画面のセッションストレージに設定される）
    // ----------------------------------------------------------------------------------
   ,sessionStorageFooterKey: [
    ]
    // ----------------------------------------------------------------------------------
    // 次画面への引き継ぎデータ定義
    // （次画面のセッションストレージに設定される）
    // ----------------------------------------------------------------------------------
   ,nextStorageData: [
    ]
    // ----------------------------------------------------------------------------------
    // 前画面からの引き継ぎデータ定義
    // ----------------------------------------------------------------------------------
   ,beforeStorageData: [
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
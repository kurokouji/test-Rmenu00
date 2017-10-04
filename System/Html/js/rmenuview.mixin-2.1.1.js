(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // データフォーマット関数
  App.FormatMixin = {
    formatExecute: {
      yyyySmmSdd: {
        format: function(value) {
          if (value == "") return value;
          var yyyy = value.substring(0, 4);
          var mm   = value.substring(4, 6);
          var dd   = value.substring(6, 8);
          return yyyy + "/" + mm + "/" + dd;
        }
       ,unformat: function(value) {
          if (value == "") return value;
          return new String(value).replace( /\//g, "" );
        }
      }
     ,yyyyNmmTddH: {
        format: function(value) {
          if (value == "") return value;
          var yyyy      = value.substring(0, 4);
          var mm        = value.substring(4, 6);
          var dd        = value.substring(6, 8);
          return yyyy + "年" + mm + "月" + dd + "日";
        }
       ,unformat: function(value) {
          if (value == "") return value;
          var yyyy = value.substring(0, 4);
          var mm   = value.substring(5, 7);
          var dd   = value.substring(8, 10);
          return yyyy + mm + dd;
        }
      }
     ,yyyyNmmT: {
        format: function(value) {
          if (value == "") return value;
          var yyyy      = value.substring(0, 4);
          var mm        = value.substring(4, 6);
          return yyyy + "年" + mm + "月";
        }
       ,unformat: function(value) {
          if (value == "") return value;
          var yyyy = value.substring(0, 4);
          var mm   = value.substring(5, 7);
          return yyyy + mm;
        }
      }
     ,quantity: {
        format: function(value) {
          if (value == "") return value;
          var formatvalue = String(value);
          return formatvalue.replace(/(\d)(?=(\d\d\d)+$)/g, "$1,");
        //for(i = 0; i < formatvalue.length/3; i++){
        //  return formatvalue.replace(/^([+-]?\d+)(\d\d\d)/,"$1,$2");
        //}
        }
       ,unformat: function(value) {
          if (value == "") return value;
          return new String(value).replace( /,/g, "" );
        }
      }
     ,price: {
        format: function(value) {
          if (value == "") return value;
          var formatvalue = String(value);
          return formatvalue.replace(/(\d)(?=(\d\d\d)+$)/g, "$1,");
        //for(i = 0; i < formatvalue.length/3; i++){
        //  return formatvalue.replace(/^([+-]?\d+)(\d\d\d)/,"$1,$2");
        //}
        }
       ,unformat: function(value) {
          if (value == "") return value;
          return new String(value).replace( /,/g, "" );
        }
      }
     ,money: {
        format: function(value) {
          if (value == "") return value;
          var formatvalue = String(value);
          return formatvalue.replace(/(\d)(?=(\d\d\d)+$)/g, "$1,");
        //for(i = 0; i < formatvalue.length/3; i++){
        //  return formatvalue.replace(/^([+-]?\d+)(\d\d\d)/,"$1,$2");
        //}
        }
       ,unformat: function(value) {
          if (value == "") return value;
          return new String(value).replace( /,/g, "" );
        }
      }
    }
    // 値をフォーマットする
   ,onDataFormat: function(arg) {
      $R.log("FormatMixin dataFormat : start");

      var value = arg["value"];
      var rule  = arg["rule"];
      if (rule in this.formatExecute) {
        value = this.formatExecute[rule].format(value);
      }

      $R.log("FormatMixin dataFormat : end");
      return value;
    }
    // フォーマットを元の値に戻す
   ,onDataUnformat: function(arg) {
      $R.log("FormatMixin dataUnformat : start");

      var value = arg["value"];
      var rule  = arg["rule"];
      if (rule in this.formatExecute) {
        value = this.formatExecute[rule].unformat(value);
      }

      $R.log("FormatMixin dataUnformat : end");
      return value;
    }
  };
  // アウトライン関数
  App.OutlineMixin = {
    // アウトラインプロパティを設定する
    setOutlineProperty: function() {
      this.focusName;
      this.focusCurRow    = 0;
      this.focusCurCell   = 0;
      this.focusIndex     = 0;
      this.blurName;
      this.blurCurRow     = 0;
      this.blurCurCell    = 0;
      this.blurIndex      = 0;
    }
    // ローディング画像を表示する場所を設定する
   ,setLoadingImage: function() {
      var data = '<div id="loading" />';
      $("body").append(data);
    }
    // アウトラインイベントを設定し、コールバック関数を指定する
   ,setOutlineEvent: function(outlineEvent) {
      $R.log("OutlineMixin setOutlineEvent : start");

      this.setOutlineProperty();
      this.setLoadingImage();

      $R.log("OutlineMixin setOutlineEvent : end");
    }
  };

  // テンプレートファイル　ロード関数
  App.LoadTemplateMixin = {
    // ナビバー　テンプレート　ファイルを設定する
    loadNavBar: function(arg) {
      $R.log("LoadTemplateMixin loadPageNavBar : start");

      if (arg["htmlName"]) {
        var url = $R.ApplicationURL + "/" + arg["htmlName"];
        $('#rmenu-navbar').loadTemplate(url, arg);
      }

      $R.log("LoadTemplateMixin loadPageNavBar : end");
    }
    // ヘッダー　テンプレート　ファイルを設定する
   ,loadHeader: function(arg) {
      $R.log("LoadTemplateMixin loadHeader : start");

      if (arg["htmlName"]) {
        var url = $R.ApplicationURL + "/" + arg["htmlName"];
        $('#rmenu-header').loadTemplate(url, arg);
      }

      $R.log("LoadTemplateMixin loadHeader : end");
    }
    // フッター　テンプレート　ファイルを設定する
   ,loadFooter: function(arg) {
      $R.log("LoadTemplateMixin loadFooter : start");

      if (arg["htmlName"]) {
        var url = $R.ApplicationURL + "/" + arg["htmlName"];
        $('#rmenu-footer').loadTemplate(url, arg);
      }

      $R.log("LoadTemplateMixin loadFooter : end");
    }
    // ページフッター　テンプレート　ファイルを設定する
   ,loadPageFooter: function(arg) {
      $R.log("LoadTemplateMixin loadPageFooter : start");

      if (arg["htmlName"]) {
        var url = $R.ApplicationURL + "/" + arg["htmlName"];
        $('#rmenu_pagefooter').loadTemplate(url, arg);
      }

      $R.log("LoadTemplateMixin loadPageFooter : end");
    }
    // HTMLテンプレートをロードする
   ,loadTemplate: function(arg) {
      $R.log("LoadTemplateMixin loadTemplate : start");

      var w_element  = arg["element"];
      var w_htmlname = arg["htmlName"];

      if (w_element) {
        if (w_htmlname) {
          var url = $R.ApplicationURL + "/" + w_htmlname;
          $(w_element).loadTemplate(url, arg);
        }
      }

      $R.log("LoadTemplateMixin loadTemplate : end");
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
  };

  // 関数を追加する
  App.ViewMixin = {
    onFocus: function(event, value) {
      $R.log("ViewMixin onFocus : start");

      var target = event.target;
      
      // 20150722 shimoji
      switch (target.type){
        case "button":
          break;
        case "checkbox":
          break;
        case "radio":
          break;
        case "file":
          break;
        case "select-one":
          break;
        case "select-multiple":
          break;
        default:
          target.value = value;
          break;
      }

      //if (target.type != "button") {
      //  target.value = value;
      //}

      var focusCurRow = 0;
      if (this.focusCurRow > 0) {
        focusCurRow = this.focusCurRow - 1;
      }
      var idname = "#error" + event.target.name + focusCurRow;
      if(!$(idname)) return;
      $(idname).hide();
      $(idname).remove();

      $R.log("ViewMixin onFocus : end");
    }
   ,onBlur: function(event) {
      $R.log("ViewMixin onBlur : start");

      // 入力データをフォーマットし再表示する
      var target = event.target;
      var value  = target.value;
      var rule   = this.format[target.name];
      var arg    = {value: value, rule: rule};

      // 20150722 shimoji
      switch (target.type){
        case "button":
          break;
        case "checkbox":
          break;
        case "radio":
          break;
        case "file":
          break;
        case "select-one":
          break;
        case "select-multiple":
          break;
        default:
          value        = this.onDataFormat(arg);
          target.value = value;
          break;
      }

      //if (target.type != "button") {
      //  value    = this.onDataFormat(arg);
      //  target.value = value;
      //}

      $R.log("ViewMixin onBlur : end");
    }
    // ガイドメッセージを表示する arg = {status: ステータス, message: メッセージ}
   ,onGuideMessage: function(arg) {
      $R.log("ViewMixin onGuideMessage : start");

      if (this.guidemessage) {
        $("#footer_status").html(arg["status"]);
        $("#footer_message").html(arg["message"]);
      }

      $R.log("ViewMixin onGuideMessage : end");
    }
    // エラーツールチップを表示する
    // arg = {target: イベントターゲット, message: エラーメッセージ, multiline: yes or no}
   ,onErrorToolTip: function(arg) {
      $R.log("ViewMixin onErrorToolTip : start");

      var toolTip = function(target, errorText, multiline, row) {
        var toolTip = $("<div id='error" + target.name + row + "'></div>");
        $(toolTip).addClass("errorToolTip");
        if ($(target).parent("td")) {
          // 20140925 shimoji
          //$(target).parent("td").append(toolTip);
          $(target).parents("td").append(toolTip);
        }
        if ($(target).parent("div")) {
          if ($(target).parent("div").parent("td")) {
            $(target).parent("div").parent("td").append(toolTip);
          }
          else {
            $(target).parent("div").append(toolTip);
          }
        }

        var message = $("<span>" + errorText  + "</span>");
        $(message).addClass("errorMessage");
        $(toolTip).append(message);
      }

      var length    = arg["message"].length;
      var errorText = "";
      for (var i = 0; i < length; i++) {
        errorText += arg["message"][i];
      }
      toolTip(arg["target"], errorText, arg["multiline"], arg["row"]);

      $R.log("ViewMixin onErrorToolTip : end");
    }
    // エラーツールチップを削除する arg = {target: イベントターゲット}
   ,onRemoveToolTip: function(arg) {
      $R.log("ViewMixin onRemoveToolTip : start");

      var idname = "#error" + arg["target"].name + arg["row"];
      if(!$(idname)) return;
      $(idname).hide();
      $(idname).remove();

      $R.log("ViewMixin onRemoveToolTip : end");
    }
    // 警告ダイアログ 初期設定
   ,initAlertDialog: function() {
      $R.log("ViewMixin initAlertDialog : start");

      var data = '<div class="modal fade" id="alertDialog" tabindex="-1" role="dialog" aria-labelledby="alertHeader" aria-hidden="true">';
      data += '<div class="modal-dialog">';
      data += '<div class="modal-content">';
      data += '<div class="modal-header">';
      data += '<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>';
      data += '<h4 class="modal-title" id="alertHeader">サーバ　エラー</h4>';
      data += '</div>';
      data += '<div class="modal-body" id="alertBody">';
      data += '<p></p></br>';
      data += '</div>';
      data += '<div class="modal-footer" id="alertFooter">'
      data += '<button type="button" class="btn btn-default" data-dismiss="modal" default-value="閉じる" '
      data += '>閉じる</button>'
      data += '</div>';
      data += '</div>';
      data += '</div>';
      data += '</div>';
      $("body").append(data);

      $R.log("ViewMixin initAlertDialog : end");
    }
    // 警告ダイアログを表示する
   ,onAlertDialog: function(arg) {
      $R.log("ViewMixin onAlertDialog : start");

      // 2013.05.28 光保 タイトル・メッセージに 複数行を設定できるようにしました
      if (Array.isArray(arg["title"])) {
        $("#alertHeader").html(arg["title"].join('<br />'));
      } else {
        $("#alertHeader").text(arg["title"]);
      }
      if (Array.isArray(arg["message"])) {
        $("#alertBody p").html(arg["message"].join('<br />'));
      } else {
        $("#alertBody p").text(arg["message"]);
      }
      // 2013.01.23 光保 ボタンの文字列を設定できるようにしました
      this.setDialogButtonLabels($("#alertFooter"), arg);
      $("#alertDialog").modal("show");

      $R.log("ViewMixin onAlertDialog : end");
    }
    // 確認ダイアログ 初期設定
   ,initConfirmDialog: function(object) {
      $R.log("ViewMixin initConfirmDialog : start");

      var self = object;
      var data  = '<div id="confirmDialog" class="modal fade" tabindex="-1" role="dialog">';
          data += '  <div class="modal-dialog">';
          data += '    <div class="modal-content">';
          data += '      <div id="confirmHeader" class="modal-header">';
          data += '        <h4>確認</h4>';
          data += '      </div>';  // alertHeader
          data += '      <div id="confirmBody" class="modal-body">';
          data += '        <p></p></br>';
          data += '      </div>';  // alertBody
          data += '      <div id="confirmFooter" class="modal-footer">';
          data += '        <input type="button" class="btn" data-dismiss="modal" aria-hidden="true" value="は　い" ';
          data += '          default-value="は　い" ';
          data += '          onclick="sessionStorage.setItem(\'confirmDialog\', 1);">';
          data += '        <input type="button" class="btn" data-dismiss="modal" aria-hidden="true" value="いいえ" ';
          data += '          default-value="いいえ" ';
          data += '          onclick="sessionStorage.setItem(\'confirmDialog\', 0);">';
          data += '      </div>';  // alertFooter
          data += '    </div>';  // alertDialog
          data += '  <div>';
          data += '<div>';
      $("body").append(data);

      $('#confirmDialog').on('hidden.bs.modal', function () {
        var status = self.pubsub.publish("confirmDialogAfter");
      })

      $R.log("ViewMixin initConfirmDialog : end");
    }
    // 確認ダイアログを表示する
   ,onConfirmDialog: function(arg) {
      $R.log("ViewMixin onConfirmDialog : start");

      // 2013.05.28 光保 タイトル・メッセージに 複数行を設定できるようにしました
      if (Array.isArray(arg["title"])) {
        $("#confirmHeader h4").html(arg["title"].join('<br />'));
      } else {
        $("#confirmHeader h4").text(arg["title"]);
      }
      if (Array.isArray(arg["message"])) {
        $("#confirmBody p").html(arg["message"].join('<br />'));
      } else {
        $("#confirmBody p").text(arg["message"]);
      }
      // 2013.01.23 光保 ボタンの文字列を設定できるようにしました
      this.setDialogButtonLabels($("#confirmFooter"), arg);
      $("#confirmDialog").modal("show")

      $R.log("ViewMixin onConfirmDialog : end");
    }
    // 実行確認ダイアログ 初期設定
   ,initExecuteDialog: function(object) {
      $R.log("ViewMixin initExecuteDialog : start");

      var self = object;
      var data  = '<div id="executeDialog" class="modal fade" tabindex="-1" role="dialog">';
          data += '  <div class="modal-dialog">';
          data += '    <div class="modal-content">';
          data += '      <div id="executeHeader" class="modal-header">';
          data += '        <h4>実行確認</h4>';
          data += '      </div>';  // alertHeader
          data += '      <div id="executeBody" class="modal-body">';
          data += '        <p></p></br>';
          data += '      </div>';  // alertBody
          data += '      <div id="executeFooter" class="modal-footer">';
          data += '        <input type="button" class="btn" data-dismiss="modal" aria-hidden="true" value="は　い" ';
          data += '          default-value="は　い" ';
          data += '          onclick="sessionStorage.setItem(\'executeDialog\', 1);">';
          data += '        <input type="button" class="btn" data-dismiss="modal" aria-hidden="true" value="いいえ" ';
          data += '          default-value="いいえ" ';
          data += '          onclick="sessionStorage.setItem(\'executeDialog\', 0);">';
          data += '      </div>';  // alertFooter
          data += '    </div>';  // alertDialog
          data += '  </div>';
          data += '</div>';
      $("body").append(data);

      $('#executeDialog').on('hidden.bs.modal', function () {
        var status = self.pubsub.publish("executeDialogAfter");
      })

      $R.log("ViewMixin initExecuteDialog : end");
    }
    // 実行確認ダイアログを表示する
   ,onExecuteDialog: function(arg) {
      $R.log("ViewMixin onExecuteDialog : start");

      // 2013.05.28 光保 タイトル・メッセージに 複数行を設定できるようにしました
      if (Array.isArray(arg["title"])) {
        $("#executeHeader h4").html(arg["title"].join('<br />'));
      } else {
        $("#executeHeader h4").text(arg["title"]);
      }
      if (Array.isArray(arg["message"])) {
        $("#executeBody p").html(arg["message"].join('<br />'));
      } else {
        $("#executeBody p").text(arg["message"]);
      }
      // 2013.01.23 光保 ボタンの文字列を設定できるようにしました
      this.setDialogButtonLabels($("#executeFooter"), arg);
      $("#executeDialog").modal("show")

      $R.log("ViewMixin onExecuteDialog : end");
    }

    // サーバ確認ダイアログ 初期設定
   ,initServerDialog: function(object) {
      $R.log("ViewMixin initServerDialog : start");

      var self = object;
      var data = '<div class="modal fade" id="serverDialog" tabindex="-1" role="dialog" aria-labelledby="serverHeader" aria-hidden="true">';
         data += '  <div class="modal-dialog">';
         data += '    <div class="modal-content">';
         data += '      <div class="modal-header">';
         data += '        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>';
         data += '        <div class="modal-header" id="serverHeader">';
         data += '          <h4>サーバ確認</h4>';
         data += '        </div>';
         data += '      </div>';
         data += '      <div class="modal-body" id="serverBody">';
         data += '        <p></p></br>';
         data += '      </div>';
         data += '      <div class="modal-footer" id="serverFooter">'
         data += '        <button type="button" class="btn btn-default" data-dismiss="modal" default-value="ＯＫ" '
         data += '          onclick="sessionStorage.setItem(\'serverDialog\', 1);">ＯＫ</button>'
         data += '      </div>';
         data += '    </div>';
         data += '  </div>';
         data += '</div>';
      $("body").append(data);

      $('#serverDialog').on('hidden.bs.modal', function () {
        var status = self.pubsub.publish("serverDialogAfter");
      })

      $R.log("ViewMixin initServerDialog : end");
    }
    // サーバ確認ダイアログを表示する
   ,onServerDialog: function(arg) {
      $R.log("ViewMixin onServerDialog : start");

      // 2013.05.28 光保 タイトル・メッセージに 複数行を設定できるようにしました
      if (Array.isArray(arg["title"])) {
        $("#serverHeader h4").html(arg["title"].join('<br />'));
      } else {
        $("#serverHeader h4").text(arg["title"]);
      }
      if (Array.isArray(arg["message"])) {
        $("#serverBody p").html(arg["message"].join('<br />'));
      } else {
        $("#serverBody p").text(arg["message"]);
      }
      // 2013.01.23 光保 ボタンの文字列を設定できるようにしました
      this.setDialogButtonLabels($("#serverFooter"), arg);
      $("#serverDialog").modal("show")

      $R.log("ViewMixin onServerDialog : end");
    }

    // 2013.01.23 光保
    // ダイアログのボタンを設定します
   ,setDialogButtonLabels: function(footer_object, arg) {
      $R.log("ViewMixin setDialogButtonLabels : start");

      if ('button_labels' in arg) {
        footer_object.find('input[type="button"]').each(function(index) {
          $(this).val(arg.button_labels[index] !== undefined ?
            arg.button_labels[index] : $(this).attr('default-value'));
        });
      }

      $R.log("ViewMixin setDialogButtonLabels : end");
    }

    // -------------------------------------------------------
    // テーブルの明細行を複製する（１行目をコピーして作成する）
    // -------------------------------------------------------
   ,createTableRows: function(tableid, defaultline) {
      $R.log("ViewMixin createTableRows : start");

      var copySize = defaultline - 1;
      for (var i = 0; i < copySize; i++) {
        $(tableid  + " tbody tr").eq(0).clone(true).insertAfter($(tableid  + " tbody tr").eq(i));
      }

      $R.log("ViewMixin createTableRows : end");
    }
    // -------------------------------------------------------
    // テーブルのボディ部を複製する
    // -------------------------------------------------------
   ,createTableBodys: function(tableid, defaultline) {
      $R.log("ViewMixin createTableBodys : start");

      var i;
      defaultline = defaultline - 1;
      for (i = 0; i < defaultline; i++) {
        $(tableid  + " tbody").eq(0).clone(true).insertAfter($(tableid  + " tbody").eq(i));
      }

      $R.log("ViewMixin createTableBodys : end");
    }
    // -------------------------------------------------------
    // テーブルにデータを表示する
    // -------------------------------------------------------
   ,showTableData: function(arg) {
      $R.log("ViewMixin showTableData : start");

      var tableID     = arg["テーブルＩＤ"];
      var tableData   = arg["テーブルデータ"];

      // 表示中のデータをクリアする
      var table = document.getElementById(tableID);  
      //rowsプロパティで行を参照できる。  
      //ループで全行にアクセス。  
      for (var i = 1; i < table.rows.length; i++ ) {  
        //インデックスで各行の参照取得可能。  
        var row = table.rows[i];  
        //セルへの参照はrowのcellsプロパティ。  
        for (var j = 0; j < row.cells.length; j++ ) {  
            row.cells[j].innerHTML = "";  
        }  
      }
 
      // 表示するデータの行数を取得する
      var max = 0;
      for (var name in tableData["record"]) {
        max = tableData["record"][name]["value"].length;
        break;
      }

      // データを表示する
      var table = document.getElementById(tableID);  
      for (var i = 0; i < max; i++ ) {  
        var row = table.rows[i + 1];  
        var j = 0;
        for (var name in tableData["record"]) {
          if (tableData["record"][name]["value"][i]) {
            row.cells[j].innerHTML = tableData["record"][name]["value"][i];
          }
          else {
            row.cells[j].innerHTML = "";
          }
          j++;
          if (row.cells.length <= j){  //20150708 追加 Okada
            break;                    //20150708 追加 Okada
          }                           //20150708 追加 Okada
        }
      } 

      $R.log("ViewMixin showTableData : end");
    }
    // -------------------------------------------------------
    // テーブル明細を削除＆作成する
    // -------------------------------------------------------
   ,deleteShowTableData: function(arg) {
      $R.log("ViewMixin deleteShowTableData : start");

       tableID   = arg["テーブルＩＤ"];
       tableData = arg["テーブルデータ"];

       // 明細行を削除する
       var table = document.getElementById(tableID);
       var max   = table.rows.length - 1;
       var i;
       for (i = max; i > 0; i--) {
         table.deleteRow(i);
       }
       
      // 表示するデータの行数を取得する
       var member_info = tableData["record"];
       for (var name in tableData["record"]) {
         max = tableData["record"][name]["value"].length;
         break;
       }

       // データを表示する
       for (i = 0; i < max; i++) {
         var table = document.getElementById(tableID);
         var row   = table.insertRow(-1);

         for (var name in tableData["record"]) {
           var cell  = row.insertCell(-1);
           var value = tableData["record"][name]["value"][i];
           cell.appendChild(document.createTextNode(value));
         }
       }

      $R.log("ViewMixin deleteShowTableData : end");
    }
    
    // -------------------------------------------------------
    // テーブル明細を削除＆作成する
    // -------------------------------------------------------
   ,showTableALLData: function(arg) {
      $R.log("ViewMixin showTableALLData : start");
      
      var w_テーブルＩＤ = arg["テーブルＩＤ"];
      var w_表示データ   = arg["表示データ"];
      var w_デフォルト行 = arg["デフォルト行"];
      
      var w_データ行数 = 0;
      for (var name in w_表示データ["record"]) {
        w_データ行数 = w_表示データ["record"][name]["value"].length  - 1;
        break;
      }
      
      // テーブルの２行目以降を削除する
      $(w_テーブルＩＤ).find("tr:gt(1)").remove();

      //  テーブルの１行目の内容をクリア
      var cells = $(w_テーブルＩＤ + " tbody").find("tr:eq(0)").children();
      for (var i = 0; i < cells.length; i++) {
        cells.eq(i).text("");
      }


      // テーブルの表示行数を設定する
      w_表示行 = w_デフォルト行 - 1;
      if (w_表示行 < w_データ行数) {
        w_表示行 = w_データ行数;
      }

      // １行目をコピーして、表示行数分テーブルを作成する
      for (var i = 0; i < w_表示行; i++) {
        $(w_テーブルＩＤ + " tbody").eq(0).clone(true).insertAfter($(w_テーブルＩＤ + " tbody").eq(i));
      }


      // データを表示する
      // テーブルの全行を取得する
      var rows = $(w_テーブルＩＤ + " tbody tr");
      for (var i = 0; i < rows.length; i++) {
        // 行の全セルを取得する
        var cells       = rows.eq(i).children();
        var cellsLength = cells.length;
  
        var j     = 0;
        for (var name in w_表示データ["record"]) {
          if (j >= cellsLength) {
            break;
          }
          
          cells.eq(j).text(w_表示データ["record"][name]["value"][i]);
          j++;
        }
        
      }
      
      $R.log("ViewMixin showTableALLData : end");
    }

    // -------------------------------------------------------
    // セレクトボックス表示処理（ＩＤでの設定）
    // -------------------------------------------------------
   ,onShowSelectBox: function(defSelectBox, responseRecord) {
      $R.log("ViewMixin onShowSelectBox : start");

      var selectorID = defSelectBox["selectorid"];
      var initValue  = defSelectBox["init"]["initvalue"];
      var initHtml   = defSelectBox["init"]["inithtml"];
      var valueName  = defSelectBox["init"]["valuename"];
      var htmlName   = defSelectBox["init"]["htmlname"];
      var max        = responseRecord[valueName]["value"].length;

      $("#" + selectorID + " option").remove(); //20150703 追加 Okada

      var option = $('<option selected:selected/>');
      if (initHtml) {
        option.val(initValue);
        option.html(initHtml);
        $("#" + selectorID).append(option);
      }
      

      for (var i = 0; i < max; i++) {
        option = $('<option />');
        option.val(responseRecord[valueName]["value"][i]);
        option.html(responseRecord[htmlName]["value"][i]);
        $("#" + selectorID).append(option);
      }

      $R.log("ViewMixin onShowSelectBox : end");
    }
    
    // --------------------------------------------------------------
    // セレクトボックス表示処理　ＩＤからカレント行を一括表示する
    // --------------------------------------------------------------
   ,showCurrentSelectBox: function(dataSetInfo, defSelectBox) {
      $R.log("View setCurrentSelectBox : start");
      
      var max = defSelectBox.length;
      for (var i = 0; i < max; i++) {
        
        var selectorid    = defSelectBox[i]["selectorid"];
        var detasetID     = defSelectBox[i]["change"]["datasetid"];
        var codeName      = defSelectBox[i]["change"]["valuename"];
        
        var dataSetRecord = this.appspec.getJSONChunkByIdAtRecords(dataSetInfo, detasetID);
        var codeValue     = dataSetRecord["record"][codeName]["value"][0];
        
        $("#" + selectorid).val(codeValue);
        
      }

      $R.log("View setCurrentSelectBox : end");
    }
    
    // -------------------------------------------------------
    // チェックボックス表示処理
    // -------------------------------------------------------
   ,onShowCheckBox: function(defCheckBox, responseRecord) {
      $R.log("ViewMixin onShowCheckBox : start");
      
      var selectorID  = defCheckBox["selectorid"]
      var datasetName = defCheckBox["datasetname"];
      var onValue     = defCheckBox["value"]["on"];
      var offValue    = defCheckBox["value"]["off"];
      
      if (responseRecord[datasetName]["value"][0] == onValue) {
        $("#" + selectorID).prop("checked", true);
      }
      if (responseRecord[datasetName]["value"][0] == offValue) {
        $("#" + selectorID).prop("checked", false);
      }

      $R.log("ViewMixin onShowCheckBox : end");
    }
    
    // -------------------------------------------------------
    // テーブル　チェックボックス表示処理
    // -------------------------------------------------------
   ,onShowCheckBoxTable: function(defCheckBox, responseRecord) {
      $R.log("ViewMixin onShowCheckBoxTable : start");
      
      var selectorName = defCheckBox["selectorname"]
      var datasetName  = defCheckBox["datasetname"];
      var onValue      = defCheckBox["value"]["on"];
      var offValue     = defCheckBox["value"]["off"];
      var max          = responseRecord[datasetName]["value"].length;
      var targetObject = $("." + selectorName);
      
      for (var i = 0; i < max; i++) {
        if (responseRecord[datasetName]["value"][i] == onValue) {
          $(targetObject[i]).prop("checked", true);
        }
        if (responseRecord[datasetName]["value"][i] == offValue) {
          $(targetObject[i]).prop("checked", false);
        }
      }

      $R.log("ViewMixin onShowCheckBoxTable : end");
    }
    
    // -------------------------------------------------------
    // ラジオボタン表示処理
    // -------------------------------------------------------
   ,onShowRadioButton: function(defRadioButton, responseRecord) {
      $R.log("ViewMixin onShowRadioButton : start");


      $R.log("ViewMixin onShowRadioButton : end");
    }
    
    // -------------------------------------------------------
    // ポップアップ画面　後処理
    // -------------------------------------------------------
   ,onClickPopupWindowAfter: function(arg, defPopup) {
      $R.log("ViewMixin onClickPopupWindowAfter : start");

      var inputArray    = defPopup["input"];
      var selectorArray = defPopup["selector"];
      var max           = defPopup["input"].length;
      
      for (var i = 0; i < max; i++) {
        var inputname  = inputArray[i];
        var selectorID = selectorArray[i];
        
        if (selectorID != "") {
          $("#" + selectorID).val(arg[inputname]);
        }
      }

      $R.log("ViewMixin onClickPopupWindowAfter : end");
    }

    // -------------------------------------------------------
    // Datasetの値をViewに表示する
    // -------------------------------------------------------
   ,fromDatasetToView: function(dataset, defData) {
      $R.log("ModelMixin fromDatasetToView : start");
      
      var datasetRecord = this.appspec.getJSONChunkByIdAtRecords(dataset, defData["id"]);
      var max           = defData["dataset"].length;
      
      for (var i = 0; i < max; i++) {
        var datasetName  = defData["dataset"][i];
        var selectorName = defData["selector"][i];
        
        if (selectorName != "") {
          $("#" + selectorName).val(datasetRecord["record"][datasetName]["value"][0]);
        }
      }

      $R.log("ModelMixin fromDatasetToView : end");
    }

    // 20170427 下地　追加
    // -------------------------------------------------------
    // JsonDataからテーブルを再描画する
    // -------------------------------------------------------
   ,resetJsonDataToTable: function(tableID, jsonData, idName, itemName) {
      $R.log("ViewMixin resetJsonDataToTable : start");

      // 明細テーブルの２行目移行を削除する
      this.deleteTableSecondRow(tableID);
      
      // 明細テーブルの１行目をクリアする
      var detailRecord = this.appspec.getJSONChunkByIdAtRecords(jsonData, idName)["record"];
      this.clearTableFirstRow(detailRecord);

      // 明細テーブルの１行目をデータ件数分コピーする
      var maxSize = detailRecord[itemName]["value"].length;
      this.copyTableFirstRow(tableID, maxSize);

      // 明細テーブルにデータを表示する
      this.showJsonDataToTable(detailRecord, maxSize);

      $R.log("ViewMixin resetJsonDataToTable : end");
    }
    
    // -------------------------------------------------------
    // テーブルの２行目以降を削除する
    // -------------------------------------------------------
   ,deleteTableSecondRow: function(tableID) {
      $R.log("ViewMixin deleteTableSecondRow : start");

      $(tableID).find("tbody tr:gt(0)").remove();

      $R.log("ViewMixin deleteTableSecondRow : end");
    }
    
    // -------------------------------------------------------
    // 明細テーブルの１行目をクリアする
    // -------------------------------------------------------
   ,clearTableFirstRow: function(detailRecord) {
      $R.log("ViewMixin clearTableFirstRow : start");

      for (var name in detailRecord) {
        var objArray = $("." + name);
        if ( !objArray.length ) {
          continue;
        }

        var tagName  = $(objArray)[0].tagName;
        var typeName = "";
        if (tagName == "INPUT") {
          typeName = $(objArray)[0].type;
        }
        
        this.setValueToObject(tagName, typeName, $(objArray)[0], "");
      }

      $R.log("ViewMixin clearTableFirstRow : end");
    }
    
    // -------------------------------------------------------
    // テーブルの１行目を指定行数分コピーする
    // -------------------------------------------------------
   ,copyTableFirstRow: function(tableID, maxSize) {
      $R.log("ViewMixin copyTableFirstRow : start");

      var copySize = maxSize - 1;
      for (var i = 0; i < copySize; i++) {
        $(tableID  + " tbody tr").eq(0).clone(true).insertAfter($(tableID  + " tbody tr").eq(i));
      }

      $R.log("ViewMixin copyTableFirstRow : end");
    }
    
    // -------------------------------------------------------
    // 明細テーブルにデータを表示する
    // -------------------------------------------------------
   ,showJsonDataToTable: function(detailRecord, maxSize) {
      $R.log("ViewMixin showJsonDataToTable : start");

      for (var i = 0; i < maxSize; i++) {
        for (var name in detailRecord) {
          var objArray = $("." + name);
          if ( !objArray.length ) {
            continue;
          }

          var tagName  = $(objArray)[0].tagName;
          var typeName = "";
          if (tagName == "INPUT") {
            typeName = $(objArray)[0].type;
          }
        
          var value = detailRecord[name]["value"][i];
          this.setValueToObject(tagName, typeName, $(objArray)[i], value);
        }
      }

      $R.log("ViewMixin showJsonDataToTable : end");
    }
    
   ,setValueToObject: function(tagName, typeName, object, value) {

      switch (tagName){
        case "INPUT":
          this.setValueToObjectOfInput(tagName, typeName, object, value);
          break;
        case "SELECT":
          this.setValueToObjectOfInput(tagName, typeName, object, value);
          break;
        default:
          this.setValueToObjectOfOther(tagName, typeName, object, value);
          break;
      }

    }

   ,setValueToObjectOfInput: function(tagName, typeName, object, value) {

      switch (typeName){
        case "text":
          if (object.name in this.format) {
            var rule = this.format[object.name];
            var arg  = {value: value, rule: rule};
            value = this.pubsub.publish("dataformat", arg);
            $(object).val(value);
          }
          else {
            $(object).val(value);
          }
          break;
        case "checkbox":
          if (value) {
            $(object).prop("checked", true);
          }
          else {
            $(object).prop("checked", false);
          }
          break;
        case "radio":
          if (value) {
            $(object).prop("checked", true);
          }
          else {
            $(object).prop("checked", false);
          }
          break;
        default:
          $(object).val(value);
          break;
      }
      
    }

   ,setValueToObjectOfOther: function(tagName, typeName, object, value) {
      
      switch (tagName){
        case "DIV":
          $(object).text(value);
          break;
        case "LABEL":
          $(object).text(value);
          break;
        default:
          $(object).html(value);
          break;
      }

    }

  };
}(jQuery, Rmenu));

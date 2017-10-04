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
    // アウトラインイベントを設定し、コールバック関数を指定する
   ,setOutlineEvent: function(outlineEvent) {
      $R.log("OutlineMixin setOutlineEvent : start");

      this.setOutlineProperty();

      $R.log("OutlineMixin setOutlineEvent : end");
    }
  };

  // 関数を追加する
  App.ViewMixin = {
    onFocus: function(event, value) {
      $R.log("ViewMixin onFocus : start");

      var target = event.target;
      if (target.type != "button") {
        target.value = value;
      }

      var idname = "#error" + event.target.name;
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
      if (target.type != "button") {
        value    = this.onDataFormat(arg);
        target.value = value;
      }

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

      var toolTip = function(target, errorText, multiline) {
        var idname  = "#error" + target.name
        var toolTip = $("<div id='error" + target.name + "'></div>");
        $(toolTip).addClass("errorToolTip");
        if ($(target).parent("td")) {
          $(target).parent("td").append(toolTip);
        }
        if ($(target).parent("div")) {
          $(target).parent("div").append(toolTip);
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
      toolTip(arg["target"], errorText, arg["multiline"]);

      $R.log("ViewMixin onErrorToolTip : end");
    }
    // エラーツールチップを削除する arg = {target: イベントターゲット}
   ,onRemoveToolTip: function(arg) {
      $R.log("ViewMixin onRemoveToolTip : start");

      var idname = "#error" + arg["target"].name;
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

      $("#alertHeader h4").text(arg["title"]);
      $("#alertBody p").text(arg["message"]);
      // 2013.01.23 光保 ボタンの文字列を設定できるようにしました
      this.setDialogButtonLabels($("#alertFooter"), arg);
      $("#alertDialog").modal("show");

      $R.log("ViewMixin onAlertDialog : end");
    }
    // 確認ダイアログ 初期設定
   ,initConfirmDialog: function(object) {
      $R.log("ViewMixin initConfirmDialog : start");

      var self = object;
      var data = '<div id= "confirmDialog" class="modal hide fade" tabindex="-1" role="dialog">';
      data += '<div id="confirmHeader" class="modal-header">';
      data += '<h4>確認</h4>';
      data += '<div>';  // alertHeader
      data += '<div id="confirmBody" class="modal-body">';
      data += '<p></p></br>';
      data += '<div>';  // alertBody
      data += '<div id="confirmFooter" class="modal-footer">';
      data += '<input type="button" class="btn" data-dismiss="modal" aria-hidden="true" value="は　い" ';
      data += 'default-value="は　い" ';
      data += 'onclick="sessionStorage.setItem(\'confirmDialog\', 1);">';
      data += '<input type="button" class="btn" data-dismiss="modal" aria-hidden="true" value="いいえ" ';
      data += 'default-value="いいえ" ';
      data += 'onclick="sessionStorage.setItem(\'confirmDialog\', 0);">';
      data += '<div>';  // alertFooter
      data += '<div>';  // alertDialog
      $("body").append(data);

      $('#confirmDialog').on('hidden', function () {
        var status = self.pubsub.publish("confirmDialogAfter");
      })

      $R.log("ViewMixin initConfirmDialog : end");
    }
    // 確認ダイアログを表示する
   ,onConfirmDialog: function(arg) {
      $R.log("ViewMixin onConfirmDialog : start");

      $("#confirmHeader h4").text(arg["title"]);
      $("#confirmBody p").text(arg["message"]);
      // 2013.01.23 光保 ボタンの文字列を設定できるようにしました
      this.setDialogButtonLabels($("#confirmFooter"), arg);
      $("#confirmDialog").modal("show")

      $R.log("ViewMixin onConfirmDialog : end");
    }
    // 実行確認ダイアログ 初期設定
   ,initExecuteDialog: function(object) {
      $R.log("ViewMixin initExecuteDialog : start");

      var self = object;
      var data = '<div id= "executeDialog" class="modal hide fade" tabindex="-1" role="dialog">';
      data += '<div id="executeHeader" class="modal-header">';
      data += '<h4>実行確認</h4>';
      data += '<div>';  // alertHeader
      data += '<div id="executeBody" class="modal-body">';
      data += '<p></p></br>';
      data += '<div>';  // alertBody
      data += '<div id="executeFooter" class="modal-footer">';
      data += '<input type="button" class="btn" data-dismiss="modal" aria-hidden="true" value="は　い" ';
      data += 'default-value="は　い" ';
      data += 'onclick="sessionStorage.setItem(\'executeDialog\', 1);">';
      data += '<input type="button" class="btn" data-dismiss="modal" aria-hidden="true" value="いいえ" ';
      data += 'default-value="いいえ" ';
      data += 'onclick="sessionStorage.setItem(\'executeDialog\', 0);">';
      data += '<div>';  // alertFooter
      data += '<div>';  // alertDialog
      $("body").append(data);

      $('#executeDialog').on('hidden', function () {
        var status = self.pubsub.publish("executeDialogAfter");
      })

      $R.log("ViewMixin initExecuteDialog : end");
    }
    // 実行確認ダイアログを表示する
   ,onExecuteDialog: function(arg) {
      $R.log("ViewMixin onExecuteDialog : start");

      $("#executeHeader h4").text(arg["title"]);
      $("#executeBody p").text(arg["message"]);
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
      data += '<div class="modal-dialog">';
      data += '<div class="modal-content">';
      data += '<div class="modal-header">';
      data += '<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>';
      data += '<h4 class="modal-title" id="serverHeader">サーバ確認</h4>';
      data += '</div>';
      data += '<div class="modal-body" id="serverBody">';
      data += '<p></p></br>';
      data += '</div>';
      data += '<div class="modal-footer" id="serverFooter">'
      data += '<button type="button" class="btn btn-default" data-dismiss="modal" default-value="ＯＫ" '
      data += 'onclick="sessionStorage.setItem(\'serverDialog\', 1);">ＯＫ</button>'
      data += '</div>';
      data += '</div>';
      data += '</div>';
      data += '</div>';
      $("body").append(data);

      $('#serverDialog').on('hidden', function () {
        var status = self.pubsub.publish("serverDialogAfter");
      })

      $R.log("ViewMixin initServerDialog : end");
    }
    // サーバ確認ダイアログを表示する
   ,onServerDialog: function(arg) {
      $R.log("ViewMixin onServerDialog : start");

      $("#serverHeader h4").text(arg["title"]);
      $("#serverBody p").text(arg["message"]);
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
    // テーブルの明細行を作成する（１行目をコピーして作成する）
    // -------------------------------------------------------
   ,createTableRows: function(tableid, defaultline) {
      $R.log("ViewMixin createTableRows : start");

      var i;
      defaultline = defaultline - 1;
      for (i = 0; i < defaultline; i++) {
        $(tableid  + " tbody tr").eq(0).clone(true).insertAfter($(tableid  + " tbody tr").eq(i));
      }

      $R.log("ViewMixin createTableRows : end");
    }
    // -------------------------------------------------------
    // テーブルにデータを表示する
    // -------------------------------------------------------
   ,showTableData: function(arg) {
      $R.log("View showTableData : start");

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
          row.cells[j].innerHTML = tableData["record"][name]["value"][i];
          j++;
        }
      } 

      $R.log("View showTableData : end");
    }
    // -------------------------------------------------------
    // テーブル明細を削除＆作成する
    // -------------------------------------------------------
   ,deleteShowTableData: function(arg) {
      $R.log("View deleteShowTableData : start");

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

      $R.log("View deleteShowTableData : end");
    }
  };
}(jQuery, Rmenu));

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.ModelMixin = {
    onFocus: function(event, row) {
      $R.log("ModelMixin onFocus : start");

      var target = event.target;
      var value  = "";
      
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
          value = this.dataset.getElementData(target.name, row);
          break;
      }

      //if (target.type != "button") {
      //  value = this.dataset.getElementData(target.name, row);
      //}

      $R.log("ModelMixin onFocus : end");
      return value;
    }
   ,onBlur: function(event, row) {
      $R.log("ModelMixin onBlur : start");

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
          this.dataset.setElementData(target.value, target.name, row);
          break;
      }

      //if (target.type != "button") {
      //  this.dataset.setElementData(target.value, target.name, row);
      //}

      $R.log("ModelMixin onBlur : end");
    }

    // -------------------------------------------------------
    // セレクトボックス　チェンジ処理
    // -------------------------------------------------------
   ,onChangeSelectBox: function(event, defSelectBox) {
      $R.log("ModelMixin onChangeSelectBox : start");
      
      var targetID    = event.target.id;
      var targetValue = $("#" + targetID).val();
      var targetHtml  = $("#" + targetID + " option:selected").text();
      
      var max      = defSelectBox.length;
      for (var i = 0; i < max; i++) {
        if (targetID != defSelectBox[i]["selectorid"]) {
          continue;
        }
        
        var datasetRecord = this.appspec.getJSONChunkByIdAtRecords(this.dataset.data, defSelectBox[i]["change"]["datasetid"]);
        var valueName     = defSelectBox[i]["change"]["valuename"];
        if (valueName) {
          datasetRecord["record"][valueName]["value"][0] = targetValue;
        }

        var htmlName     = defSelectBox[i]["change"]["htmlname"];
        if (htmlName) {
          datasetRecord["record"][htmlName]["value"][0] = targetHtml;
        }
        
        break;
      }

      $R.log("ModelMixin onChangeSelectBox : end");
      return targetValue;
    }
    
    // -------------------------------------------------------
    // テーブル　セレクトボックス　チェンジ処理
    // -------------------------------------------------------
   ,onChangeTableSelectBox: function(event, row, defSelectBox) {
      $R.log("ModelMixin onChangeTableSelectBox : start");
      
      var targetID     = event.target.id;
      var targetName   = event.target.name;
      var targetObject = $("." + targetName);
      var targetValue  = $(targetObject[row]).val();
      //var targetHtml   = $(targetObject[row] + " option:selected").text();

      var max      = defSelectBox.length;
      for (var i = 0; i < max; i++) {
        if (targetID != defSelectBox[i]["selectorid"]) {
          continue;
        }
        
        var datasetRecord = this.appspec.getJSONChunkByIdAtRecords(this.dataset.data, defSelectBox[i]["change"]["datasetid"]);
        var valueName     = defSelectBox[i]["change"]["valuename"];
        if (valueName) {
          datasetRecord["record"][valueName]["value"][row] = targetValue;
        }

        //var htmlName     = defSelectBox[i]["change"]["htmlname"];
        //if (htmlName) {
        //  datasetRecord["record"][htmlName]["value"][row] = targetHtml;
        //}
        
        break;
      }

      $R.log("ModelMixin onChangeTableSelectBox : end");
      return targetValue;
    }
    
    // -------------------------------------------------------
    // チェックボックス　チェンジ処理
    // -------------------------------------------------------
   ,onChangeCheckBox: function(event, defCheckBox) {
      $R.log("ModelMixin onChangeCheckBox : start");

      var targetID    = event.target.id;
      
      var max      = defCheckBox.length;
      for (var i = 0; i < max; i++) {
        if (targetID != defCheckBox[i]["selectorid"]) {
          continue;
        }
        
        var datasetID   = defCheckBox[i]["datasetid"];
        var datasetName = defCheckBox[i]["datasetname"];
        var checkValue;
        if ( $("#" + targetID).is(":checked") ) {
          checkValue = defCheckBox[i]["value"]["on"];
        }
        else {
          checkValue = defCheckBox[i]["value"]["off"];
        }
        
        var datasetRecord = this.appspec.getJSONChunkByIdAtRecords(this.dataset.data, datasetID);
        datasetRecord["record"][datasetName]["value"][0] = checkValue;
        
        break;
      }

      $R.log("ModelMixin onChangeCheckBox : end");
    }
    
    // -------------------------------------------------------
    // テーブル　チェックボックス　チェンジ処理
    // -------------------------------------------------------
   ,onChangeCheckBoxTable: function(event, defCheckBox) {
      $R.log("ModelMixin onChangeCheckBoxTable : start");

      var row         = event.currentTarget.parentNode.parentNode.rowIndex - 1;
      var targetName  = event.currentTarget.name;
      
      var max      = defCheckBox.length;
      for (var i = 0; i < max; i++) {
        if (targetName != defCheckBox[i]["selectorname"]) {
          continue;
        }
        
        var datasetID   = defCheckBox[i]["datasetid"];
        var datasetName = defCheckBox[i]["datasetname"];
        var checkValue;
        var targetObject = $("." + targetName);
        if ( $(targetObject[row]).is(":checked") ) {
          checkValue = defCheckBox[i]["value"]["on"];
        }
        else {
          checkValue = defCheckBox[i]["value"]["off"];
        }
        
        var datasetRecord = this.appspec.getJSONChunkByIdAtRecords(this.dataset.data, datasetID);
        datasetRecord["record"][datasetName]["value"][row] = checkValue;
        
        break;
      }

      $R.log("ModelMixin onChangeCheckBoxTable : end");
    }
    
    // 20170428 下地 追加
   ,onChangeTableCheckBox: function(event, row, defCheckBox) {
      $R.log("ModelMixin onChangeTableCheckBox : start");

      var targetName  = event.currentTarget.name;
      
      var max      = defCheckBox.length;
      for (var i = 0; i < max; i++) {
        if (targetName != defCheckBox[i]["selectorname"]) {
          continue;
        }
        
        var datasetID   = defCheckBox[i]["datasetid"];
        var datasetName = defCheckBox[i]["datasetname"];
        var checkValue;
        var targetObject = $("." + targetName);
        if ( $(targetObject[row]).prop("checked") ) {
          checkValue = defCheckBox[i]["value"]["on"];
        }
        else {
          checkValue = defCheckBox[i]["value"]["off"];
        }
        
        var datasetRecord = this.appspec.getJSONChunkByIdAtRecords(this.dataset.data, datasetID);
        datasetRecord["record"][datasetName]["value"][row] = checkValue;
        
        break;
      }

      $R.log("ModelMixin onChangeTableCheckBox : end");
    }
    
    // -------------------------------------------------------
    // ラジオボタン　チェンジ処理
    // -------------------------------------------------------
   ,onChangeonRadioButton: function(event, defRadioButton) {
      $R.log("ModelMixin onChangeonRadioButton : start");


      $R.log("ModelMixin onChangeonRadioButton : end");
    }
    
    // -------------------------------------------------------
    // ポップアップ画面後処理
    // -------------------------------------------------------
   ,onClickPopupWindowAfter: function(arg, defPopup) {
      $R.log("ModelMixin onClickPopupWindowAfter : start");
      
      var datasetRecord = this.appspec.getJSONChunkByIdAtRecords(this.dataset.data, defPopup["output"]["datasetid"]);
      var inputArray    = defPopup["input"];
      var outputArray   = defPopup["output"]["datasetname"];
      var max           = defPopup["input"].length;
      
      for (var i = 0; i < max; i++) {
        var inputname  = inputArray[i];
        var outputname = outputArray[i];
        
        if (outputname != "") {
          datasetRecord["record"][outputname]["value"][0] = arg[inputname];
        }
      }

      $R.log("ModelMixin onClickPopupWindowAfter : end");
    }

    // -------------------------------------------------------
    // SessionStorageからDatasetへ値を設定する
    // -------------------------------------------------------
   ,fromStorageToDataset: function(defData) {
      $R.log("ModelMixin fromStorageToDataset : start");
      
      var datasetRecord = this.appspec.getJSONChunkByIdAtRecords(this.dataset.data, defData["id"]);
      var max           = defData["dataset"].length;
      
      for (var i = 0; i < max; i++) {
        var datasetName = defData["dataset"][i];
        var storageName = defData["storage"][i];
        
        datasetRecord["record"][datasetName]["value"][0] = sessionStorage.loadItem(storageName);
      }

      $R.log("ModelMixin fromStorageToDataset : end");
    }

    // -------------------------------------------------------
    // DatasetからSessionStorageへ値を設定する
    // -------------------------------------------------------
   ,fromDatasetToStorage: function(defData) {
      $R.log("ModelMixin fromDatasetToStorage : start");
      
      var datasetRecord = this.appspec.getJSONChunkByIdAtRecords(this.dataset.data, defData["id"]);
      var max           = defData["dataset"].length;
      
      for (var i = 0; i < max; i++) {
        var datasetName = defData["dataset"][i];
        var storageName = defData["storage"][i];
        
        sessionStorage.saveItem(storageName, datasetRecord["record"][datasetName]["value"][0]);
      }

      $R.log("ModelMixin fromDatasetToStorage : end");
    }

    // -------------------------------------------------------
    // datasetを指定された値に設定する
    // -------------------------------------------------------
   ,fromValueToDataset: function(defData) {
      $R.log("ModelMixin fromValueToDataset : start");
      
      var datasetRecord = this.appspec.getJSONChunkByIdAtRecords(this.dataset.data, defData["id"]);
      var max           = defData["dataset"].length;
      
      for (var i = 0; i < max; i++) {
        var valData     = defData["value"][i];
        var datasetName = defData["dataset"][i];
        
        var valueMax    = datasetRecord["record"][datasetName]["value"].length;
        for (var j = 0; j < valueMax; j++) {
          datasetRecord["record"][datasetName]["value"][j] = valData;
        }
      }

      $R.log("ModelMixin fromValueToDataset : end");
    }

    // --------------------------------------------------------------
    // セレクトボックス　ＩＤに対応する名称にデータを一括設定する
    // --------------------------------------------------------------
   ,setFromCodeToNameOfSelectBoxALL: function(dataSetInfo, defSelectBox) {
      $R.log("Model setFromIdToNameOfSelectBox : start");
      
      var maxI = defSelectBox.length;
      for (var i = 0; i < maxI; i++) {
        
        var selectID      = defSelectBox[i]["init"]["datasetid"];
        var selectRecord  = this.appspec.getJSONChunkByIdAtRecords(dataSetInfo, selectID);
        var selectValue   = defSelectBox[i]["init"]["valuename"];
        var selectName    = defSelectBox[i]["init"]["htmlname"];

        var detasetID     = defSelectBox[i]["change"]["datasetid"];
        var dataSetRecord = this.appspec.getJSONChunkByIdAtRecords(dataSetInfo, detasetID);
        var dataValue     = defSelectBox[i]["change"]["valuename"];
        var dataName      = defSelectBox[i]["change"]["htmlname"];
        
        var maxJ          = selectRecord["record"][selectValue]["value"].length;
        for (var j = 0; j < maxJ; j++) {
          if (dataSetRecord["record"][dataValue]["value"][0] == selectRecord["record"][selectValue]["value"][j]) {
            dataSetRecord["record"][dataName]["value"][0] = selectRecord["record"][selectName]["value"][j];
            break;
          }
        }
        
      }

      $R.log("Model setFromIdToNameOfSelectBox : end");
    }
    
    // -------------------------------------------------------
    // セレクトボックス　ＩＤに対応する名称にデータを設定する
    // -------------------------------------------------------
   ,setFromCodeToNameOfSelectBox: function(dataSetInfo, defSelectBox, selectorid) {
      $R.log("Model setFromIdToNameOfSelectBox : start");
      
      var maxI = defSelectBox.length;
      for (var i = 0; i < maxI; i++) {
        
        if (selectorid != defSelectBox[i]["selectorid"]) {
          continue;
        }

        var selectID      = defSelectBox[i]["init"]["datasetid"];
        var selectRecord  = this.appspec.getJSONChunkByIdAtRecords(dataSetInfo, selectID);
        var selectValue   = defSelectBox[i]["init"]["valuename"];
        var selectName    = defSelectBox[i]["init"]["htmlname"];

        var detasetID     = defSelectBox[i]["change"]["datasetid"];
        var dataSetRecord = this.appspec.getJSONChunkByIdAtRecords(dataSetInfo, detasetID);
        var dataValue     = defSelectBox[i]["change"]["valuename"];
        var dataName      = defSelectBox[i]["change"]["htmlname"];
        
        var maxJ          = selectRecord["record"][selectValue]["value"].length;
        for (var j = 0; j < maxJ; j++) {
          if (dataSetRecord["record"][dataValue]["value"][0] == selectRecord["record"][selectValue]["value"][j]) {
            dataSetRecord["record"][dataName]["value"][0] = selectRecord["record"][selectName]["value"][j];
            break;
          }
        }
        
      }

      $R.log("Model setFromIdToNameOfSelectBox : end");
    }
    
    // -------------------------------------------------------
    // セレクトボックス　名称に対応するＩＤにデータを設定する
    // -------------------------------------------------------
   ,setFromNameToCodeOfSelectBox: function(dataSetInfo, defSelectBox, selectorid) {
      $R.log("Model setFromNameToCodeOfSelectBox : start");
      
      var maxI = defSelectBox.length;
      for (var i = 0; i < maxI; i++) {
        
        if (selectorid != defSelectBox[i]["selectorid"]) {
          continue;
        }

        var selectID      = defSelectBox[i]["init"]["datasetid"];
        var selectRecord  = this.appspec.getJSONChunkByIdAtRecords(dataSetInfo, selectID);
        var selectValue   = defSelectBox[i]["init"]["valuename"];
        var selectName    = defSelectBox[i]["init"]["htmlname"];

        var detasetID     = defSelectBox[i]["change"]["datasetid"];
        var dataSetRecord = this.appspec.getJSONChunkByIdAtRecords(dataSetInfo, detasetID);
        var dataValue     = defSelectBox[i]["change"]["valuename"];
        var dataName      = defSelectBox[i]["change"]["htmlname"];
        
        var maxJ          = selectRecord["record"][selectName]["value"].length;
        for (var j = 0; j < maxJ; j++) {
          if (dataSetRecord["record"][dataName]["value"][0] == selectRecord["record"][selectName]["value"][j]) {
            dataSetRecord["record"][dataValue]["value"][0] = selectRecord["record"][selectValue]["value"][j];
            break;
          }
        }
        
      }

      $R.log("Model setFromNameToCodeOfSelectBox : end");
    }

  };
  
  // -------------------------------------------------------
  // 画面遷移関数を追加する
  // -------------------------------------------------------
  App.HtmlTransitionMixin = {
    // 画面遷移情報をクリアする
    clearTransitionData: function() {
      sessionStorage.removeItem("画面遷移");
    }
    // カレント画面名を画面遷移情報に格納する
   ,setTransitionData: function(htmlName) {
      var newTransition;
      var htmlTransition = sessionStorage.getItem("画面遷移");
      if (htmlTransition) {
        newTransition = htmlTransition + ":" + htmlName;
      }
      else {
        newTransition = htmlName
      }
      sessionStorage.setItem("画面遷移", newTransition);
    }
    // 前画面名を取得する
   ,getBeforeHtmlName: function() {
      var htmlTransition   = sessionStorage.getItem("画面遷移");
      var arrayTransition  = htmlTransition.split(":");
      var max              = arrayTransition.length - 1;
      var stringTransition = arrayTransition[max];
      arrayTransition      = stringTransition.split("/");
      max                  = arrayTransition.length - 1;

      return arrayTransition[max];
    }
    // 前画面名をセッションストレージから削除する
   ,getTransitionData: function() {
      var htmlTransition  = sessionStorage.getItem("画面遷移");
      var arrayTransition = htmlTransition.split(":");
      var max             = arrayTransition.length - 1;
      var htmlName        = arrayTransition[max];
      var newTransition   = "";
      for (var i = 0; i < max; i++) {
         if (i == 0) {
           newTransition = arrayTransition[i];
         }
         else {
           newTransition = newTransition + ":" + arrayTransition[i];
         }
      }
      sessionStorage.setItem("画面遷移", newTransition);
      return htmlName;
    }
    // 前画面に遷移する
   ,previousTransition: function() {
      var htmlName = this.getTransitionData();
      this.postHtmlTransition(htmlName);
    }
    // 表示中の画面を消し、新しい画面を表示する
   ,postHtmlTransition: function(htmlName) {
      var form     = document.createElement("form");
      form.action  = $R.HtmlRackURL;
      form.method  = 'post';
      this.postTransition(form, htmlName);
    }
    // タブを追加し、新しい画面を表示する
   ,postTabTransition: function(htmlName) {
      window.open("", htmlName);

      var form     = document.createElement("form");
      form.action  = $R.HtmlRackURL;
      form.target  = htmlName;
      form.method  = 'post';
      this.postTransition(form, htmlName);
    }
    // ポップアップ画面を表示する
   ,postPopupTransition: function(htmlName, argWin) {
      window.open("", htmlName, argWin);
       
      var form     = document.createElement("form");
      form.action  = $R.HtmlRackURL;
      form.target  = htmlName;
      form.method  = 'post';
      this.postTransition(form, htmlName);
    }
   ,postTransition: function(form, htmlName) {
      var input = document.createElement('input');
      input.setAttribute("type","hidden");
      input.setAttribute("name","gamen");
      input.setAttribute("value",htmlName);
      form.appendChild(input);

      var body = document.getElementsByTagName("body")[this.appspec.formno];
      body.appendChild(form);
      form.submit();
      body.removeChild(form);
    }
   ,postDownloadRack: function(argHash) {
      var form = document.createElement("form");
      form.action = $R.DownloadRackURL;
      form.method = 'post';

      for (key in argHash) {
        var input = document.createElement('input');
        input.setAttribute("type","hidden");
        input.setAttribute("name",key);
        input.setAttribute("value",argHash[key]);
        form.appendChild(input);
      }
       
      var body = document.getElementsByTagName("body")[0];
      body.appendChild(form);
      form.submit();
      body.removeChild(form);
    }
    
    // 20170427 下地　追加
    // -------------------------------------------------
    // dataset.jsonのvalue値をクリアする
    // -------------------------------------------------
   ,clearDatasetJson: function(dataset) {
      $R.log("ModelMixin clearDatasetJson : start");

      var datasetRecords = dataset["records"];
      var maxSize        = datasetRecords.length;
      
      for (var i = 0; i < maxSize; i++) {
        this.clearDatasetRecord(datasetRecords[i]);
      }
      
      $R.log("ModelMixin clearDatasetJson : end");
    }

   ,clearDatasetRecord: function(datasetRecord) {
      var multiline   = datasetRecord["multiline"];
      var defaultline = 1;
      
      if (multiline == "yes") {
        defaultline = datasetRecord["defaultline"];
      }
      
      for (var name in datasetRecord["record"]) {
        this.clearDatasetValue(datasetRecord["record"][name]["value"], defaultline);
      }
      
      $R.log("ViewMixin clearDataOfItemNameInRecord : end");
    }

   ,clearDatasetValue: function(datasetValue, defaultline) {
   
      for (var i = 0; i < defaultline; i++) {
        datasetValue[i] = "";
      }
      
    }


    // ---------------------------------------------------------------
    // dataset.json request.json response.jsonのvalue値をクリアする
    // ---------------------------------------------------------------
   ,clearJsonRecords: function(jsonData) {
      $R.log("ModelMixin clearJsonRecords : start");
     
      var jsonRecords = jsonData["records"];
      var maxSize     = jsonRecords.length;
      
      for (var i = 0; i < maxSize; i++) {
        this.clearJsonRecord(jsonRecords[i]);
      }
      
      $R.log("ModelMixin clearJsonRecords : end");
    }

   ,clearJsonRecord: function(jsonRecord) {
   
      for (var name in jsonRecord["record"]) {
//      this.clearJsonValue(jsonRecord["record"][name]["value"]);
        jsonRecord["record"][name]["value"] = [""]; // 2017/05/19 UPDATE Okada
      }
      
    }

   ,clearJsonValue: function(jsonvalue) {
     
      jsonvalue = [""];
      
    }

    
    // -------------------------------------------------
    //  datasetからjsondataをセットする
    // (datasetからrequestをセットする)
    // -------------------------------------------------
   ,setDatasetToJsonRecords: function(dataset, request) {
      $R.log("ModelMixin setDatasetToJsonRecords : start");
     
      this.clearJsonRecords(request);

      var datasetRecords = dataset["records"];
      var requestRecords = request["records"];
      var datasetSize    = datasetRecords.length;
      var requestSize    = requestRecords.length;
      
      for (var i = 0; i < requestSize; i++) {
        var requestRecord = requestRecords[i];
        for (var j = 0; j < datasetSize; j++) {
          var datasetRecord = datasetRecords[j];
          if (requestRecord["id"] == datasetRecord["id"]) {
            this.setDatasetRecordToJsonRecord(datasetRecord, requestRecord);
            break;
          }
        }
      }
      
      $R.log("ModelMixin setDatasetToJsonRecords : end");
    }
   
   ,setDatasetRecordToJsonRecord: function(datasetRecord, requestRecord) {
   
      for (var name in requestRecord["record"]) {
        if (name in datasetRecord["record"]) {
          this.setDatasetValueToJsonValue(datasetRecord["record"][name]["value"], requestRecord["record"][name]["value"]);
        }
      }
    }
   
   ,setDatasetValueToJsonValue: function(datasetValue, requestValue) {
      var maxSize = datasetValue.length;
      
      for (var i = 0; i < maxSize; i++) {
        requestValue[i] = datasetValue[i];
      }
      
    }
   
    // -----------------------------------------------------------------
    //  datasetの空行を除いた行をjsondataにコピーする　　削除を含む
    // (datasetの空行を除いた行をrequestにコピーする)
    // -----------------------------------------------------------------
   ,setDatasetToJsonRecordsInDeleteLine: function(dataset, request) {
      $R.log("ModelMixin setDatasetToJsonRecordsInDeleteLine : start");
     
      this.clearJsonRecords(request);

      var datasetRecords = dataset["records"];
      var requestRecords = request["records"];
      var datasetSize    = datasetRecords.length;
      var requestSize    = requestRecords.length;
      
      for (var i = 0; i < requestSize; i++) {
        var requestRecord = requestRecords[i];
        for (var j = 0; j < datasetSize; j++) {
          var datasetRecord = datasetRecords[j];
          if (requestRecord["id"] == datasetRecord["id"]) {
            this.setDatasetRecordToJsonRecordInDeleteLine(datasetRecord, requestRecord);
            break;
          }
        }
      }

      $R.log("ModelMixin setDatasetToJsonRecordsInDeleteLine : end");
    }
   
   ,setDatasetRecordToJsonRecordInDeleteLine: function(datasetRecord, requestRecord) {

      // マルチラインでないとき
      if (datasetRecord["multiline"] != "yes") {
        this.setDatasetRecordToJsonRecord(datasetRecord, requestRecord);
        return;
      }
      
      // マルチライン処理
      var maxSize = 0;
      for (var name in datasetRecord["record"]) {
        if (maxSize < datasetRecord["record"][name]["value"].length) {
          maxSize = datasetRecord["record"][name]["value"].length;
        }
      }
      
      var toNo = 0;
      for (var fromNo = 0; fromNo < maxSize; fromNo++) {
        var emptySW  = 0;
        for (var name in datasetRecord["record"]) {
          if (name == "削除") {
            continue;
          }
          
          if (datasetRecord["record"][name]["value"][fromNo] != "") {
            emptySW = 1;
            break;
          }
        }
        
        // 全項目が空の時
        if (emptySW == 0) {
          continue;
        }
        
        for (var name in requestRecord["record"]) {
          if (name in datasetRecord["record"]) {
            this.setDatasetValueToJsonValueOfNo(datasetRecord["record"][name]["value"], requestRecord["record"][name]["value"], fromNo, toNo);
          }
        }
        toNo = toNo + 1;
      }
    }
   
   ,setDatasetValueToJsonValueOfNo: function(datasetValue, requestValue, fromNo, toNo) {

      requestValue[toNo] = datasetValue[fromNo];

    }
   
   
    // -----------------------------------------------------------------
    //  datasetの空行を除いた行をjsondataにコピーする　　削除は除く
    // (datasetの空行を除いた行をrequestにコピーする)
    // -----------------------------------------------------------------
   ,setDatasetToJsonRecordsNoDeleteLine: function(dataset, request) {
      $R.log("ModelMixin setDatasetToJsonRecordsNoDeleteLine : start");
     
      this.clearJsonRecords(request);

      var datasetRecords = dataset["records"];
      var requestRecords = request["records"];
      var datasetSize    = datasetRecords.length;
      var requestSize    = requestRecords.length;
      
      for (var i = 0; i < requestSize; i++) {
        var requestRecord = requestRecords[i];
        for (var j = 0; j < datasetSize; j++) {
          var datasetRecord = datasetRecords[j];
          if (requestRecord["id"] == datasetRecord["id"]) {
            this.setDatasetRecordToJsonRecordNoDeleteLine(datasetRecord, requestRecord);
            break;
          }
        }
      }

      $R.log("ModelMixin setDatasetToJsonRecordsNoDeleteLine : end");
    }
   
   ,setDatasetRecordToJsonRecordNoDeleteLine: function(datasetRecord, requestRecord) {

      // マルチラインでないとき
      if (datasetRecord["multiline"] != "yes") {
        this.setDatasetRecordToJsonRecord(datasetRecord, requestRecord);
        return;
      }
      
      // マルチライン処理
      var maxSize = 0;
      for (var name in datasetRecord["record"]) {
        if (maxSize < datasetRecord["record"][name]["value"].length) {
          maxSize = datasetRecord["record"][name]["value"].length;
        }
      }
      
      var toNo = 0;
      for (var fromNo = 0; fromNo < maxSize; fromNo++) {
        var emptySW  = 0;
        for (var name in datasetRecord["record"]) {
          if (name == "削除") {
            if (datasetRecord["record"][name]["value"][fromNo] == "1") {
              emptySW = 0;
              break;
            }
            if (datasetRecord["record"][name]["value"][fromNo] == "9") {
              emptySW = 0;
              break;
            }
            continue;
          }
          
          if (datasetRecord["record"][name]["value"][fromNo] != "") {
            emptySW = 1;
            continue;
          }
        }
        
        // 全項目が空の時
        if (emptySW == 0) {
          continue;
        }
        
        for (var name in requestRecord["record"]) {
          if (name in datasetRecord["record"]) {
            this.setDatasetValueToJsonValueOfNo(datasetRecord["record"][name]["value"], requestRecord["record"][name]["value"], fromNo, toNo);
          }
        }
        toNo = toNo + 1;
      }
    }

    // -------------------------------------------------
    //  jsondataからdataset.jsonをセットする
    // (responseからdataset.jsonをセットする)
    // -------------------------------------------------
   ,setJsonRecordsToDataset: function(response, dataset) {
      $R.log("ModelMixin setJsonRecordsToDataset : start");
     
      var responseRecords = response["records"];
      var datasetRecords  = dataset["records"];
      var responseSize    = responseRecords.length;
      var datasetSize     = datasetRecords.length;
      
      for (var i = 0; i < responseSize; i++) {
        var responseRecord = responseRecords[i];
        for (var j = 0; j < datasetSize; j++) {
          var datasetRecord = datasetRecords[j];
          if (responseRecord["id"] == datasetRecord["id"]) {
            this.setJsonRecordToDatasetRecord(responseRecord, datasetRecord);
            break;
          }
        }
      }
      
      $R.log("ModelMixin setJsonRecordsToDataset : end");
    }
   
   ,setJsonRecordToDatasetRecord: function(responseRecord, datasetRecord) {
   
      var multiline   = datasetRecord["multiline"];
      var defaultline = datasetRecord["defaultline"];
      
      for (var name in responseRecord["record"]) {
        if (name in datasetRecord["record"]) {
          this.setJsonValueToDatasetValue(responseRecord["record"][name]["value"], datasetRecord["record"][name]["value"], multiline, defaultline);
        }
      }
      
    }
   
   ,setJsonValueToDatasetValue: function(responseValue, datasetValue, multiline, defaultline) {
     
      if (multiline == "no") {
        datasetValue[0] = responseValue[0];
        return;
      }
     
      var responseSize = responseValue.length;
      for (var i = 0; i < responseSize; i++) {
        datasetValue[i] = responseValue[i];
      }
      
      if (defaultline > responseSize) {
        for (var j = responseSize; j < defaultline; j++) {
          datasetValue[j] = "";
        }
      }
      
    }

  };
}(jQuery, Rmenu));

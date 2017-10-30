<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.TS_EquipmentType;
  var appspec = new app.AppSpec("TS_EquipmentType");
  appspec.initialSetting(app);
});

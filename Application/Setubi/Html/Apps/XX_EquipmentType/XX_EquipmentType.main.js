<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.XX_EquipmentType;
  var appspec = new app.AppSpec("XX_EquipmentType");
  appspec.initialSetting(app);
});

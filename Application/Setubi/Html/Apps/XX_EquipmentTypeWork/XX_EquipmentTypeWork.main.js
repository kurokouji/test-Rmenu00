<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.XX_EquipmentTypeWork;
  var appspec = new app.AppSpec("XX_EquipmentTypeWork");
  appspec.initialSetting(app);
});

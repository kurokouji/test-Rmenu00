<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.R_TraderEquipmentType;
  var appspec = new app.AppSpec("R_TraderEquipmentType");
  appspec.initialSetting(app);
});

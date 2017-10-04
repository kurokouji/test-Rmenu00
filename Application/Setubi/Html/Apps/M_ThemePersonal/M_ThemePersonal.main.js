<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.M_ThemePersonal;
  var appspec = new app.AppSpec("M_ThemePersonal");
  appspec.initialSetting(app);
});

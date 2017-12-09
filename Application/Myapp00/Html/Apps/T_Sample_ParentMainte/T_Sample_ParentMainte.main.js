<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.T_Sample_ParentMainte;
  var appspec = new app.AppSpec("T_Sample_ParentMainte");
  appspec.initialSetting(app);
});

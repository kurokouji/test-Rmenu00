<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.T_Sample_ChildMainte;
  var appspec = new app.AppSpec("T_Sample_ChildMainte");
  appspec.initialSetting(app);
});

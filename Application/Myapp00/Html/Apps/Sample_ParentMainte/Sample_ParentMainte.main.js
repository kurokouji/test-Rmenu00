<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.Sample_ParentMainte;
  var appspec = new app.AppSpec("Sample_ParentMainte");
  appspec.initialSetting(app);
});

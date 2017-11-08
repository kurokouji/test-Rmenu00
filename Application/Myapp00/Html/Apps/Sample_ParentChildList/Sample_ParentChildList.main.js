<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.Sample_ParentChildList;
  var appspec = new app.AppSpec("Sample_ParentChildList");
  appspec.initialSetting(app);
});

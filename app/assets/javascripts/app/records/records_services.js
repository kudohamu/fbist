var appName = "FVistFoundation";
var fvistFoundationApp = angular.module(appName);

fvistFoundationApp.factory("recordFactory", function($resource) {
  return $resource("/api/account/records");
});

fvistFoundationApp.factory("recordSummaryFactory", ["$resource", function($resource) {
  return $resource("/api/account/records/summary");
}]);

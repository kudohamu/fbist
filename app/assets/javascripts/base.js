$(window).load(function() {
  $("#message").animate({
  }, 3000, $("#message").animate({
    height:"0px",
    opacity:"0"
  }, 2000));
});

$(document).ready(function() {
  var record__addShowButtonOn = false;
  $("#record__addShowButton").click(function() {
    if (!record__addShowButtonOn) {
      $("#record__addDiv").animate({
        height:"150px",
        padding:"20px"
      }, 300);
    }else {
      $("#record__addDiv").animate({
        height:"0px",
        padding:"0px 20px"
      }, 300);
    }
    record__addShowButtonOn = !record__addShowButtonOn;
  });
});

$(document).ready(function() {
  var infiniteScroll = $("#org-infinite-scroll");
  var activityTab = $("#activity-tab");

  if(infiniteScroll.size() > 0) {
    $(window).on("scroll", function() {
      var url = $(".pagination .next_page").attr("href");
      var activityDisplayed = activityTab.hasClass("active-tab")

      if(url && activityDisplayed && !infiniteScroll.attr("data-requesting") && $(window).scrollTop() > $(document).height() - $(window).height() - 500) {
        infiniteScroll.css({"display": "block"});
        infiniteScroll.attr("data-requesting", true);
        $.getScript(url);
      }
    });
  }
});

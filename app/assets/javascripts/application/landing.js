$(document).on('ready', function() {

  var $view_more = $('.view-more');
  var $container = $('.list-post-expander');
  var three_high = 0;
  var all_high = 0;
  var viewing_more = false;

  for (var i=0; i<3; i++){
    three_high += $('.list-post-expander > .list-post:eq('+i+')').height()+32;
  }

  for (var i=0; i<$('.list-post-expander > .list-post').length; i++){
    all_high += $('.list-post-expander > .list-post:eq('+i+')').height()+32;
  }  

  console.log(all_high);
  $container.height(three_high);

  if ($(window).width() >= 600){
    //$('#membership').height($('#posts').height());
  }

  $view_more.click(function(){
    if (viewing_more){
      $container.height(three_high);
      $view_more.html("View More Posts");
      viewing_more = false;
    } else {
      $container.height(all_high);
      $view_more.html("View Fewer Posts");
      viewing_more = true;
    }
  });

});
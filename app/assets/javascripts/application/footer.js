$(document).on('ready', function() {

  var $footer = $('.footer');
  var $main = $('#main');
  var $container = $('.container');
  var footerOffset = $footer.offset().top;
  var winHeight = $( window ).height()-64-64-64;

  if (footerOffset < winHeight){
    $footer.css({
      'position':'fixed',
      'bottom':'0'
    });
  }

  $( window ).resize(function() {
    if (footerOffset < winHeight){
      $footer.css({
        'position':'fixed',
        'bottom':'0'
      });
    }
  });

  //$('.coach_action_plans').find('#main').height(707);


});
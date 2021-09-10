$(document).on('ready', function() {

  var $html = $('html');
  var $marketplaceHeader = $('.marketplace-header');
  var $boxlinkContainer = $('.boxlink-container');
  var $boxlink = $('.boxlink');
  var $boxlinkFlipper = $('.boxlink-flipper');
  var $boxlinkFront = $('.boxlink-front');
  var $boxlinkBack = $('.boxlink-back');
  var boxlinkClasses = '.boxlink, .boxlink-flipper .boxlink-front, .boxlink-back, .boxlink-icon, .boxlink-text';
  var animationSpeed = 1000;

  /*
  var resize_cards = function(){
    $boxlink.css('height', $boxlink.css('width'));
    $boxlinkContainer.css('min-height', String($(window).height())+'px' );

    $( window ).resize(function() {
      $boxlink.css('height', $boxlink.css('width'));
      $boxlinkContainer.css('min-height', String($(window).height())+'px' );
    });
  };
  */

/*
  $boxlink.click(function(){
    var $thisFront = $(this).find('.boxlink-front');
    if ( $thisFront.css('display','block') ){
      reset_cards();
      $thisFront.animate({
        'opacity':'0',
      }, 100, function(){
        $thisFront.css('display','none');
      });
    }
  });
*/

  $marketplaceHeader.click(function(){
    $boxlinkFront.css({
      'opacity':'1',
      'visibility':'visible'
    });
  });

  $boxlinkFront.click(function(){
    $boxlinkFront.not($(this)).css({
      'opacity':'1',
      'visibility':'visible'
    });
    $(this).css({
      'opacity':'0',
      'visibility':'hidden'
    });    
  });

  $boxlinkBack.click(function(){
    $boxlinkFront.css({
      'opacity':'1',
      'visibility':'visible'
    });
  });



  //resize_cards();

});

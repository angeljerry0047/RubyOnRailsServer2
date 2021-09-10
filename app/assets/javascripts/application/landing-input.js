$(document).on('ready', function() {

  var $input_container = $('.input-container');
  var $input = $('.input');

  $('.landing').find($input).focus(function(){
    $(this).parent().css({
      'box-shadow':'0 4px 8px rgba(0,0,0,0.25)',
      'top':'-2px'
    });
  });

  $('.landing').find($input).blur(function(){
    $(this).parent().css({
      'box-shadow':'0 2px 4px rgba(0,0,0,0.25)',
      'top':'0px'
    });
  });

});
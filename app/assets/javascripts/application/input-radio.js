$(document).ready(function(){


  // Variables ==========================================

  var $input_radio = $('.input-radio');
  var $input = $('input');
  var $circle = $('.circle');
  var $dot = $('.dot');
  var $label = $('.label');


  // When you click a radio, tell the actual input:radio and show the dot/change color ==========================================

  $input_radio.click(function(){
    var this_name = $(this).find($input).attr("name");    
    var $rails_input = $(this).siblings($input);    
    $('.input-radio-container[name="'+this_name+'"]').find($circle).removeClass('validation-error');

    $('input[name="'+this_name+'"]').prop("checked", false);
    $(this).find($input).prop("checked", true);
    $('.input-radio-container[name="'+this_name+'"]').find($circle).removeClass('circle-active');
    $(this).find($circle).addClass('circle-active');
    $('.input-radio-container[name="'+this_name+'"]').find($dot).removeClass('dot-active');
    $(this).find($dot).addClass('dot-active');
    $('.input-radio-container[name="'+this_name+'"]').find($label).removeClass('label-active');
    $(this).find($label).addClass('label-active');

    $rails_input.val($(this).find($input).val());
  });

});
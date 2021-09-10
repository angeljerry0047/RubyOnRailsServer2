$(document).ready(function(){


  // Variables ==========================================

  var $input_container = $('.input-text-field-container'); 
  var $input = $('.input-text-field-container').find($('.input-text-field')); 

  // Setup ==========================================
  
  $input.autosize();

  // When input is blured & there's nothing in the input, remove validation-error ==========================================

  $input.blur(function(){
    $(this).removeClass('validation-error');
  });

});
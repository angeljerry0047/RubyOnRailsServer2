$(document).ready(function(){

  jQuery.fn.justtext = function() {

    return $(this).clone()
            .children()
            .remove()
            .end()
            .text();
  };


  // Variables ==========================================

  var $navbar = $(".navbar");
  var $input = $('.input-dropdown, .arrow'); 
  var $blanket = $('.dropdown-blanket');
  var $shadow = $('.shadow');
  var $notInput = $('form:not(".dropdown-option, .dropdown-option-container, .input-dropdown, .input-dropdown-container, form")');
  var $dropdown = $('.dropdown-option-container');
  var $option = $('.dropdown-option');
  var $arrow = $('.arrow');


  // When you type in input, show label ==========================================

  $input.click(function(){
    var $this_dropdown = $(this).siblings('.dropdown-option-container');
    $this_dropdown.animate({
      'height':'340%',
      'top':'0'
    }, 200);
    $(this).removeClass('validation-error');
    $blanket.css('display','block');
  });

  $option.click(function(){
    var option_category = $(this).attr("data-category");
    var option_category_id = $(this).attr("data-category-id");
    var option_text = $(this).justtext();
    var $this_dropdown = $(this).parent();
    var $this_input = $this_dropdown.siblings('.input-dropdown');
    var $category_input = $this_dropdown.siblings('input[name="category"]');
    var $category_id_input = $this_dropdown.siblings('input[name="category-id"]');
    $category_input.attr("value", option_category);
    $category_id_input.attr("value", option_category_id);
    $this_input.empty();
    $this_input.append(option_text);
    $this_dropdown.animate({
      'height':'0%',
      'top':'16px'
    }, 200);
    $blanket.css('display','none');
  });

  // close the dropdown when you click away
  $blanket.click(function(){
    var $this_input = $(this);
    var $this_dropdown = $(this).siblings('.dropdown-option-container');
    $dropdown.delay(100).animate({
      'height':'0%',
      'top':'16px'
    }, 200);
    $blanket.css('display','none');

    $shadow.click(function(){
      $dropdown.delay(100).animate({
        'height':'0%',
        'top':'16px'
      }, 200);
      $blanket.css('display','none');
    });

    // check to see if the text field value matches one of the options
    var input_value_is_valid = false;
    $this_dropdown.find($option).each(function(){
      if ( $this_input == $(this).attr("data-category") ){
        input_value_is_valid = true;
      }
    });

    // if the text field value is not one of the options, clear the field
    //if (input_value_is_valid == false){
      //$this_input.val("");
    //}
  });


});
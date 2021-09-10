$(document).ready(function(){

  $user_list = $('.user-list');

  $user_list.click(function(){
    $checkbox = $(this).find('input[type="checkbox"]');
    $checkmark = $(this).find('.checkmark');
    if ($checkbox.prop('checked')){
      $checkbox.prop('checked', false);
      $checkmark.removeClass('checkmark-active');
    } else {
      $checkbox.prop('checked', true);
      $checkmark.addClass('checkmark-active');
    }
  });

});
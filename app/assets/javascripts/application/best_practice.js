
$(document).ready(function(){

  $("#new_best_practice").validate({
    rules: {
      "best_practice_best_practice_category_id": "required",
      "best_practice_title": "required",
      "best_practice_body": "required",
      "best_practice_idea_help": "required",
    },
    errorPlacement: function(error, element){
      $(element).closest('.control-group').toggleClass('error');
      console.log("INVALID: ");
      console.log(element);
    },
    submitHandler: function(form) {
      form.submit();
    }
  });

  $('.likes').mouseenter(function(){
    $('.likers').addClass('likers-active');
  });

  $('.likes').mouseleave(function(){
    $('.likers').removeClass('likers-active');
  });

  $('.likes').click(function(){
    $('.likers').addClass('likers-active');
  });

  $('.like').click(function(){
    $(this).hide();
    $('.liked').css('display','inline');
  });

  $('.advanced-options-button').click(function(){
    $('.advanced-options').slideToggle();
  });

});

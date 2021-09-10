$(document).ready(function() {

  var $testimonial = $('.testimonial-float');
  var $quote = $('.quote');
  var $moreButton = $('.more-button');
  
  $testimonial.click(function(){
    var $thisQuote = $(this).find('.quote');
    var $thisMoreButton = $(this).find('.more-button');
    if ($thisQuote.css('display') == 'none'){
      $quote.slideUp();
      $thisQuote.slideDown();
      $moreButton.text("Click to Read More");
      $thisMoreButton.text("Click to Close");
    } else {
    $thisQuote.slideUp();
      $thisMoreButton.text("Click to Read More");
  }
  //$moreButton.slideToggle();
  });

});
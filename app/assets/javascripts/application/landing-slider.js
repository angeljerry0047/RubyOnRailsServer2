$(document).on('ready', function() {

var $landing_b_left = $('#landing-b-left');
var $landing_b_right = $('#landing-b-right');
var $landing_b_1 = $('#landing-b-1');
var $landing_b_2 = $('#landing-b-2');
var $landing_b_3 = $('#landing-b-3');
var $landing_b_4 = $('#landing-b-4');
var $landing_b_5 = $('#landing-b-5');
var $landingSTC = $('.landing-slider-tile-container');
var $landingSliderButton = $('.landing-slider-button');
var $landingSliderCircle = $('.landing-slider-circle')
var $sliderDot = $('.landing-slider-dot');
var $landingSliderArrow = $('.landing-slider-arrow');
var $a_left = $('.a-left');
var $a_right = $('.a-right');
var stateArray = ['0%', '-100%', '-200%', '-300%', '-400%'];
var currentState = 0;

var sliderDots = function(){
  $landing_b_1.click(function(){
    currentState = 0;
    $landingSTC.css('left', stateArray[currentState] );
    dotAnimate();
  });

  $landing_b_2.click(function(){
     currentState = 1;
    $landingSTC.css('left', stateArray[currentState] );
    dotAnimate();
  });

  $landing_b_3.click(function(){
     currentState = 2;
    $landingSTC.css('left', stateArray[currentState] );
    dotAnimate();
  });

  $landing_b_4.click(function(){
     currentState = 3;
    $landingSTC.css('left', stateArray[currentState] );
    dotAnimate();
  });

  $landing_b_5.click(function(){
     currentState = 4;
    $landingSTC.css('left', stateArray[currentState] );
    dotAnimate();
  });
}

var sliderArrows = function(){
  $landing_b_left.click(function(){
    if (currentState > 0){
      currentState -= 1;
    } else {
      currentState = stateArray.length-1;
    }
    $landingSTC.css('left', stateArray[currentState] );
    dotAnimate();
  });

  $landing_b_right.click(function(){
    if (currentState < stateArray.length-1){
      currentState += 1;
    } else {
      currentState = 0;
    }
    $landingSTC.css('left', stateArray[currentState] );
    dotAnimate();
  });
}

var sliderTimer = function(){
  if (currentState < stateArray.length-1){
    currentState += 1;
  } else {
    currentState = 0;
  }
  $landingSTC.css('left', stateArray[currentState] );
  dotAnimate();
}

var dotAnimate = function(){
  $sliderDot.css({'height':'0px', 'width':'0px'});
  var $thisSliderDot= $('#landing-b-'+(currentState+1)).find('.landing-slider-dot');
  $thisSliderDot.css({'height':'8px', 'width':'8px'});
}

var controlerHover = function(){
  $landingSliderButton.mouseenter(function(){
    $(this).find($landingSliderCircle).css('border','#BCBCBC 4px solid');
    $(this).find($landingSliderArrow).css({
      'border-bottom': '10px solid transparent', 
      'border-top': '10px solid transparent'
    });
    $(this).find($a_left).css('border-right','#BCBCBC 14px solid');
    $(this).find($a_right).css('border-left','#BCBCBC 14px solid');
  });
  $landingSliderButton.mouseleave(function(){
    $(this).find($landingSliderCircle).css('border','#BCBCBC 2px solid');
    $(this).find($landingSliderArrow).css({
      'border-bottom': '8px solid transparent', 
      'border-top': '8px solid transparent'
    });
    $(this).find($a_left).css('border-right','#BCBCBC 12px solid');
    $(this).find($a_right).css('border-left','#BCBCBC 12px solid');
  });
}

sliderDots();
sliderArrows();
window.setInterval(sliderTimer, 10000);
dotAnimate();
controlerHover();

});

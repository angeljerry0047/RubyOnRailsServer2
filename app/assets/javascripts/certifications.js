$(document).on('ready', function() {

  var $certificationsContainer = $('.certifications-container');
  var $certification = $('.certification-container');

  function setup(){
    $certificationsContainer.each(function(index){
      var this_width = $(this).width();
      console.log(this_width);
      var certification_count = $(this).children().size()-1;
      console.log(certification_count);
      var certification_width = this_width/certification_count;
      console.log(certification_width);
      $(this).children('.certification-container').width(certification_width);
    });
  };

  setup();
  $( window ).on( "orientationchange", function() {
    setup();
  });

});
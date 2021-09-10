$(document).ready(function(){


  // Variables ==========================================

  var $board_tabs = $('.board.tabs');
  var $tabs_header = $('.tabs-header');
  var $tab_container = $('.tab-container');
  var $tab = $('.tab');
  var $tab_indicator = $('.tab-indicator');
  var $active_tab = $('.active-tab');

  var tab_sets = [];
  var speed = 100;

  // Functions ==========================================

  function setup(){
    for (var i=0; i<$board_tabs.length; i++){
      var $this = $board_tabs.eq(i);
      var this_id = $this.attr('id');
      var this_number_of_tabs = $this.find($tab).size();

      if ($this.find($tabs_header).width() >= 600){
        $this.find($tab_container).css('width','600px');
      } else {
        $this.find($tab_container).css('width','100%');
      }
      var this_tab_container_width = $this.find($tab_container).width();
      $('.tab-panel').width($('.board.tabs').width());

      this_tab_width = this_tab_container_width/this_number_of_tabs;
      $this.find($tab).width(this_tab_width);

      var $this_tab_indicator = $this.find($tab_indicator);
      $this_tab_indicator.css('left', "0" );
      $this_tab_indicator.css('right', (this_tab_width*(this_number_of_tabs-1))+"px");

      var this_active_tab_index = $this.find('.active-tab').attr('data-index');

      var this_set = {
        id: this_id,
        number_of_tabs: this_number_of_tabs,
        tab_container_width: this_tab_container_width,
        tab_width: this_tab_width,
        active_tab_index: this_active_tab_index
      };

      tab_sets.push(this_set);

    }
  };


  // Setup ==========================================

  setup();
  $( window ).on( "orientationchange", function() {
    setup();
  });
  
  // When tab is clicked ==========================================

  $tab.click(function(){
    var $this = $(this);
    var this_index = $this.data('index');

    var $this_tab_indicator = $this.siblings('.tab-indicator');

    var $this_board_tabs = $this.parents('.board.tabs')
    var this_set_id = $this_board_tabs.attr('id');
    var this_set = $.grep(tab_sets, function(e){
      return e.id == this_set_id;
    })[0];

    //move indicator
    if (this_index > this_set.active_tab_index){ // determine which direction the indicator is moving
      var moving_right = true;
    } else {
      var moving_right = false;
    }
    if (this_index != this_set.active_tab_index){ // only move if not clicking current tab
      if (moving_right){
        $this_tab_indicator.animate({ "right": (this_set.tab_width*((this_set.number_of_tabs-1)-this_index))+"px" }, speed, function(){
          $this_tab_indicator.animate({ "left": (this_set.tab_width*this_index)+"px"}, speed);
        });
      } else {
        $this_tab_indicator.animate({ "left": (this_set.tab_width*this_index)+"px"}, speed, function(){
          $this_tab_indicator.animate({ "right": (this_set.tab_width*((this_set.number_of_tabs-1)-this_index))+"px" }, speed);
        });
      }
    }

    // update active tab
    $this.siblings('.tab').removeClass('active-tab');
    $this.addClass('active-tab');

    // change tab panels
    if ( this_index != this_set.active_tab_index ){
      $this_board_tabs.find($('.tab-panel[data-index="'+this_set.active_tab_index+'"]')).slideUp(function(){
        this_set.active_tab_index = $this.data('index');
        $this_board_tabs.find($('.tab-panel[data-index="'+this_set.active_tab_index+'"]')).slideDown();
      });
    }
  });

});
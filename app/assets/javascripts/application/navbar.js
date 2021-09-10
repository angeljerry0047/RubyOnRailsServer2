$(document).ready(function(){

// Variables =================================================

  var $navbar = $(".navbar");
  var $header = $(".header");
  var $footer = $(".footer");
  var $hamburger = $(".hamburger-button");
  var $menu = $(".menu");
  var $menuSection = $(".menu-section");
  var $menuSubitem = $(".menu-subitem");
  var $menuSubContainer = $(".menu-subitem-container");
  var $menuThirdContainer = $(".menu-third-item-container");
  var $menuDescription = $(".menu-description");
  var $html = $("html");
  var $main = $("#main");
  var $postButton = $(".post-button");
  var $post = $(".post");
  var $sortButton = $(".sort-button");
  var $sort = $(".sort");
  var $filterButton = $(".filter-button");
  var $filterButtonDesktop = $(".filter-button-desktop");
  var $filterButtonMobile = $(".filter-button-mobile");
  var $filter = $(".filter-group-list");
  var $filterItem = $(".filter-group-item");
  var $shadow = $(".shadow");
  var $tab = $(".short");
  var $change = $(".nav-change-button");
  var $changeList = $(".dallas-group-list");
  var $leaveButton = $(".leave-button");
  var $leavePopup = $(".leave-group-popup");
  var $removeButton = $(".remove-button");
  var $removePopup = $(".remove-member-popup");
  var menuHidden = true;
  var postHidden = true;
  var sortHidden = true;
  var filterHidden = true;
  var changeHidden = true;
  var leavePopupHidden = true;
  var removePopupHidden = true;
  var scrollTarget = $navbar;
  var currentIndex = 0;
  var currentAlpha = "a";


// Setup =================================================


  // give menu extra space on side if in mobile
  if ($(window).width() <= 600){
    $menu.width($menu.width()-56);
  }

  // if $main is too short, make it long enough for the menu. If the menu is too short, make it extend to the footer.
  if ( $main.height()-152 < $menu.height() ){
    $main.css("min-height", $menu.height()-152+"px");
    //$main.height( $menu.height()-152 );
  }
  //$shadow.height( $menu.height());

  if ( $(window).height()-$navbar.height() < $menu.height()){
    $menu.height( $(window).height()-$navbar.height() );
  }

  $tab.click(function(){
    $main.css("height","auto");
  });

  if ($('body').hasClass('organizations')){
    $main.css("height","auto");
  };

  // shorten height of menu to be 100% -hieght of navbar/header
  /*
  if ($(window).width() >= 960){
    $menu.height( $main.height()+$footer.height() );
    $shadow.height( $menu.height() );
  } else if (($(window).width() < 960) && ($(window).width() > 600)){
    $menu.height( $main.height()+$footer.height() );
    $shadow.height( $main.height()+$footer.height() );
  } else {
    $menu.height( $main.height()+$footer.height() );
    $shadow.height( $main.height()+$footer.height() );
  }
  if ($(window).width() < 959){
    $menu.height( $(window).height()-$navbar.height() );
  } else {
    $menu.height( $(window).height()-$navbar.height() );
  }
  */

  $menuSubContainer.slideUp();
  $menuThirdContainer.slideUp();


// Functions =================================================

  function openMenu(){
    $menu.addClass('menu-open');
    $hamburger.addClass('nav-button-active');
    menuHidden = false;
  };

  function closeMenu(){
    $menu.removeClass('menu-open');
    $hamburger.removeClass('nav-button-active');
    menuHidden = true;
  };

  function openPost(){
    $post.addClass('post-open');
    $postButton.addClass('nav-button-active');
    postHidden = false;
  };

  function closePost(){
    $post.removeClass('post-open');
    $postButton.removeClass('nav-button-active');
    postHidden = true;
  };

  function openSort(){
    $sort.addClass('sort-open');
    $sortButton.addClass('nav-button-active');
    sortHidden = false;
  };

  function closeSort(){
    $sort.removeClass('sort-open');
    $sortButton.removeClass('nav-button-active');
    sortHidden = true;
  };

  function openFilter(){
    $filter.addClass('filter-open');
    $filterButtonDesktop.addClass('nav-button-active');
    $filterButtonMobile.addClass('filter-button-mobile-active');
    filterHidden = false;
  };

  function closeFilter(){
    $filter.removeClass('filter-open');
    $filterButtonDesktop.removeClass('nav-button-active');
    $filterButtonMobile.removeClass('filter-button-mobile-active');
    filterHidden = true;
  };

  function openChange(){
    scrollTarget = $navbar;
    $changeList.addClass('change-open');
    $change.addClass('nav-button-active');
    changeHidden = false;
  };

  function closeChange(){
    scrollTarget = $navbar;
    $changeList.removeClass('change-open');
    $change.removeClass('nav-button-active');
    changeHidden = true;
  };

  function openLeavePopup(){
    scrollTarget = $navbar;
    $leavePopup.addClass('popup-open');
    popupHidden = false;
  };

  function closeLeavePopup(){
    scrollTarget = $navbar;
    $leavePopup.removeClass('popup-open');
    popupHidden = true;
  };

  function openRemovePopup($thisPopup){
    scrollTarget = $navbar;
    $thisPopup.addClass('popup-open');
    popupHidden = false;
  };

  function closeRemovePopup(){
    scrollTarget = $navbar;
    $removePopup.removeClass('popup-open');
    popupHidden = true;
  };

  function hideMenuDescriptions(){
    $menuDescription.css("top","-1000px");
  }

  function shadow(){
    if (menuHidden && postHidden && sortHidden && changeHidden && filterHidden && popupHidden){
      $shadow.removeClass('shadow-active');
      $html.css('overflow','auto');
    } else {
      $shadow.addClass('shadow-active');
      $('html, body').animate({
        scrollTop: scrollTarget.offset().top
      }, 500);
      $html.css('overflow','hidden');
    }
  }


// Open the menu =================================================

  $hamburger.click(function(){
    if (menuHidden){
        openMenu();
        closePost();
        closeSort();
        closeChange();
    } else {
        closeMenu();
    }
    shadow();
  });


// Open the post =================================================

  $postButton.click(function(){
    if (postHidden){
        openPost();
        closeMenu();
        closeSort();
        closeChange();
    } else {
        closePost();
    }
    shadow();
  });


// Open the sort =================================================

  $sortButton.click(function(){
    if (sortHidden){
        openSort();
        closeMenu();
        closePost();
        closeChange();
    } else {
        closeSort();
    }
    shadow();
  });


  // Open the filter =================================================

  $filterButton.click(function(){
    if (filterHidden){
        openFilter();
        closeMenu();
        closePost();
        closeChange();
    } else {
        closeFilter();
    }
    shadow();
  });



  /*
  $filterItem.click(function(){
    closeFilter();
    shadow();
    $thisTitle = $(this).text().replace(/ /g,'');
    console.log($thisTitle);
    for (var i=0; i < $(".list-post").length; i++){
      $thisItem = $(".list-post:eq("+i+")");
      console.log($thisItem.find(".org-title").text().replace(/ /g,''));
      console.log($thisItem.find(".org-title").text().replace(/ /g,'') == $thisTitle);
      if ($thisItem.find(".org-title").text().replace(/ /g,'') == $thisTitle){
        $thisItem.css("display","block");
      } else {
        $thisItem.css("display","none");
      }
    }
    if ($(this).hasClass("show-all") ){
      $(".list-post").css("display","block");
    }
  });
  */


// Open the change =================================================

  $change.click(function(){
    if (changeHidden){
        openChange();
        closeMenu();
    } else {
        closeChange();
    }
    shadow();
  });


// Open the leave popup =================================================

  $leaveButton.click(function(){
    if (leavePopupHidden){
        openLeavePopup();
        closeMenu();
    } else {
        closeLeavePopup();
    }
    shadow();
  });



// Open the remove popup =================================================

  $removeButton.click(function(){
    if (removePopupHidden){
        target = $(this).siblings(".remove-member-popup");
        openRemovePopup(target);
        closeMenu();
    } else {
        closeRemovePopup();
    }
    shadow();
  });



// Close the menu =================================================

  $shadow.click(function(){
    closeMenu();
    closePost();
    closeSort();
    closeFilter();
    closeChange();
    closeLeavePopup();
    closeRemovePopup();
    hideMenuDescriptions();
    shadow();
  });

  
// Open subitem-container =================================================

  $menuSection.click(function(){
    if ($(this).attr("data-alpha") != currentAlpha && !$(this).hasClass('no-submenu')){
      $menuSubContainer.slideUp();
      $menuThirdContainer.slideUp();
    } 
    currentAlpha = $(this).attr("data-alpha");
    console.log(currentAlpha);
    $(".menu-subitem-container[data-alpha="+currentAlpha+"]").slideToggle();
  });  


// Open third-item-container =================================================

  $menuSubitem.click(function(){
    if ($(this).attr("data-index") != currentIndex){
      $menuThirdContainer.slideUp();
    } 
    currentIndex = $(this).attr("data-index");
    console.log(currentIndex);
    $(".menu-third-item-container[data-index="+currentIndex+"]").slideToggle();
  });  
  

});
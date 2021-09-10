$(document).ready(function(){

  // Category sliders ===========================================

  $category_link = $('.category-link');
  $category_subcontainer = $('.category-subcontainer');

  $category_subcontainer.not(":first").slideUp();

  $category_link.click(function(){
    $this_cat_sub = $(this).siblings('.category-subcontainer');

    $category_link.not($(this)).text('Show Graph');
    $category_subcontainer.not($this_cat_sub).slideUp();

    if ($(this).text() == 'Show Graph'){ 
      $(this).text('Hide Graph');
    } else {
      $(this).text('Show Graph');
    }
    $this_cat_sub.slideToggle();
  });


  // Period Selectors ============================================

  var param = window.location.search.substring(8);
  if (param == "seven+days"){
    $(".period-button:contains('seven days')").addClass('active');
  } else if (param == "thirty+days"){
    $(".period-button:contains('thirty days')").addClass('active');
  } else if (param == "three+months"){
    $(".period-button:contains('three months')").addClass('active');
  } else if (param == "six+months"){
    $(".period-button:contains('six months')").addClass('active');
  } else if (param == "one+year"){
    $(".period-button:contains('one year')").addClass('active');
  } else {
    $(".period-button:contains('thirty days')").addClass('active');
  }


  // Charts ======================================================

  var monthNames = ["January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  // Mentorships ======================================================

  var mentorshipsThisPeriodEl = document.getElementById("mentorshipsThisPeriod");
  var mentorshipsLastPeriodEl = document.getElementById("mentorshipsLastPeriod");

  if(mentorshipsThisPeriodEl && mentorshipsLastPeriodEl) {

    var mentorshipsThisPeriod = JSON.parse(mentorshipsThisPeriodEl.innerHTML);
    var mentorshipsLastPeriod = JSON.parse(mentorshipsLastPeriodEl.innerHTML);
    var mentorshipData = mentorshipsThisPeriod;

    var mentorshipCount = 0;
    for (var i=0; i<mentorshipsThisPeriod.length; i++){
      if (Number.isInteger(mentorshipsThisPeriod[i]["value"])){ 
        mentorshipCount = mentorshipCount + mentorshipsThisPeriod[i]["value"];
      }
    }
    $('.category-number.mentorships').append(mentorshipCount);

    for (var i=0; i<mentorshipsThisPeriod.length; i++){
      mentorshipData[i].oldValue = mentorshipsLastPeriod[i].value;
    };

    new Morris.Area({
      element: 'mentorshipChart',
      data: mentorshipData,
      xkey: 'date',
      ykeys: ['oldValue','value'],
      labels: ['Old Posts', 'New Posts'],
      smooth: true,
      behaveLikeLine: true,
      hideHover: true,
      xLabels: "month",
      gridTextFamily: 'Roboto',
      lineColors: ['#9e9e9e','#009933'],
      xLabelFormat: function (date) { return monthNames[date.getMonth()]; },
      hoverCallback: function (index, options, content, row) {
        return new Date(mentorshipData[index].date).toDateString() +": "+ mentorshipData[index].value +" Posts<br>Last Period: "+ mentorshipData[index].oldValue +" Posts";
      }
    });

    var mentorshipConnections = JSON.parse(document.getElementById("mentorshipConnections").innerHTML);
    
    var mentorshipConnectionCount = 0;
    for (var i=0; i<mentorshipConnections.length; i++){
      mentorshipConnectionCount = mentorshipConnectionCount + mentorshipConnections[i].value;
    }

    new Morris.Donut({
      element: 'mentorshipConnectionsChart',
      data: [
        {label: "Connections", value: mentorshipConnectionCount},
        {label: "Opportunities", value: (mentorshipCount-mentorshipConnectionCount)}
      ],
      colors: ['#009933','#9e9e9e']
    });
  }

  // Job Shadowing ======================================================

  var jobshadowingThisPeriodEl = document.getElementById("jobshadowingThisPeriod");
  var jobshadowingLastPeriodEl = document.getElementById("jobshadowingLastPeriod");

  if(jobshadowingThisPeriodEl && jobshadowingLastPeriodEl) {

    var jobshadowingThisPeriod = JSON.parse(jobshadowingThisPeriodEl.innerHTML);
    var jobshadowingLastPeriod = JSON.parse(jobshadowingLastPeriodEl.innerHTML);
    var jobshadowingData = jobshadowingThisPeriod;

    var jobshadowingCount = 0;
    for (var i=0; i<jobshadowingThisPeriod.length; i++){
      if (Number.isInteger(jobshadowingThisPeriod[i]["value"])){ 
        jobshadowingCount = jobshadowingCount + jobshadowingThisPeriod[i]["value"];
      }
    }
    $('.category-number.jobshadowings').append(jobshadowingCount);

    for (var i=0; i<jobshadowingLastPeriod.length; i++){
      jobshadowingData[i].oldValue = jobshadowingLastPeriod[i].value;
    };
    new Morris.Area({
      element: 'jobshadowingChart',
      data: jobshadowingData,
      xkey: 'date',
      ykeys: ['oldValue','value'],
      labels: ['Old Posts', 'New Posts'],
      smooth: true,
      behaveLikeLine: true,
      hideHover: true,
      xLabels: "month",
      gridTextFamily: 'Roboto',
      lineColors: ['#9e9e9e','#009933'],
      xLabelFormat: function (date) { return monthNames[date.getMonth()]; },
      hoverCallback: function (index, options, content, row) {
        return new Date(jobshadowingData[index].date).toDateString() +": "+ jobshadowingData[index].value +" Posts<br>Last Period: "+ jobshadowingData[index].oldValue +" Posts";
      }
    });

    var jobshadowingConnections = JSON.parse(document.getElementById("jobshadowingConnections").innerHTML);
    
    var jobshadowingConnectionCount = 0;
    for (var i=0; i<jobshadowingConnections.length; i++){
      jobshadowingConnectionCount = jobshadowingConnectionCount + jobshadowingConnections[i].value;
    }

    new Morris.Donut({
      element: 'jobshadowingConnectionsChart',
      data: [
        {label: "Connections", value: jobshadowingConnectionCount},
        {label: "Opportunities", value: (jobshadowingCount-jobshadowingConnectionCount)}
      ],
      colors: ['#009933','#9e9e9e']
    });
  }

  // Volunteers ======================================================

  var volunteersThisPeriodEl = document.getElementById("volunteersThisPeriod");
  var volunteersLastPeriodEl = document.getElementById("volunteersLastPeriod");

  if(volunteersThisPeriodEl && volunteersLastPeriodEl) {

    var volunteersThisPeriod = JSON.parse(volunteersThisPeriodEl.innerHTML);
    var volunteersLastPeriod = JSON.parse(volunteersLastPeriodEl.innerHTML);
    var volunteersData = volunteersThisPeriod;

    var volunteersCount = 0;
    for (var i=0; i<volunteersThisPeriod.length; i++){
      if (Number.isInteger(volunteersThisPeriod[i]["value"])){ 
        volunteersCount = volunteersCount + volunteersThisPeriod[i]["value"];
      }
    }
    $('.category-number.volunteers').append(volunteersCount);

    for (var i=0; i<volunteersLastPeriod.length; i++){
      volunteersData[i].oldValue = volunteersLastPeriod[i].value;
    };
    new Morris.Area({
      element: 'volunteersChart',
      data: volunteersData,
      xkey: 'date',
      ykeys: ['oldValue','value'],
      labels: ['Old Posts', 'New Posts'],
      smooth: true,
      behaveLikeLine: true,
      hideHover: true,
      xLabels: "month",
      gridTextFamily: 'Roboto',
      lineColors: ['#9e9e9e','#009933'],
      xLabelFormat: function (date) { return monthNames[date.getMonth()]; },
      hoverCallback: function (index, options, content, row) {
        return new Date(volunteersData[index].date).toDateString() +": "+ volunteersData[index].value +" Posts<br>Last Period: "+ volunteersData[index].oldValue +" Posts";
      }
    });

    var volunteerConnections = JSON.parse(document.getElementById("volunteerConnections").innerHTML);
    
    var volunteerConnectionsCount = 0;
    for (var i=0; i<volunteerConnections.length; i++){
      volunteerConnectionsCount = volunteerConnectionsCount + volunteerConnections[i].value;
    }

    new Morris.Donut({
      element: 'volunteerConnectionsChart',
      data: [
        {label: "Connections", value: volunteerConnectionsCount},
        {label: "Opportunities", value: (volunteersCount-volunteerConnectionsCount)}
      ],
      colors: ['#009933','#9e9e9e']
    });
  }

  // Board Service ======================================================

  var boardserviceThisPeriodEl = document.getElementById("boardserviceThisPeriod");
  var boardServiceLastPeriodEl = document.getElementById("boardserviceLastPeriod")

  if(boardserviceThisPeriodEl && boardServiceLastPeriodEl) {

    var boardserviceThisPeriod = JSON.parse(boardserviceThisPeriodEl.innerHTML);
    var boardserviceLastPeriod = JSON.parse(boardServiceLastPeriodEl.innerHTML);
    var boardserviceData = boardserviceThisPeriod;

    var boardserviceCount = 0;
    for (var i=0; i<boardserviceThisPeriod.length; i++){
      if (Number.isInteger(boardserviceThisPeriod[i]["value"])){ 
        boardserviceCount = boardserviceCount + boardserviceThisPeriod[i]["value"];
      }
    }
    $('.category-number.boardservice').append(boardserviceCount);

    for (var i=0; i<boardserviceLastPeriod.length; i++){
      boardserviceData[i].oldValue = boardserviceLastPeriod[i].value;
    };
    new Morris.Area({
      element: 'boardserviceChart',
      data: boardserviceData,
      xkey: 'date',
      ykeys: ['oldValue','value'],
      labels: ['Old Posts', 'New Posts'],
      smooth: true,
      behaveLikeLine: true,
      hideHover: true,
      xLabels: "month",
      gridTextFamily: 'Roboto',
      lineColors: ['#9e9e9e','#009933'],
      xLabelFormat: function (date) { return monthNames[date.getMonth()]; },
      hoverCallback: function (index, options, content, row) {
        return new Date(boardserviceData[index].date).toDateString() +": "+ boardserviceData[index].value +" Posts<br>Last Period: "+ boardserviceData[index].oldValue +" Posts";
      }
    });

    var boardserviceConnections = JSON.parse(document.getElementById("boardserviceConnections").innerHTML);
    
    var boardserviceConnectionsCount = 0;
    for (var i=0; i<boardserviceConnections.length; i++){
      boardserviceConnectionsCount = boardserviceConnectionsCount + boardserviceConnections[i].value;
    }

    new Morris.Donut({
      element: 'boardserviceConnectionsChart',
      data: [
        {label: "Connections", value: boardserviceConnectionsCount},
        {label: "Opportunities", value: (boardserviceCount-boardserviceConnectionsCount)}
      ],
      colors: ['#009933','#9e9e9e']
    });
  }

  // Mentorship Circles ======================================================

  var mentorshipcirclesThisPeriodEl = document.getElementById("mentorshipcirclesThisPeriod");
  var mentorshipcirclesLastPeriodEl = document.getElementById("mentorshipcirclesLastPeriod");

  if(mentorshipcirclesThisPeriodEl && mentorshipcirclesLastPeriodEl) {

    var mentorshipcirclesThisPeriod = JSON.parse(mentorshipcirclesThisPeriodEl.innerHTML);
    var mentorshipcirclesLastPeriod = JSON.parse(mentorshipcirclesLastPeriodEl.innerHTML);
    var mentorshipcirclesData = mentorshipcirclesThisPeriod;

    var mentorshipcirclesCount = 0;
    for (var i=0; i<mentorshipcirclesThisPeriod.length; i++){
      if (Number.isInteger(mentorshipcirclesThisPeriod[i]["value"])){ 
        mentorshipcirclesCount = mentorshipcirclesCount + mentorshipcirclesThisPeriod[i]["value"];
      }
    }
    $('.category-number.mentorshipcircles').append(mentorshipcirclesCount);

    for (var i=0; i<mentorshipcirclesLastPeriod.length; i++){
      mentorshipcirclesData[i].oldValue = mentorshipcirclesLastPeriod[i].value;
    };
    new Morris.Area({
      element: 'mentorshipcirclesChart',
      data: mentorshipcirclesData,
      xkey: 'date',
      ykeys: ['oldValue','value'],
      labels: ['Old Posts', 'New Posts'],
      smooth: true,
      behaveLikeLine: true,
      hideHover: true,
      xLabels: "month",
      gridTextFamily: 'Roboto',
      lineColors: ['#9e9e9e','#009933'],
      xLabelFormat: function (date) { return monthNames[date.getMonth()]; },
      hoverCallback: function (index, options, content, row) {
        return new Date(mentorshipcirclesData[index].date).toDateString() +": "+ mentorshipcirclesData[index].value +" Posts<br>Last Period: "+ mentorshipcirclesData[index].oldValue +" Posts";
      }
    });

    var mentorshipcircleConnections = JSON.parse(document.getElementById("mentorshipcircleConnections").innerHTML);
    
    var mentorshipcircleConnectionsCount = 0;
    for (var i=0; i<mentorshipcircleConnections.length; i++){
      mentorshipcircleConnectionsCount = mentorshipcircleConnectionsCount + mentorshipcircleConnections[i].value;
    }

    new Morris.Donut({
      element: 'mentorshipcircleConnectionsChart',
      data: [
        {label: "Connections", value: mentorshipcircleConnectionsCount},
        {label: "Opportunities", value: (mentorshipcirclesCount-mentorshipcircleConnectionsCount)}
      ],
      colors: ['#009933','#9e9e9e']
    });
  }

  // Collaboration Circles ======================================================

  var collaborationcirclesThisPeriodEl = document.getElementById("collaborationcirclesThisPeriod");
  var collaborationcirclesLastPeriodEl = document.getElementById("collaborationcirclesLastPeriod");

  if(collaborationcirclesThisPeriodEl && collaborationcirclesLastPeriodEl) {

    var collaborationcirclesThisPeriod = JSON.parse(collaborationcirclesThisPeriodEl.innerHTML);
    var collaborationcirclesLastPeriod = JSON.parse(collaborationcirclesLastPeriodEl.innerHTML);
    var collaborationcirclesData = collaborationcirclesThisPeriod;

    var collaborationcirclesCount = 0;
    for (var i=0; i<collaborationcirclesThisPeriod.length; i++){
      if (Number.isInteger(collaborationcirclesThisPeriod[i]["value"])){ 
        collaborationcirclesCount = collaborationcirclesCount + collaborationcirclesThisPeriod[i]["value"];
      }
    }
    $('.category-number.collaborationcircles').append(collaborationcirclesCount);

    for (var i=0; i<collaborationcirclesLastPeriod.length; i++){
      collaborationcirclesData[i].oldValue = collaborationcirclesLastPeriod[i].value;
    };
    new Morris.Area({
      element: 'collaborationcirclesChart',
      data: collaborationcirclesData,
      xkey: 'date',
      ykeys: ['oldValue','value'],
      labels: ['Old Posts', 'New Posts'],
      smooth: true,
      behaveLikeLine: true,
      hideHover: true,
      xLabels: "month",
      gridTextFamily: 'Roboto',
      lineColors: ['#9e9e9e','#009933'],
      xLabelFormat: function (date) { return monthNames[date.getMonth()]; },
      hoverCallback: function (index, options, content, row) {
        return new Date(collaborationcirclesData[index].date).toDateString() +": "+ collaborationcirclesData[index].value +" Posts<br>Last Period: "+ collaborationcirclesData[index].oldValue +" Posts";
      }
    });

    var collaborationcircleConnections = JSON.parse(document.getElementById("collaborationcircleConnections").innerHTML);
    
    var collaborationcircleConnectionsCount = 0;
    for (var i=0; i<collaborationcircleConnections.length; i++){
      collaborationcircleConnectionsCount = collaborationcircleConnectionsCount + collaborationcircleConnections[i].value;
    }

    new Morris.Donut({
      element: 'collaborationcircleConnectionsChart',
      data: [
        {label: "Connections", value: collaborationcircleConnectionsCount},
        {label: "Opportunities", value: (collaborationcirclesCount-collaborationcircleConnectionsCount)}
      ],
      colors: ['#009933','#9e9e9e']
    });
  }

  // Insights ======================================================

  var insightsThisPeriodEl = document.getElementById("insightsThisPeriod");
  var insightsLastPeriodEl = document.getElementById("insightsLastPeriod");

  if(insightsThisPeriodEl && insightsLastPeriodEl) {

    var insightsThisPeriod = JSON.parse(insightsThisPeriodEl.innerHTML);
    var insightsLastPeriod = JSON.parse(insightsLastPeriodEl.innerHTML);
    var insightsData = insightsThisPeriod;

    var insightsCount = 0;
    for (var i=0; i<insightsThisPeriod.length; i++){
      if (Number.isInteger(insightsThisPeriod[i]["value"])){ 
        insightsCount = insightsCount + insightsThisPeriod[i]["value"];
      }
    }
    $('.category-number.insights').append(insightsCount);

    for (var i=0; i<insightsLastPeriod.length; i++){
      insightsData[i].oldValue = insightsLastPeriod[i].value;
    };
    new Morris.Area({
      element: 'insightsChart',
      data: insightsData,
      xkey: 'date',
      ykeys: ['oldValue','value'],
      labels: ['Old Posts', 'New Posts'],
      smooth: true,
      behaveLikeLine: true,
      hideHover: true,
      xLabels: "month",
      gridTextFamily: 'Roboto',
      lineColors: ['#9e9e9e','#009933'],
      xLabelFormat: function (date) { return monthNames[date.getMonth()]; },
      hoverCallback: function (index, options, content, row) {
        return new Date(insightsData[index].date).toDateString() +": "+ insightsData[index].value +" Posts<br>Last Period: "+ insightsData[index].oldValue +" Posts";
      }
    });
  }

  // Total ======================================================

  var totalCount = mentorshipCount+jobshadowingCount+volunteersCount+boardserviceCount+mentorshipcirclesCount+collaborationcirclesCount+insightsCount;
  $('.stat-total').append(totalCount);

});
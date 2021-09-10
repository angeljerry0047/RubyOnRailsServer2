S2p.pacCounter = 0;
S2p.pacs = {
  competencySelectEvent: function(e) {
    var $target = $(e.target),
        $competencies = $target.children('option:selected'),
        currValue = $target.parents('.pac_competency_ids').find('.chzn-choices li span').last().text(),
        maxItems = parseInt($target.data('maxitems'),10);

    //prevent more than three items from being chosen
    if( isNaN(maxItems) ){return;}
    if ($competencies.length > maxItems){
      $competencies.filter(function(){
        return $(this).text().replace(/\s+/g,'') == currValue.replace(/\s+/g,'');})
        .removeAttr('selected');
      $competencies.parent().trigger("liszt:updated");

    }
  },

  morepacsEvent: function(e) {
    //This was a pain in the ass due to Chosen's inability to determine uniqueness on
    // Anything other than IDs :(
    e.preventDefault();
    var $pac_segment = $('.historical_pac:hidden').clone();
    $pac_segment.find('input.ghost_pac_segment').val('false');
    $pac_segment.clearForm();
    $('.pac_list').append($pac_segment);
    S2p.pacCounter += 1;
    var $chzn = $pac_segment.find('.chzn-select');
    $chzn.attr('id', $chzn.attr('id') + S2p.pacCounter);
    $pac_segment.removeClass('hidden');
    S2p.initializeChosen();
    $pac_segment.find('.chzn-select').on('change', S2p.pacs.competencySelectEvent);
  },

  lesspacEvent: function(e){
    e.preventDefault();
    var $pac_segment = $(e.target).parents('div.pac_segment');
    $pac_segment.remove();
  },

  addEmptypac: function(e){
    var newOp = $('.historical_pac.hidden').clone().removeClass('hidden')
    $('.pac_list').append("<div class='opp'>"+newOp[0].outerHTML);
  }
};

$(function() {

    $("#new_pac").validate({
      rules: {
        "pacs__title": "required",
        "pacs__organization_name": "required",
        "pacs__description": "required",
        "pacs__city": "required",
        "pacs__state": "required",
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

  function getvalues(f)
  {
    var form=$("#"+f);
    var str='';
    $("input:not('input:submit')", form).each(function(i){
        str+='\n'+$(this).prop('name')+': '+$(this).val();
    });
    return str;
  }

  $('.pacs #vsas').masonry({
    itemSelector : '.result',
    columnWidth : 300
  });

  $('#add_pac').on('click', S2p.pacs.morepacsEvent);

  $('#more_pacs').on('click', S2p.pacs.morepacsEvent);

  $('select.chzn-select').on('change', S2p.pacs.competencySelectEvent);

  $('a.less_pac').on('click', S2p.pacs.lesspacEvent);

  $('.internal_pac').on('change', function() {
    $dept_field = $('.organization_dept');
    if($(this).val()=='1'){
      $dept_field.show();
    } else {
      $dept_field.hide();
    }
  });

  $(".auto_complete_org_name").on("change", function(e){
    $('#internal_radio_org_name').text($(e.target).val());
  });

  // Hope this goes away sometime soon lol...
  $('#time_range').on('change', function(e) {
    // This will go away later... I hope
    e.preventDefault();
    var $target = $(e.target);
    var $time_range = $target.find(":selected");
    var $min = $target.siblings('input[name="pacs[][min_hour]"]');
    var $max = $target.siblings('input[name="pacs[][max_hour]"]');
    $min.val($time_range.data('min-hour'));
    $max.val($time_range.data('max-hour'));
    return true;
  });
});
$(document).on('ready', function() {
  $("#pacs__start_date").datepicker({
  	minDate: 0,
  	dateFormat: 'yy-mm-dd'	
  });
  $("#pacs__deadline_date").datepicker({
  	minDate: 0,
  	dateFormat: 'yy-mm-dd'			
  });  

  $(".btn-slide-fc-upload").click(function(){
  if (!$("#panel-fc-upload").is(":visible")){
    
     $("#panel-fc-upload").slideToggle("slow");
   }
  else { 
    $("#panel-fc-upload").hide("slow");
  };
  return false;  
 });
  
  var oppor = document.getElementById("pacs__start_date");
  
  if(oppor != null)
  {	
	  
	  $.ajax({
	    url: "/pacs/getFacilities?pacs[][city]="+$('#pacs__city').val()+"&pacs[][state]="+$('#pacs__state').val(),
	    type: 'GET',
	    success: function (resp) {
	    	var selectFacility = $('#facility_name_dropdown');
			var facilityID = 0;
		    selectFacility.empty();
		
		    $.each(resp, function(index, value) {
		      var opt = $('<option/>');
		      opt.attr('value', value[0]);
		      opt.text(value[1]);
		      opt.appendTo(selectFacility);
		      if($('#pacs__facility_name').val()==value[1]){
		      	facilityID = value[0];
		      }
		    });
		    var opt = $('<option/>');
		    opt.attr('value', "-1");
		    opt.text('Please select a valid City and State');
		    opt.appendTo(selectFacility);
		    
		    opt = $('<option/>');
		    opt.attr('value', "0");
		    opt.text('Other');
		    opt.appendTo(selectFacility);
		    
		    if(facilityID==0){
		    	$("#facility_name_dropdown").val(-1);
		    }else{
		    	$("#facility_name_dropdown").val(facilityID);
		    	$("select#facility_name_dropdown option[value='-1']").remove(); 	
		    }   
		    
		    $('#pacs__facility_id').val($('#facility_name_dropdown').val());
		    if($('#pacs__facility_id').val() == 0){
		    	$('#otherFacility').show();
		    	$('.facility-input').prop('readonly', false);    	
		    }else{
		    	$('#otherFacility').hide();
		    	$('.facility-input').prop('readonly', true);	
		    }    
	    },
	    error: function(e) {
	        alert('Error: '+e);
	    }  
	  });
	  $('#pdeCharge').hide();  
	  
  }
    
    $(':submit').click(function(){
    var val1 = $('#pacs__min_students').val();
    var val2 = $('#pacs__max_students').val();
    var date1 = $('#pacs__start_date');
    var date2 = $('#pacs__deadline_date');
    var hour1 = $('#pacs__start_time');
    var hour2 = $('#pacs__end_time');
    var success = true;
    
     if(val1.length > 0 && val2.length > 0){         
       if(parseInt(val1) > parseInt(val2)){
         $('#pacs__max_students').next('span').remove();
         $('#pacs__max_students').addClass("genErrorBorder").after('<span class="genError">Must be greater than min value</span>');
         $('#pacs__min_students').addClass("genErrorBorder");
         success =  false;     
       }
       else{
           $('#pacs__max_students').removeClass("genErrorBorder").next().remove();
           $('#pacs__min_students').removeClass("genErrorBorder");
           
       }
     }
     
     if(hour1.val().length > 0 && hour2.val().length > 0){              
         var cD = '01/01/2011 ';
         //alert(Date.parse(cD + hour1.val()) +'   other  '+ cD + hour2.val());
     if(new Date(cD + hour1.val().replace("am", " am").replace("pm", " pm")) > new Date(cD + hour2.val().replace("am", " am").replace("pm", " pm"))){             
         $(hour1).next('span').remove();
         $(hour1).addClass("genErrorBorder").after('<span class="genError">Must be lower than End Time value</span>');
          $(hour2).addClass("genErrorBorder");
          success = false;       
       }
       else{
           $(hour1).removeClass("genErrorBorder").next().remove();
           $(hour2).removeClass("egnErrorBorder");
       
       }         
     }       

     if(date1.val().length > 0 && date2.val().length > 0){              
         if(new Date(date1.val()) < new Date(date2.val())){             
         $(date1).next('span').remove();
         $(date1).addClass("genErrorBorder").after('<span class="genError">Must be greater than Dead line value</span>');
          $(date2).addClass("genErrorBorder");
          success = false;       
       }
       else{
           $(date1).removeClass("genErrorBorder").next().remove();
           $(date2).removeClass("egnErrorBorder");
       
       }         
     }       
     
     return success;
 });
 
    
    
  var oppor = document.getElementById("pacs__start_date");
  
  if(oppor != null)
  {
	  if($('#pacs__start_date').val() != ""){
	  	var startShortDate = $('#pacs__start_date').val().substr(0,10); 
	  	var deadlineShortDate = $('#pacs__deadline_date').val().substr(0,10); 
	  	$('#pacs__start_date').val(startShortDate);
	  	$('#pacs__deadline_date').val(deadlineShortDate);
	    $("#pacs__start_date").datepicker("setDate", startShortDate);
	    $("#pacs__deadline_date").datepicker("setDate", deadlineShortDate);
	  }
  }
  
  $('#otherFacility').hide();
  
  $('#pacs__state').on('ajax:success', function(evt, data, status, xhr) {

    var selectFacility = $('#facility_name_dropdown');

    selectFacility.empty();

    $.each(data, function(index, value) {
      var opt = $('<option/>');
      opt.attr('value', value[0]);
      opt.text(value[1]);
      opt.appendTo(selectFacility);
    });
    
    //Add an option for 'others' values
    var opt = $('<option/>');
    opt.attr('value', "0");
    opt.text('Other');
    opt.appendTo(selectFacility);    
    
    $('#pacs__facility_id').val($('#facility_name_dropdown').val());
    selectFacility.change();
    if($('#pacs__facility_id').val() == 0){
    	$('#otherFacility').show();
    	$('.facility-input').prop('readonly', false);    	
    }else{
    	$('#otherFacility').hide();
    	$('.facility-input').prop('readonly', true);	
    } 
  });
  
  $('#pacs__state').on('ajax:beforeSend', function(event, xhr, settings) {
  	 settings.url = "/pacs/getFacilities?pacs[][city]="+$('#pacs__city').val()+"&pacs[][state]="+$('#pacs__state').val();
  });
  

  
  $('#pacs__state').on('ajax:error', function(event, xhr, status) {
	  // insert the failure message inside the "#account_settings" element
	  alert(xhr.responseText);
  });
  
  $('#facility_name_dropdown').on('ajax:success', function(evt, data, status, xhr) {
    
    $.each(data, function(index, value) {
      $('#pacs__facility_address').val(value[1]);
      $('#pacs__facility_approval_name').val(value[4]);
      $('#pacs__facility_approval_mail').val(value[5]);
      var lat = value[2].substring(1,value[2].indexOf(","));
      var lon = value[2].substring(value[2].indexOf(",")+1,value[2].length-1);
      codeAddress(lat,lon);
    }); 
  });
  
  $('#facility_name_dropdown').change(function() {	
	  $('#pacs__facility_id').val($('#facility_name_dropdown').val());
	  if($('#pacs__facility_id').val() == 0){
    	$('#otherFacility').show();
    	$('.facility-input').prop('readonly', false);
    	$('#pacs__facility_address').val("");
    	$('#pacs__facility_name').val("");
	    $('#pacs__city').val("");
	    $('#pacs__facility_approval_name').val("");
	    $('#pacs__facility_approval_mail').val("");    	
      }else{
      	$('#otherFacility').hide();
      	$('.facility-input').prop('readonly', true); 
      }
  });
  
  $('#pacs__pac_category_id').on('ajax:success', function(evt, data, status, xhr) {
      $.each(data, function(index, value) {  
      	if(value[1]>0){
      		$('#pdeCharge').show();
      		$('#price').html("$" + parseFloat((value[1])).toFixed(2));
      	}else{
      		$('#pdeCharge').hide();
      	}             
      });    
  }); 
	
  $('#btnCreate').bind('click', function(e){
   	var isVisible = $('#pdeCharge').is(':visible');
   	if(isVisible){
	   	if(!$('#squaredThree').prop('checked')){
	    console.log('not checked');
	    e.stopPropagation();
	    e.preventDefault();
	      	alert("You must accept the cost before registering for this skill.");
	    }
    }
  });  
  
  
});

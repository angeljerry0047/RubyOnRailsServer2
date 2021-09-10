$(document).on('ready', function() {
  $("#mentor_action_plan_start_date").datepicker({
  	minDate: 0,
  	dateFormat: 'yy-mm-dd'	
  });
  $("#mentor_action_plan_end_date").datepicker({
  	minDate: 0,
  	dateFormat: 'yy-mm-dd'			
  });
  $("#mentor_action_plan_mentor_deadlines").datepicker({
  	minDate: 0,
  	dateFormat: 'yy-mm-dd'	
  });
  $("#mentor_action_plan_participant_deadlines").datepicker({
  	minDate: 0,
  	dateFormat: 'yy-mm-dd'			
  });  
  

var oppor = document.getElementById("mentor_action_plan_start_date");

    $(':submit').click(function(){
    var date1 = $('#mentor_action_plan_start_date');
    var date2 = $('#mentor_action_plan_end_date');
    var hour1 = $('#opportunities__start_time');
    var hour2 = $('#opportunities__end_time');
    var success = true;
      

     if(date1.val().length > 0 && date2.val().length > 0){              
         if(new Date(date2.val()) < new Date(date1.val())){             
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
    var oppor = document.getElementById("mentor_action_plan_start_date");
  
  if(oppor != null)
  {
	  if($('#mentor_action_plan_start_date').val() != ""){
	  	var startShortDate = $('#mentor_action_plan_start_date').val().substr(0,10); 
	  	var deadlineShortDate = $('#mentor_action_plan_end_date').val().substr(0,10); 
	  	$('#mentor_action_plan_start_date').val(startShortDate);
	  	$('#mentor_action_plan_end_date').val(deadlineShortDate);
	    $("#mentor_action_plan_start_date").datepicker("setDate", startShortDate);
	    $("#mentor_action_plan_end_date").datepicker("setDate", deadlineShortDate);
	  }
  }

  });

$(function() {

    $("#new_mentor_action_plan").validate({
      rules: {
        "mentor_action_plan_participant_name": "required",
        "mentor_action_plan_start_date": "required",
        "mentor_action_plan_end_date": "required",
        "mentor_action_plan_participant_deadlines": "required",
        "mentor_action_plan_mentor_deadlines": "required",
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
  });

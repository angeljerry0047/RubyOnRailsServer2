S2p.interests = {
  interestsSelectEvent: function(e){
    alert("balls");
    var $target = $(e.target),
        $interests = $target.children('option:selected'),
        currValue = $target.parents('.user_interests').find('.chzn-choices li span').last().text(),
        maxItems = 3;

    //prevent more than three items from being chosen

    if( isNaN(maxItems) ){return;}
    if ($interests.length > maxItems){
      $interests.filter(function(){
        return $(this).text().replace(/\s+/g,'') == currValue.replace(/\s+/g,'');})
        .removeAttr('selected');
      $interests.parent().trigger("liszt:updated");

    }
  }
};  

  $(function() {

    $("#edit_user").validate({
      ignore: [],
      rules: {
        "user_interest_ids": "required",
      },
      errorPlacement: function(error,element) {
        if (element.is(":hidden")) {
            //console.log(element.next().parent());
            error.insertAfter(element.next(".chzn-container")); 
            element.next(".chzn-container").toggleClass("error");
            $("#user_organization_name").focus(); //Can't seem to get the focus to work. Maybe this will be important someday. Sorry future me.
            console.log("INVALID: ");
          }
        else {
            error.insertAfter(element);
          }
      },
      submitHandler: function(form) {
        form.submit();
      }
    });    
  });

$(function() {
  $('div.btn-group').each(function(){
    if (!$(this).data('toggleName')) {
      return;
    }
    var group   = $(this);
    var form    = group.parents('form').eq(0);
    var name    = group.data('toggleName');
    var hidden  = $('input[name="' + name + '"]', form);

    $('button', group).each(function(){
      var button = $(this);
      button.on('click', function(){
          hidden.val($(this).val());
      });
      if(button.val() === hidden.val()) {
        button.addClass('active');
      }
    });
  });
})
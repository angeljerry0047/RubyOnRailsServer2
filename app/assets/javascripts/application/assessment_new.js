$(document).on('ready', function() {
  var $form = $('#new_assessment_report');
  if (!$form.get(0)) return;

  //prevent carousel from moving on its own
  $('.carousel').carousel({
    interval: false
  });
  //open first form
  setTimeout(function() {
    $form.find('.collapse-group:first').slideDown();
  }, 1000);

  $('input:radio').on('change', function(e) {
    var $this = $(this);
    $this.parents('tr').find('label').removeClass("checked");
    if ($this.is(':checked')) {
      $this.parents('label').addClass("checked");
    }
    updateGroupProgressCounter($this.parents('.collapse-group'));
  });

  $('.btn.next').on('click', function(e) {
    var $this = $(this),
      $carousel = $this.parents('.carousel'),
      $currGroup = $carousel.find('.collapse-group'),
      $nextGroup = $carousel.next().find('.collapse-group'),
      $lastGroup = $form.find('.collapse-group:last'),
      $currSubGroup = $carousel.find('.item.active'),
      $lastSubGroup = $carousel.find('.item:last'),
      $alert = $carousel.find('.alert');

    $alert.hide();
    if (isSubGroupValid($currSubGroup)) {

      if ($currSubGroup.is($lastSubGroup)) {
        $currGroup.slideUp();
        if ($currGroup.is($lastGroup)) {
          $(window).unbind('beforeunload');
          $form.submit();
        } else {
          $nextGroup.slideDown();
        }
      } else {
        $carousel.carousel('next');
      }

    } else {
      $alert.fadeIn();
    }
  });

  function updateGroupProgressCounter($group) {
    var count = $group.find('tr').has('input:checked').length;
    $group.parents('.carousel').find('.checkedCount').text(count);
  }

  function isSubGroupValid($subGroup) {
    $subGroup.find('tr').removeClass('error');
    var isValid = true;
    $subGroup.find('input:radio').each(function() {
      var n = $(this).attr('name'),
        $uncheckedRadioSet = $subGroup.find('input:radio[name="' + n + '"]:not(:checked)');

      if ($uncheckedRadioSet.length == 5) {
        $uncheckedRadioSet.parents('tr:first').addClass('error');
        isValid = false;
      }
    });
    return isValid;
  }

  $(window).on('beforeunload', function() {
    return 'If you leave you will need to restart the assesment.';
  });
});

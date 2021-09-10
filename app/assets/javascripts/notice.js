$(function() {

  window.notice = function(message, type, persist) {
    var alert;
    if (type == null) {
      type = 'notice';
    }
    if (persist == null) {
      persist = false;
    }
    alert = $("<div class='flash-body'><a class='close' href='#'>x</a></div>");
    alert.prepend(message);
    alert = $("<div class='flash alert-message " + type + " fade in' data-alert='alert' />").prepend(alert);
    $('header').prepend(alert);
    if (!persist) {
      $(alert).delay(2000).slideUp('fast', function() {
        return $(this).remove();
      });
    }
    return alert.alert();
  };

  $(function() {
    return $('.alert-message a.close').on('click', function() {
      return $(this).closest('.flash').slideUp('fast', function() {
        return $(this).remove();
      });
    });
  });

  $(function() {
    return $('.alert:not(.persist)').delay(5000).slideUp('slow', function() {
      return $(this).remove();
    });
  });

})
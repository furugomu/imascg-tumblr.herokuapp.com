jQuery(function($) {
  $('.tabs').on('click', 'a', function() {
    var selector = $(this).attr('href');
    var $target = $(selector);
    $(this)
      .siblings().removeClass('active').end()
      .addClass('active');
    $target
      .siblings()
        .hide().prop('required', false)
        .find(':input').prop('disabled', true).end()
      .end()
      .show().prop('required', true)
      .find(':input').prop('disabled', false);
  });
});

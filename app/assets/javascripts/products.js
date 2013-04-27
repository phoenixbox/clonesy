$(document).ready(function () {
  $('.thumb').on('click', function () {
    var id = $(this).data('url');
    $('.main_image').html('<img src=' + id + '/ class="pull-left">');
  });
});

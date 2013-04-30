$(function () {

  $('.product-display').on('mouseover', function () {
    $(this).find('.product-favorite').show();
  });
  $('.product-display').on('mouseleave', function () {
    $(this).find('.product-favorite').hide();
  });


});
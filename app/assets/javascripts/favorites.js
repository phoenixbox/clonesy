$(function () {

  $('.product-display').on('mouseover', function () {
    $(this).find('.product-favorite').show();
    $(this).find('.circle').show();
  });
  $('.product-display').on('mouseleave', function () {
    $(this).find('.product-favorite').hide();
    $(this).find('.circle').hide();
  });


});
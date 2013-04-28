$(function () {

    $('.thumb').on('mouseover', function () {
        var url = $(this).data('url');
        $('.main_image').html('<img src=' + url + '/ class="pull-left">');
    });

    $('form img').on({
        mouseenter: function () {
            $(this).fadeTo('medium', 0.4);
            $(this).parent().find('.text-thumb').fadeIn('medium');
        },
        mouseleave: function () {
            $(this).fadeTo('medium', 1);
            $(this).parent().find('.text-thumb').fadeOut('medium');
        },
        click: function () {
            var image_id = $(this).data('image-id');
            $(this).parent().parent().append('<input id=product_images_data_' + image_id + ' name="product[images][data_' + image_id + ']" type="file"><br>');
            $(this).parent().remove();

            $.ajax({
                url: 'destroy_image',
                type: "post",
                dataType: "json",
                data: {"_method": "delete", "image_id": image_id}
            });
        }
    });

});

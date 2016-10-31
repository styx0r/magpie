$(document).on('turbolinks:load', function() {
    $(".clickable-row").click(function() {
        window.location = $(this).data("href");
    });
});

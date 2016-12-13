ready = function() {
  $('input[type=file]').bootstrapFileInput();
  $('.file-inputs').bootstrapFileInput();
}


$(document).on('turbolinks:load', ready);

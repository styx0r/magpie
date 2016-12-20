ready = function() {
  //$('input[type=file]').bootstrapFileInput();
  //$('.file-inputs').bootstrapFileInput();
  $('#file-inputs-micropost-image').bootstrapFileInput();
  $('.file-inputs-register-model').bootstrapFileInput();
  $('.file-inputs-model-config').bootstrapFileInput();
}


$(document).on('turbolinks:load', ready);

ready = function() {
  //$('input[type=file]').bootstrapFileInput();
  //$('.file-inputs').bootstrapFileInput();
  if(document.getElementById("file-inputs-micropost-image") != null && document.getElementById("file-inputs-micropost-image").getAttribute("styled-button") == null){
    $('#file-inputs-micropost-image').bootstrapFileInput();
    document.getElementById("file-inputs-micropost-image").setAttribute("styled-button", "true");
  }


  if(document.getElementsByClassName("file-inputs-register-model")[0] != null && document.getElementsByClassName("file-inputs-register-model")[0].getAttribute("styled-button") == null){
    $('.file-inputs-register-model').bootstrapFileInput();
    document.getElementsByClassName("file-inputs-register-model")[0].setAttribute("styled-button", "true");
  }

  if(document.getElementsByClassName("file-inputs-model-config")[0] != null && document.getElementsByClassName("file-inputs-model-config")[0].getAttribute("styled-button") == null){
    $('.file-inputs-model-config').bootstrapFileInput();
    document.getElementsByClassName("file-inputs-model-config")[0].setAttribute("styled-button", "true");
  }

  if(document.getElementById("file-inputs-model-reupload") != null && document.getElementById("file-inputs-model-reupload").getAttribute("styled-button") == null){
    $('#file-inputs-model-reupload').bootstrapFileInput();
    document.getElementById("file-inputs-model-reupload").getAttribute("styled-button", "true");
  }
}


$(document).on('turbolinks:load', ready);

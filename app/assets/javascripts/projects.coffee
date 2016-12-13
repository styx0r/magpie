# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
selectModel = ->

  if $('#project_model_id').find(":selected").text() != ""

    if document.getElementById 'model_info_sync'
      model_id = $('#project_model_id').find(":selected")[0].value
      $.ajax
        # url has to be modified, in order to update the right job according to the id
        async: true
        url: "/project_modeldescription?model_id="+model_id
        cache: true
        success: (html) ->
          #console.log html
          document.getElementById('model_info_sync').innerHTML = html

    if document.getElementById 'project_modelconfig'
      model_id = $('#project_model_id').find(":selected")[0].value
      model_revision = "HEAD"
      $.ajax
        async: true
        url: "/project_modelconfig?model_id="+model_id+"&model_revision="+model_revision
        cache: true
        success: (html) ->
          #console.log html
          document.getElementById('project_modelconfig').innerHTML = html
          $('input[type=file]').bootstrapFileInput()
          $('.file-inputs').bootstrapFileInput()

     if document.getElementById 'project_modelrevisions'
       model_id = $('#project_model_id').find(":selected")[0].value
       $.ajax
         async: true
         url: "/project_modelrevisions?model_id="+model_id
         cache: true
         success: (html) ->
           #console.log html
           document.getElementById('project_modelrevisions').innerHTML = html

selectRevision = ->

  if $('#project_model_id').find(":selected").text() != ""

    if document.getElementById 'project_modelconfig'
      model_id = $('#project_model_id').find(":selected")[0].value
      model_revision = $('#config_revision').find(":selected").text()
      $.ajax
        async: true
        url: "/project_modelconfig?model_id="+model_id+"&model_revision="+model_revision
        cache: true
        success: (html) ->
          #console.log html
          document.getElementById('project_modelconfig').innerHTML = html


changeModel = -> if document.getElementById 'project_model_id'
  document.getElementById('project_model_id').onchange = selectModel

changeRevision = -> if document.getElementById 'project_modelrevisions'
  document.getElementById('project_modelrevisions').onchange = selectRevision


$( document ).on('turbolinks:load', changeModel)
$( document ).on('turbolinks:load', changeRevision)

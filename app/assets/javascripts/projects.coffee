# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
selectModel = ->
  if document.getElementById 'model_info_sync'
    model_name = $('#project_model_id').find(":selected").text()
    $.ajax
      # url has to be modified, in order to update the right job according to the id
      async: true
      url: "/project_modeldescription?model_name="+model_name
      cache: true
      success: (html) ->
        #console.log html
        document.getElementById('model_info_sync').innerHTML = html

  if document.getElementById 'project_modelconfig'
    model_name = $('#project_model_id').find(":selected").text()
    $.ajax
      async: true
      url: "/project_modelconfig?model_name="+model_name
      cache: true
      success: (html) ->
        #console.log html
        document.getElementById('project_modelconfig').innerHTML = html

ready = -> if document.getElementById 'project_model_id'
  document.getElementById('project_model_id').onchange = selectModel

#$(document).ready(ready)
#$(document).on('page:load', ready)

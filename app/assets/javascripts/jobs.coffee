# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  updateElements = document.getElementsByClassName "panel panel-warning"
  if(updateElements.length > 0)
#    console.log updateElements
    i = 0
    while i < updateElements.length
      id = updateElements[i].childNodes[3].id.split('_')[1]
      $.ajax
        # url has to be modified, in order to update the right job according to the id
        async: true
        url: "/job_running?job_id="+id
        cache: true
        local_id: id
        success: (html) ->
          console.log html
          document.getElementById("job_id "+this.local_id).innerHTML = html
      i++
    setTimeout(ready, 5000)
$(document).ready(ready)
$(document).on('page:load', ready)

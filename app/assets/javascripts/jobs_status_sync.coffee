root = exports ? this # exporting global variables
# call function on page load ready
ready = ->
  # only execute if div is available
  if document.getElementById 'jobs_status_sync'
    $.ajax
      # defines the call in the controller (dashboard)
      url: "/jobs_status"
      cache: true
      success: (html) ->
        # includes the rendered html in the "micropost_feed_sync" div
        $("#jobs_status_sync").html html
        # if a timer for this particular job was already started clear the old one first
        if(root.timer_jobs_status)
          clearInterval root.timer_jobs_status
        # timerfunction is updateing the div with the defined interval
        root.timer_jobs_status = setInterval ((e) ->
          # if the div is not present the time will be stopped (else), otherwise a reload
          if document.getElementById 'jobs_status_sync'
            $.ajax(url: "/jobs_status").done (html) ->
              $('#jobs_status_sync').html html
          else
            clearInterval root.timer_jobs_status # stop of timer
          return
        ), 5000; # interval
# ready is called when page load is finished and on page load / change
$(document).ready(ready)
$(document).on('page:load', ready)

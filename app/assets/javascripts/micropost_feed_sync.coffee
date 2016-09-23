root = exports ? this # exporting global variables
# call function on page load ready
ready = ->
  # only execute if div is available
  if document.getElementById 'micropost_feed_sync'
    $.ajax
      # defines the call in the controller (dashboard)
      url: "/microposts_feed"
      cache: true
      success: (html) ->
        # includes the rendered html in the "micropost_feed_sync" div
        $("#micropost_feed_sync").html html
        # if a timer for this particular job was already started clear the old one first
        if(root.timer_jobs_status)
          clearInterval root.timer_feed_sync
        # timerfunction is updateing the div with the defined interval
        root.timer_feed_sync = setInterval ((e) ->
          # if the div is not present the time will be stopped (else), otherwise a reload
          if document.getElementById 'micropost_feed_sync'
            $.ajax(url: "/microposts_feed").done (html) ->
              $('#micropost_feed_sync').html html
          else
            clearInterval root.timer_feed_sync # stop of timer
          return
        ), 10000; # interval
# ready is called when page load is finished and on page load / change
#$(document).ready(ready)
#$(document).on('page:load', ready)

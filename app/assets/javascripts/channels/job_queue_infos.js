App.job_queue_infos = App.cable.subscriptions.create("JobQueueInfosChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    if(document.getElementById("queued_jobs_me")){
      document.getElementById("queued_jobs_me").innerHTML = data.me_queue;
    }
    if(document.getElementById("jobs_running")){
      document.getElementById("jobs_running").innerHTML = data.me_running;
    }
    if(document.getElementById("jobs_finished")){
      document.getElementById("jobs_finished").innerHTML = data.me_finished;
    }
    if(document.getElementById("jobs_failed")){
      document.getElementById("jobs_failed").innerHTML = data.me_failed;
    }
    if(document.getElementById("job_" + data.job_id)){
      $.ajax({
          async: true,
          url: "/job_running?job_id=" + data.job_id,
          cache: true,
          success: function(html) {
            return document.getElementById("job_id " + data.job_id).innerHTML = html;
          }
        });
    }
  }
});

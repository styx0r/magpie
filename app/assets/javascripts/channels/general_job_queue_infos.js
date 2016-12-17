App.general_job_queue_infos = App.cable.subscriptions.create("GeneralJobQueueInfosChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    if(document.getElementById("queued_jobs_all")){
      document.getElementById("queued_jobs_all").innerHTML = data.all_queue;
      document.getElementById("queue_load").innerHTML = data.all_running + "/" + data.worker_number;
      if (data.worker_number/4 >= data.all_running) {
        $("#queue-load-pic-yellow").fadeOut();
        $("#queue-load-pic-orange").fadeOut();
        $("#queue-load-pic-red").fadeOut();
        $("#queue-load-pic-black").delay(400).fadeIn();
      } else if (data.worker_number/2 >= data.all_running) {
        $("#queue-load-pic-orange").fadeOut();
        $("#queue-load-pic-red").fadeOut();
        $("#queue-load-pic-black").fadeOut();
        $("#queue-load-pic-yellow").delay(400).fadeIn();
      } else if ((data.worker_number/4 * 3) >= data.all_running) {
        $("#queue-load-pic-red").fadeOut();
        $("#queue-load-pic-black").fadeOut();
        $("#queue-load-pic-yellow").fadeOut();
        $("#queue-load-pic-orange").delay(400).fadeIn();
      } else {
        $("#queue-load-pic-black").fadeOut();
        $("#queue-load-pic-yellow").fadeOut();
        $("#queue-load-pic-orange").fadeOut();
        $("#queue-load-pic-red").delay(400).fadeIn();
      }
    }
  }
});

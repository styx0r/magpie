App.general_job_queue_infos = App.cable.subscriptions.create("GeneralJobQueueInfosChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    document.getElementById("queued_jobs_all").innerHTML = data.all_queue;
  }
});

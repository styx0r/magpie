App.job_queue_infos = App.cable.subscriptions.create("MicropostsChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    if(document.getElementById("micropost_feed_sync")){
      $.ajax({
          async: true,
          url: "/microposts_feed",
          cache: true,
          success: function(html) {
            return document.getElementById("micropost_feed_sync").innerHTML = html;
          }
        });
    }
  }
});

# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class MicropostsChannel < ApplicationCable::Channel

  def subscribed
    if !current_user.nil?
      stream_from "microposts_#{current_user.id}"
      #notify
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  protected
    def notify
      ActionCable.server.broadcast("microposts_#{current_user.id}",
        notify: true)
    end
end

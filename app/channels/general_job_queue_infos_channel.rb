# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class GeneralJobQueueInfosChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "job_queue_infos"
    notify
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  protected
    def notify
      ActionCable.server.broadcast("job_queue_infos",
        all_queue: Job.where(:status => "waiting").count)
    end
end

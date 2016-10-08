# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class JobQueueInfosChannel < ApplicationCable::Channel

  def subscribed
    stream_from "job_queue_infos_#{current_user.id}"
    notify
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  protected
    def notify
      ActionCable.server.broadcast("job_queue_infos_#{current_user.id}",
        me_queue: Job.where(:user_id => current_user.id, :status => "waiting").count,
        me_running: Job.where(:user_id => current_user.id, :status => "running").count,
        me_finished: Job.where(:user_id => current_user.id, :status => "finished").count,
        me_failed: Job.where(:user_id => current_user.id, :status => "failed").count,
        job_id: @job.id)
    end
end

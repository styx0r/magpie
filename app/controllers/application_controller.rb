class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def postbot
      User.find_by(email: Rails.application.config.postbot_email)
    end

    def postbot_says(message, hashtags=[])
      if hashtags.length != 0
        message = message + " #" + hashtags.map{|h| h.tag}.join(" #")
      end
      Micropost.create(content: message, user_id: postbot.id)
    end

    def random_advice
      Rails.application.config.postbot_advice.sample
    end

end

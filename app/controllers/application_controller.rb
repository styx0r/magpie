class ApplicationController < ActionController::Base
  before_filter :strict_transport_security
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def strict_transport_security
    if request.ssl?
      response.headers['Strict-Transport-Security'] = "max-age=31536000; includeSubDomains"
    end
  end

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
      micropost = Micropost.create(content: message, user: postbot)
      micropost.extract_hashtags

    end

    def random_advice
      Rails.application.config.postbot_advice.sample
    end

end

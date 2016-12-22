class ApplicationController < ActionController::Base
  before_filter :strict_transport_security
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  around_filter :catch_not_found
  include SessionsHelper

  include Pundit
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  #rescue_from ActionController::RoutingError, with: :routing_error

  def strict_transport_security
    if request.ssl?
      response.headers['Strict-Transport-Security'] = "max-age=31536000; includeSubDomains"
    end
  end

  def routing_error
    skip_authorization
    flash[:danger] = "Not a valid route!"
    redirect_to(request.referrer || root_path)
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
        if message.length > 140
          message = message.truncate(140, separator:' ', omission:' ...')
        end
      end
      micropost = Micropost.create(content: message, user: postbot)
      micropost.extract_hashtags

    end

    def random_advice
      Rails.application.config.postbot_advice.sample
    end

    def user_not_authorized
      flash[:danger] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end

    def catch_not_found
      yield
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = "Record not found."
        redirect_to root_url
    end

end

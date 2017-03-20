class SessionsController < ApplicationController

  def new
    skip_authorization
  end

  def create
    skip_authorization
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if(user.activated?)
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or home_url
        #postbot_says random_advice
      else
        message  = "Account not activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    skip_authorization
    log_out if logged_in?
    if(params[:redirect] != "false")
      redirect_to root_url
    end
  end

end

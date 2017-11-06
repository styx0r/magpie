class StaticController < ApplicationController

  def about
    skip_authorization
  end

  def help
    authorize StaticController
  end

end

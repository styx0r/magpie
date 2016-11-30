class StaticController < ApplicationController

  def about
    skip_authorization
  end

  def help
    skip_authorization
  end

end

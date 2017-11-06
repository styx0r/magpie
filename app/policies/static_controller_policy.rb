class StaticControllerPolicy < ApplicationPolicy

  def help?
    !user.nil?
  end

end

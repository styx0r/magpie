class DashboardPolicy < ApplicationPolicy

  def index?
    !user.nil?
  end

  def micropost_feed?
    !user.nil?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

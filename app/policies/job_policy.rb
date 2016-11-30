class JobPolicy < ApplicationPolicy

  def images?
    !user.nil?
  end

  def create?
    !user.nil?
  end

  def running?
    !user.nil?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end

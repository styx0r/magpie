class SessionPolicy < ApplicationPolicy

  def destroy?
    !user.nil?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

class UserPolicy < ApplicationPolicy

  def destroy?
    user.admin? || (user.guest? && user == record)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

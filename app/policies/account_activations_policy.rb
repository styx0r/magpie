class AccountActivationsPolicy < ApplicationPolicy

  def edit?
    !record.activated?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

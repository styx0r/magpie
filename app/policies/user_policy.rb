class UserPolicy < ApplicationPolicy

  def hashtag_add?
    !user.nil?
  end

  def hashtag_delete?
    !user.nil?
  end

  def destroy?
    user.admin? || (user.guest? && user == record)
  end

  def edit?
    user == record
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end

class UserPolicy < ApplicationPolicy

  def delete_all_projects?
    !user.nil?
  end

  def hashtag_add?
    !user.nil? && user == record
  end

  def hashtag_delete?
    !user.nil? && user == record
  end

  def autocomplete?
    !user.nil?
  end

  def destroy?
    user.admin? || (user.guest? && user == record)
  end

  def edit?
    user == record
  end

  def update?
    user == record
  end

  def followers?
    !user.nil?
  end

  def following?
    !user.nil?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end

class UserPolicy < ApplicationPolicy

  def delete_all_projects?
    !user.nil?
  end

  def hashtag_add?
    !user.nil? && user == record
  end

  def set_right?
    !user.nil? && user.admin?
  end

  def hashtag_delete?
    !user.nil? && user == record
  end

  def autocomplete?
    !user.nil?
  end

  def destroy?
    user.admin? || user.right.user_delete? || (user.guest? && user == record)
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

  def index?
    !user.nil? && (user.admin || user.right.user_index)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end

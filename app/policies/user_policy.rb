class UserPolicy < ApplicationPolicy

  def delete_all_projects?
    !user.nil?
  end

  def hashtag_add?
    !user.nil? && user == record
  end

  def toggle_admin?
    (!user.nil? && user.admin?) && user != record
  end

  def toggle_right?
    (!user.nil? && user.admin?) && user != record
  end

  def hashtag_delete?
    !user.nil? && user == record
  end

  def autocomplete?
    !user.nil?
  end

  def destroy?
    user.admin? || (user.guest? && user == record) || user.right.user_delete?
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

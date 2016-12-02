class ModelPolicy < ApplicationPolicy

  def create?
    !user.nil? && (user.admin || user.right.model_add)
  end

  def new?
    !user.nil? && (user.admin || user.right.model_add)
  end

  def reupload?
    record.user == user || user.admin?
  end

  def update?
    record.user == user || user.admin?
  end

  def edit?
    record.user == user || user.admin?
  end

  def destroy?
    record.user == user || user.admin? || user.right.model_delete
  end

  def download?
    !user.nil?
  end

  def show?
    !user.nil?
  end

  def show_logo?
    !user.nil?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end

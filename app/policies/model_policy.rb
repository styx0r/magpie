class ModelPolicy < ApplicationPolicy

  def create?
    !user.nil?
  end

  def new?
    !user.nil?
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
    record.user == user || user.admin?
  end

  def download?
    !user.nil?
  end

  def show?
    !user.nil?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end

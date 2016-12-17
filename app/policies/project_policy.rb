class ProjectPolicy < ApplicationPolicy

  def index?
    !user.nil?
  end

  def destroy?
    user == record.user
  end

  def new?
    !user.nil?
  end

  def create?
    !user.nil?
  end

  def modelconfig? # definition of who can see a model config
    !user.nil? && !record.nil?
  end

  def modeldescription?
    !user.nil? && !record.nil?
  end

  def modelrevisions?
    !user.nil? && !record.nil?
  end

  def show?
    !user.nil? && (record.user == user || record.public)
  end

  def toggle_public?
    user == record.user
  end

  def delete_marked_jobs?
    user == record.user
  end

  def owner?
    user == record.user
  end

  class Scope < Scope
    def resolve
      scope.where(public: true)
    end
  end
end

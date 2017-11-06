class ProjectPolicy < ApplicationPolicy

  def index?
    !user.nil?
  end

  def destroy?
    !user.nil? && (user == record.user)
  end

  def new?
    !user.nil?
  end

  def create?
    !user.nil?
  end

  def edit? # no edit of projects is implemented
    false
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
    !user.nil? && (!user.guest && user == record.user)
  end

  def delete_marked_jobs?
    !user.nil? && (user == record.user)
  end

  def owner?
    !user.nil? && (user == record.user)
  end

  def job_create_toggle_public?
    !user.nil? && !user.guest
  end

  class Scope < Scope
    def resolve
      scope.where(public: true)
    end
  end
end

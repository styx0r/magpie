class JobPolicy < ApplicationPolicy

  def download?
    !user.nil?
  end

  def download_config?
    !user.nil?
  end

  def images?
    !user.nil?
  end

  def create?
    !user.nil? && (record.project.user == user)
  end

  def running?
    !user.nil?
  end

  def read_more?
    !user.nil?
  end

  def read_less?
    !user.nil?
  end

  def highlight?
    !user.nil? && (user == record.user)
  end

  def destroy?
    !user.nil? && (user == record.user)
  end

  def owner?
    !user.nil? && (user == record.user)
  end

  def show?
    !user.nil? && (user == record.user)
  end

  def edit?
    false
  end

  class Scope < Scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope.where(user: @user)
    end
  end
end

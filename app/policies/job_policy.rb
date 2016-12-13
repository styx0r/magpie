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
    user == record.user
  end

  def destroy?
    user == record.user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end

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
    !user.nil?
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

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end

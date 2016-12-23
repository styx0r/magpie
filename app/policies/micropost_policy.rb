class MicropostPolicy < ApplicationPolicy

  def create?
    !user.nil?
  end

  def destroy?
    !user.nil? && (user.microposts.include? record)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

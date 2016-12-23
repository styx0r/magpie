class RelationshipPolicy < ApplicationPolicy

  def create?
    !user.nil? && (user != record)
  end

  def destroy?
    !user.nil? && !user.guest
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

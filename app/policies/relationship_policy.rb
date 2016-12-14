class RelationshipPolicy < ApplicationPolicy

  def create?
    !user.nil?
  end

  def destroy?
    !user.nil?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

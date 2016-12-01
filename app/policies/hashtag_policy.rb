class HashtagPolicy < ApplicationPolicy

  def show?
    !user.nil?
  end

  def autocomplete?
    !user.nil?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end

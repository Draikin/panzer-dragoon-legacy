class LinkPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user
        return scope if user.administrator?
      end
      scope.joins(:category).where(categories: { publish: true })
    end
  end

  def show?
    return true if user && user.administrator?
    record.category.publish?
  end

  def permitted_attributes
    [
      :category_id,
      :name,
      :url,
      :partner_site,
      :description,
      contributor_profile_ids: [],
      tag_ids: []
    ]
  end
end

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, user

    if user.company_admin? || user.non_profit_admin?
      can :manage, user.managed_organization
    end

    can :read, Opportunity
    can :read, AssessmentReport, :user_id => user.id

    if user.coupon_uses.exists?(:assessment_report_id => nil) || user.assessment_purchases.exists?(:assessment_report_id => nil)
      can :create, AssessmentReport, :user_id => user.id
    end

    cannot :read, Opportunity,    :internal => true
    cannot :read, Recommendation, :internal => true

    can :manage, Organization,       :id => user.managed_organization_id
    can :manage, Organization do |org|
      org.group_admins.where(admin_id: user.id).exists?
    end
    can :manage, OrganizationReport, :organization_id => user.managed_organization_id
    can :read,  AssessmentPurchase,  :id => user.assessment_purchases.map(&:id)
    can :manage, Opportunity,        :id => user.opportunities.map(&:id) | user.owned_opportunities.map(&:id)


    if user.managed_organization
      can :read, Opportunity, :internal => true, :organization_id => user.managed_organization.id
    end

    can :manage, :all if user.role == "admin"

    can :edit, Facility if user.role == "member"

    can [ :update_many ], :user_licenses if user.role == "admin"

    can :create, FastContent if user.role == "admin"

  end
end

# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string(255)      default(""), not null
#  encrypted_password      :string(255)      default("")
#  reset_password_token    :string(255)
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0)
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string(255)
#  last_sign_in_ip         :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  managed_organization_id :integer
#  name                    :string(255)
#  provider                :string(255)
#  uid                     :string(255)
#  location                :string(255)
#  description             :text
#  headline                :string(255)
#  industry                :string(255)
#  organization_id         :integer
#  access_key              :string(255)
#  access_secret           :string(255)
#  avatar                  :string(255)
#  role                    :string(255)      default("member"), not null
#  interest_ids            :integer
#  instance_url            :string(255)
#  refresh_token           :string(255)
#  old_salesforce_id       :string(255)
#  encrypted_salesforce_id :string(255)
#  encrypted_access_key    :string(255)
#  encrypted_uid           :string(255)
#  active_license          :boolean
#  licensed_date           :date
#  mute_notifications      :boolean          default(FALSE)
#  invitation_token        :string(255)
#  invitation_sent_at      :datetime
#  invitation_accepted_at  :datetime
#  invitation_limit        :integer
#  invited_by_id           :integer
#  invited_by_type         :string(255)
#  invitation_created_at   :datetime
#  via_shopify             :boolean
#  hub_member              :boolean
#

require 'role_model'

class User < ActiveRecord::Base
  include AutomakeOrganization # FIXME: (cmhobbs+tyreldenison) clear out the spaghetti here

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :secure_validatable,
         :omniauthable, omniauth_providers: %i[linkedin developer salesforce]

  ROLES = %w[admin facilitator member].freeze

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  acts_as_liker

  def self.attribute_whitelist
    [
      :active_license,
      :avatar_cache,
      :avatar,
      :competency_ids,
      :current_password,
      :description,
      :email,
      :headline,
      :image,
      :industry,
      :instance_url,
      { interest_ids: [] },
      :licensed_date,
      :location,
      :mute_notifications,
      :name,
      :organization_id,
      :passion_ids,
      :password_confirmation,
      :password,
      :provider,
      :refresh_token,
      :remember_me,
      :uid,
      :updated_at,
      :via_shopify
    ] + AutomakeOrganization.permitted_whitelist
  end

  def self.permitted(params)
    params.permit(user: attribute_whitelist)
  end

  attr_encrypted :salesforce_id, key: KEY['salesforce']
  attr_encrypted :access_key, key: KEY['salesforce']
  attr_encrypted :uid, key: KEY['salesforce']

  belongs_to :managed_organization, class_name: 'Organization'
  belongs_to :organization

  has_and_belongs_to_many :mentorship_circles
  has_and_belongs_to_many :collaboration_circles
  has_and_belongs_to_many :opportunities
  has_and_belongs_to_many :opportunity_applications

  # FIXME: (cmhobbs+tyreldenison) the User model knows too much
  has_many :competencies_users
  has_many :competencies, through: :competencies_users
  has_many :assessment_reports
  has_many :best_practices
  has_many :coupon_uses
  has_many :assessment_purchases
  has_many :single_user_license_purchases
  has_many :user_license_purchases
  has_many :opportunity_purchases
  has_many :recommendations
  has_many :users_interests
  has_many :testimonials
  has_many :interests, through: :users_interests
  has_many :pac_members
  has_many :fast_content
  has_many :comments
  has_many :points
  has_many :badges
  has_many :certifications
  has_many :recommendation_applications
  has_many :opportunity_applications
  has_many :mentor_action_plans
  has_many :coach_action_plans
  has_many :volunteer_action_plans
  has_many :inquiries

  has_many :user_groups, foreign_key: 'member_id'
  has_many :groups, through: :user_groups

  has_many :group_admins, foreign_key: 'admin_id'
  has_many :managed_groups, through: :group_admins

  scope :receives_email, -> { where(mute_notifications: false) }

  validates_uniqueness_of :uid, scope: :provider, allow_nil: true

  mount_uploader :avatar, AvatarUploader

  after_create :email_new_user

  before_create :activate_license

  def incomplete_profile?
    sign_in_count % 3 == 0
    description.nil?
    organization_id.nil?
    interests.empty?
    location.nil?
    name.nil?
  end

  def all_opportunities
    @opp  = opportunities
    @opp2 = Opportunity.joins(:opportunity_applications).where('opportunity_applications.user_id' => id)
    @opp3 = @opp + @opp2
  end

  # NOTE: (cmhobbs) #all_groups and #unique_groups are used because the UserGroup
  #      object was repurposed and now requires UserGroups for a given User to
  #      be unique.  This needs re-arch.
  #
  # FIXME (cmhobbs) wrap #all_groups and #unique_groups in tests.
  def all_groups
    groups + [organization]
  end

  def unique_groups
    all_groups.uniq.compact
  end

  # find related meta_organizations
  def associated_groups
    meta_groups   = unique_groups.map(&:meta_group).uniq.compact
    organizations = meta_groups.map(&:organizations).flatten.uniq.compact
    organizations.delete_if { |group| unique_groups.include?(group) }
  end

  # FIXME: (cmhobbs) this is pretty heavy handed.  User shouldn't know this
  #       much about related objects.
  #
  # Public: Aggregate all users in associated groups
  #
  # Examples
  #
  #   User.first.related_groups_users
  #   # => [ <#User id: 1, ... >, <#User id: 2, ... > ]
  #
  # Returns an Array representing the related User objects.
  def related_groups_users
    [].tap do |related_users|
      all_groups.each do |group|
        related_users << group.all_users.reject { |group_user| group_user == self }
      end
    end.flatten.uniq
  end

  def all_pacs
    @pac = Pac.where(owner_id: id)
    @pac2 = Pac.joins(:pac_members).where('pac_members.member_id' => id)
    @pac3 = @pac + @pac2
  end

  def email_new_user
    Notifier.new_user_welcome_email(self).deliver_now unless via_shopify
  end

  def activate_license
    self.active_license = true
    self.licensed_date = Time.now
    nil
  end

  def taken_assessment?
    assessment_reports.length > 0
  end

  def to_linkedin_client
    LinkedinClient.new(self)
  end

  def connections(options = {})
    to_linkedin_client.connections(options.fetch(:start), 16)
  end

  def owned_recommendations
    Recommendation.where(user_id: id)
  end

  def owned_opportunities
    Opportunity.where(owner_id: id)
  end

  def opportunities_with_feedback
    Opportunity.with_feedback.where(owner_id: id)
  end

  def current_opportunities
    now = Time.now
    owned_opportunities.where('end_year IS NULL OR (end_year > :year) OR (end_year = :year AND end_month >= :month)',
                              year: now.year, month: now.month)
  end

  def past_opportunities
    now = Time.now
    owned_opportunities.where('end_year < :year OR (end_year = :year AND end_month < :month)', year: now.year,
                                                                                               month: now.month)
  end

  def active_recommendations
    now = Time.now
    owned_recommendations.where(
      'end_year IS NULL OR (end_year > :year) OR (end_year = :year AND end_month >= :month)', year: now.year, month: now.month
    )
  end

  def deactive_recommendations
    now = Time.now
    owned_recommendations.where('end_year < :year OR (end_year = :year AND end_month < :month)', year: now.year,
                                                                                                 month: now.month)
  end

  # Takes in an auth hash and returns the changes
  # FIXME (cmhobbs+tyreldenison) extract as much logic as possible here
  def self.find_or_create_from_auth_hash(auth_hash, current_user = nil)
    user = current_user ||
           User.where(
             provider: auth_hash.provider,
             uid: auth_hash.uid
           ).first ||
           User.where(email: auth_hash.info.email).first ||
           User.import(auth_hash)

    return [] if user.nil? # No user found

    if auth_hash.provider == 'salesforce'
      user.uid = auth_hash.uid
      user.provider = auth_hash.provider
      user.access_key = auth_hash.credentials.token
      user.instance_url = auth_hash.credentials.instance_url
      user.salesforce_id = auth_hash.extra.user_id
    elsif auth_hash.provider == 'linkedin'
      user.uid = auth_hash.uid
      user.provider = auth_hash.provider
      user.access_key = auth_hash.extra.access_token.token
      user.access_secret = auth_hash.extra.access_token.secret
      unless !user.description.nil? && user.description.length > 0
        user.description = user.to_linkedin_client.client.profile(fields: %w[summary]).summary
      end
    end

    user.name ||= auth_hash.info.name

    user.save! if user.persisted?

    changeset = {}

    auth_hash.info.each do |k, v|
      if user[k] != v && selectable_attributes.include?(k)
        changeset[k] = v
      else
        next
      end
    end

    [user, changeset]
  end

  def self.import(auth_hash)
    user = User.new(attributes_to_user_hash(auth_hash))

    if auth_hash.provider == 'linkedin'
      response = Net::HTTP.get_response(URI(auth_hash.info.image))
      Tempfile.new(auth_hash.uid.to_s)

      File.open(avatar.path + '.png', 'wb') do |f|
        f.write response.body
      end

      user.avatar = File.open(avatar.path + '.png')
      avatar.unlink
    end

    user.save!
    user
  end

  def self.attributes_to_user_hash(auth_hash)
    attributes = {
      'email' => auth_hash.info.email,
      'password' => Devise.friendly_token[0, 20]
    }

    %w[name location headline].each do |key|
      attributes[key] = auth_hash.info.public_send(key)
    end

    attributes
  end

  # FIXME: (cmhobbs+tyreldenison) make this a constant or a model
  def self.selectable_attributes
    %w[name location description headline industry].freeze
  end

  # NOTE: (cmhobbs+tyrendenison) verify usage of this set of methods
  def non_profit_admin?
    managed_organization.try(:type) == 'NonProfit'
  end

  def company_admin?
    managed_organization.try(:type) == 'Company'
  end

  def admin?
    non_profit_admin? || company_admin?
  end

  def has_child?(child)
    children = send(child.class.name.downcase.pluralize)
    children.exists?(id: child.id)
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |user|
        csv << user.attributes.values_at(*column_names)
      end
    end
  end

  # NOTE: (cmhobbs) we don't check to see if a BadgeType is awardable.
  #      this may prove troublesome in the future.
  #
  # FIXME (cmhobbs) we're passing badge_type_id around quite a bit...
  #       this may require a separate class at some point.
  def award_badge(badge_type_id)
    if badges.where(badge_type_id: badge_type_id).exists?
      false
    else
      badge = badges.create(badge_type_id: badge_type_id, year: Time.now.year)
      Notifier.delay.new_badge_email(self, badge)
      # NOTE: (cmhobbs) spam all the users! \o/
      # BadgeWorker.perform_async(badge.id)
    end
  end

  def has_current_badge?(badge_type_id)
    badges_for_current_year.map(&:badge_type_id).include?(badge_type_id)
  end

  private

  def badges_for_current_year
    badges.where(year: Time.now.year)
  end
end

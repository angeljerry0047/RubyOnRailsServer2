# == Schema Information
#
# Table name: pacs
#
#  id                        :integer          not null, primary key
#  complete                  :boolean
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  description               :text
#  webcast_id                :string(255)
#  webcast_facilitator_id    :string(255)
#  opportunity_type_id       :integer
#  category                  :string(255)
#  learning_objectives       :text
#  start_date                :datetime
#  deadline_date             :datetime
#  start_time                :string(255)
#  end_time                  :string(255)
#  max_students              :integer
#  min_students              :integer
#  facility_id               :integer
#  owner_id                  :integer
#  title                     :string(255)
#  city                      :string(255)
#  state                     :string(255)
#  organization_id           :integer
#  in_progress               :boolean
#  approval_code             :string(255)
#  is_public                 :boolean          default(FALSE)
#  got_point                 :boolean          default(FALSE)
#  approval_status           :boolean          default(FALSE)
#  online_info               :text
#  best_practice_category_id :integer
#

class Pac < ActiveRecord::Base
  include ActiveModel::Dirty
  include PgSearch::Model
  include AutomakeFacility

  def self.attribute_whitelist
    %i[
      approval_code
      approval_status
      best_practice_category_id
      city
      complete
      deadline_date
      description
      end_month
      end_time
      end_year
      facility_id
      got_point
      in_progress
      is_public
      learning_objectives
      max_students
      min_students
      online_info
      opportunity_type_id
      organization_id
      owner_id
      start_date
      start_time
      state
      title
      webcast_facilitator_id
      webcast_id
    ] + AutomakeFacility.permitted_whitelist
  end

  def self.permitted(params)
    params.permit(pac: attribute_whitelist)
  end

  has_many :pac_members, dependent: :destroy
  has_many :comments, as: :commentable

  belongs_to :organization
  belongs_to :best_practice_category
  belongs_to :facility
  belongs_to :webcast_facilitator
  belongs_to :opportunity_type
  belongs_to :owner, class_name: 'User'

  after_create :notify_approver, unless: 'not_needed'

  scope :is_public, -> { where(is_public: true).where(complete: true) }
  scope :view_public, -> { where(is_public: true).where(complete: true).where(approval_status: true) }
  scope :with_category, lambda { |category|
    where(best_practice_category_id: category)
      .order('created_at DESC')
  }

  def location
    [city, state].select(&:present?).join(', ')
  end

  def notify_approver
    Notifier.new_pac_registration_approval(self).deliver_now!
    Notifier.new_pac_registration_owner(self).deliver_now!
  end

  def not_needed
    !facility || !facility.approval_name? || !facility.approval_mail?
  end

  def later_time
    start_date + 10.days
  end
end

# == Schema Information
#
# Table name: opportunities
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  internal                  :boolean
#  organization_id           :integer
#  industry_id               :integer
#  start_year                :integer
#  start_month               :integer
#  end_year                  :integer
#  end_month                 :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  min_hour                  :integer
#  max_hour                  :integer
#  description               :text
#  quantity                  :integer
#  city                      :string(255)
#  state                     :string(255)
#  department                :string(255)
#  owner_id                  :integer
#  learning_objectives       :text
#  start_date                :datetime
#  deadline_date             :datetime
#  start_time                :string(255)
#  end_time                  :string(255)
#  max_students              :integer
#  min_students              :integer
#  facility_id               :integer
#  opportunity_category_id   :integer
#  approval_status           :boolean          default(FALSE)
#  approval_code             :string(255)
#  opportunity_type_id       :integer
#  webcast_id                :string(255)
#  webcast_facilitator_id    :string(255)
#  online_info               :text
#  best_practice_category_id :integer
#  meeting_time              :string(255)
#  location                  :text
#  lonlat                    :spatial          point, 4326
#

# XXX (cmhobbs) rails should handle this for us
require 'points'
include Points

class Opportunity < ActiveRecord::Base
  include ActiveModel::Dirty
  include PgSearch::Model
  include AutomakeOrganization
  include AutomakeFacility

  pg_search_scope :search_full_text, against: {
    title: 'A',
    description: 'B'
  }, using: [:tsearch]

  def self.attribute_whitelist
    %i[
      approval_code
      approval_status
      best_practice_category_id
      category
      city
      competency_ids
      deadline_date
      department
      description
      developed_competencies
      end_month
      end_time
      end_year
      facility_id
      industry_id
      internal
      learning_objectives
      location
      lonlat
      max_hour
      max_students
      meeting_time
      min_hour
      min_students
      online_info
      opportunity_category_id
      opportunity_type_id
      organization_id
      owner_id
      quantity
      start_date
      start_month
      start_time
      start_year
      state
      title
      webcast_facilitator_id
      webcast_id
    ] + AutomakeFacility.permitted_whitelist
  end

  def self.permitted(params)
    params.permit(opportunity: attribute_whitelist)
  end

  validates :start_year,  numericality: { greater_than: 1899, less_than: (Date.today.year + 1) }, allow_nil: true
  validates :end_year,    numericality: { greater_than: 1899 }, allow_nil: true
  validates :start_month, numericality: { greater_than: 0, less_than: 13 }, allow_nil: true
  validates :end_month,   numericality: { greater_than: 0, less_than: 13 }, allow_nil: true

  belongs_to :organization
  belongs_to :industry
  belongs_to :facility
  belongs_to :opportunity_category
  belongs_to :opportunity_type
  belongs_to :webcast_facilitator
  belongs_to :form_of_learning
  belongs_to :best_practice_category

  has_many :developed_competencies
  has_many :competencies, through: :developed_competencies

  has_many :feedbacks
  has_many :testimonials

  has_many :opportunity_applications
  has_many :applicants, through: :opportunity_applications, source: :user
  belongs_to :owner, class_name: 'User'

  has_and_belongs_to_many :users

  after_create :notify_approver,     unless: :not_owned
  after_create :award_teacher_point, unless: :not_owned
  after_create :notify_users

  def not_owned
    owner_id.blank? || opportunity_type_id.nil?
  end

  def notify_approver
    Notifier.new_opportunity_registration_approval(self).deliver_now!
  end

  def notify_users
    OpportunityWorker.perform_async(id)
  end

  # XXX (cmhobbs+tyreldension) rethink use of associations here
  scope :external,  -> { where(internal: false) }
  scope :mentor,    -> { where(opportunity_category_id: [4, 15, 17]) }
  scope :coach,     -> { where(opportunity_category_id: [8, 14, 10, 16, 1, 18]) }
  scope :advisor,   -> { where(opportunity_category_id: [4, 15, 17, 8, 14, 10, 16, 1, 18]) }
  scope :intern,    -> { where(opportunity_category_id: [6, 19]) }
  scope :speaker,   -> { where(opportunity_category_id: [2, 9, 7, 20]) }
  scope :volunteer, -> { where(opportunity_category_id: [5, 21]) }

  def sort_name
    opportunity_category.name
  end

  scope :with_competencies, lambda { |competencies|
    joins(:developed_competencies).where('developed_competencies.competency_id' => Array.wrap(competencies).map(&:id))
  }

  scope :within_organization, lambda { |organization|
    where(organization_id: organization.id)
  }

  scope :with_category, lambda { |category|
    where(opportunity_category_id: category.id)
  }

  scope :with_bp_category, lambda { |category|
    where(best_practice_category_id: category)
      .order('created_at DESC')
  }

  scope :trending, lambda {
    where(':now <= created_at', now: DateTime.now - 30.day)
  }

  scope :with_feedback, lambda {
    joins('INNER JOIN feedbacks ON feedbacks.opportunity_id = opportunities.id').uniq
  }

  scope :past_experience, -> { where(owner_id: nil) }

  scope :non_historical, lambda {
    joins('LEFT JOIN opportunities_users ON opportunities_users.opportunity_id = opportunities.id').where('opportunities_users.user_id' => nil)
  }

  scope :non_historical_active, lambda {
    now = Time.now.in_time_zone('Central Time (US & Canada)')
    where('opportunities.owner_id IS NOT NULL')
      .where('(end_year IS NULL AND approval_status = :status AND deadline_date >= :deadline)
    OR (end_year > :year)
    OR (end_year = :year AND end_month >= :month)',
             year: now.year, month: now.month, status: true, deadline: now - 60.days)
  }

  scope :historical, lambda {
    joins('LEFT JOIN opportunities_users ON opportunities_users.opportunity_id = opportunities.id').where('opportunities_users.user_id IS NOT NULL')
  }

  scope :completed_yesterday, -> { where('DATE(start_date) = ?', Date.yesterday) }

  # XXX (cmhobbs) deprecated
  # scope :within, -> (zipcode, miles) {
  #   miles_to_meters = ->(miles) {
  #     (Rational(2305843009213693952, 1432781670635113) * miles.to_i).to_f.round
  #   }
  #
  #   zip = Zip.find_or_create_by(code: zipcode)
  #
  #   where(
  #     "ST_DWithin(opportunities.lonlat, :centroid, :meters)",
  #     :centroid => zip.lonlat,
  #     :meters => miles_to_meters.(miles))
  # }

  # XXX (cmhobbs) rgeo is broke in rails 4.2.  this should be moved to
  #     an initializer because you can't set column specific geo
  #     factory properties any longer
  # self.rgeo_factory_generator = RGeo::Geos.factory_generator(:srid => 4326)
  # set_rgeo_factory_for_column(:lonlat, RGeo::Geographic.spherical_factory(:srid => 4326))

  def self.selectable_time_ranges
    time_ranges = [
      { min_hour: nil, max_hour: 1 },
      { min_hour: 1, max_hour: 5 },
      { min_hour: 5, max_hour: 10 },
      { min_hour: 10, max_hour: 40 },
      { min_hour: 40, max_hour: nil }
    ]

    time_ranges.map do |tr|
      commitment = Opportunity.new(tr).weekly_commitment
      [
        commitment,
        commitment,
        { 'data-min-hour': tr.fetch(:min_hour),
          'data-max-hour': tr.fetch(:max_hour) }
      ]
    end
  end

  def external?
    !internal?
  end

  def location
    [city, state].select(&:present?).join(', ')
  end

  def weekly_commitment
    suffix = ' hours per week'

    if min_hour && max_hour
      [min_hour, max_hour].join(' - ') + suffix
    elsif min_hour
      "More than #{min_hour} hours per week"
    elsif max_hour
      "Less than #{max_hour} hours per week"
    else
      'No time commitment'
    end
  end

  def send_feedback_request
    users.each do |user|
      Notifier.skill_completed_email(self, user).deliver_now!
    end
  end

  def gets_a_point
    feedbacks.count > 2 && (((feedbacks.sum(:q1) + feedbacks.sum(:q2) + feedbacks.sum(:q3)) / 3).to_f / feedbacks.count).to_f > 3
  end

  # FIXME: (cmhobbs+tyreldenison) hello freshness, my old friend
  def freshness
    @date   = created_at.to_date
    @date40 = (Date.today - 40.days..Date.today - 31.days)
    @date30 = (Date.today - 30.days..Date.today - 21.days)
    @date20 = (Date.today - 20.days..Date.today - 11.days)
    @date10 = (Date.today - 10.days..Date.today - 6.days)
    @date5  = (Date.today - 5.days..Date.today - 1.day)

    if @date40.cover?(@date)
      1
    elsif @date30.cover?(@date)
      2
    elsif @date20.cover?(@date)
      3
    elsif @date10.cover?(@date)
      4
    elsif @date5.cover?(@date)
      5
    elsif @date == Date.today
      10
    else
      0
    end
  end

  def trending_points
    @trend = freshness
  end

  private

  # XXX (cmhobbs) this is painful.  OpportunityCategories needs to be
  #     refactored with the relaunch.
  def award_teacher_point
    Points.give_them_an_teacher_point(User.find(owner_id)) if opportunity_category.name == 'Internship'
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id               :integer          not null, primary key
#  type             :string(255)
#  title            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  description      :text
#  company_size_min :integer
#  company_size_max :integer
#  company_type     :string(255)
#  website          :string(255)
#  industry_id      :integer
#  operating_status :string(255)
#  year_founded     :integer
#  address1         :string(255)
#  address2         :string(255)
#  city             :string(255)
#  state            :string(255)
#  zipcode          :integer
#  oid              :string(255)
#  provider         :string(255)
#  avatar           :string(255)
#  banner           :string(255)
#  active_license   :boolean
#  salesforce_id    :string(255)
#  has_chatter      :boolean
#  user_licenses    :integer
#  int_description  :text
#  domain           :string(255)
#  meta_group_id    :integer
#

class Organization < ActiveRecord::Base
  self.inheritance_column = 'type_t'

  def self.permitted(params)
    organization_params = [
      :title,
      :type,
      :description,
      :company_size_min,
      :company_size_max,
      :company_type,
      :website,
      :industry_id,
      :operating_status,
      :year_founded,
      :address1,
      :address2,
      :city,
      :state,
      :zipcode,
      :avatar,
      :avatar_cache,
      :banner,
      :banner_cache,
      :active_license,
      :salesforce_id,
      :has_chatter,
      :user_licenses,
      :license_id,
      :bp_categories,
      :int_description,
      :best_practice_category_id,
      :slug
    ]

    params.permit(organization: organization_params)
  end

  after_validation :set_slug, only: [:create, :update]

  validates_presence_of :title
  validates_uniqueness_of :title, :case_sensitive => false, :allow_blank => false

  has_many :opportunities
  has_many :user_license_purchases
  has_many :fast_content
  has_many :organizations_best_practice_categories
  has_many :best_practice_categories, :through => :organizations_best_practice_categories
  accepts_nested_attributes_for :best_practice_categories, update_only: true
  has_many :inquiries
  has_many :best_practices
  has_many :departments

  has_many :users
  has_many :pacs
  has_many :mentorship_circles
  has_many :collaboration_circles
  
  has_many :members, :through => :user_groups
  has_many :user_groups, :foreign_key => 'group_id'

  has_many :admins, :through => :group_admins
  has_many :group_admins, :foreign_key => 'group_id'

  accepts_nested_attributes_for :members, :allow_destroy => true 

  belongs_to :industry

  belongs_to :meta_group

  mount_uploader :avatar, AvatarUploader
  mount_uploader :banner, BannerUploader

  scope :s2pcompanies, -> { where(:active_license => true).order(:title) }

  scope :with_category, -> category {
    where(:best_practice_category_id => category).
    order('created_at DESC')
  }

  def self.company_size_ranges
    [
      [nil,1],
      [2,10],
      [11,50],
      [51,200],
      [201,500],
      [501,1000],
      [1001,5000],
      [5001,10000],
      [10001, nil]
    ]
  end

  def self.company_sizes
    company_size_ranges.map do |range|
      convert_range(range)
    end
  end

  def all_users
    (members + users).uniq
  end 

  def bp_categories=(bp_categories)
    bp_categories.each do |categories|
      if categories[:id].blank?
        unless categories[:title].blank?
          best_practice_categories.build(categories)
        end
      else
        best_practice_category = best_practice_categories.detect { |bp| bp.id == categories[:id].to_i}
        best_practice_category.attributes = categories
      end
    end
  end

  def available_licenses
    self.user_licenses - self.users.where(:active_license => true).count
  end

  def company_website
    if (website =~ /http:\/\//) == 0
      website
    else
      "http://" + website
    end
  end

  def described?
    !description.blank?
  end

  def employee_count_range
    range = [company_size_min, company_size_max]
    self.class.convert_range(range)
  end

  def banner_path
    if banner.present?
      banner
    else
      nil
    end
  end

  def avatar_path
    if avatar.present?
      avatar
    else
      "missing-avatar1.png"
    end
  end

  def manager
    if User.exists?(:managed_organization_id => self.id)
      User.where(:managed_organization_id => self.id).first
    else
      raise ActiveRecord::RecordNotFound, "There is no manager for Organization:#{self.id}"
    end
  end

  def website_url
    if website.blank?
      ""
    elsif website.to_s =~ /^http(s)?:\/\//
      website
    else
      "http://" + website
    end
  end

  private

  def self.convert_range(range)
    if range[0].nil?
      'myself only'
    elsif range[1].nil?
      "#{range[0]}+"
    else
      range.join('-')
    end
  end


  def set_slug
    self.slug = title.to_s.parameterize
  end
end

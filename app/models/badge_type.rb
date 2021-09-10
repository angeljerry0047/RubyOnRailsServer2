# == Schema Information
#
# Table name: badge_types
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  image_url       :string(255)
#  certificate_url :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  points          :integer
#  points_req      :integer
#  awardable       :boolean
#

# XXX (cmhobbs) image_url is deprecated and will be removed.
#     use #current_image_filename or Badge#image_filename
class BadgeType < ActiveRecord::Base
  def self.permitted(params)
    badge_whitelist = [:certificate_url, :name, :points, :points_req]
    params.permit(badge_type: badge_whitelist)
  end

  scope :achievable, -> { where(awardable: (false || nil)) }
  scope :awardable,  -> { where(awardable: true) }

  has_many :badges
  has_many :points

  # Public: Return a String representation of the current year's badge
  # image filename for use in image tag helpers.
  #
  # Examples
  #
  #   BadgeType.first.current_image_filename
  #   # => networker2015.png
  #
  # Returns a String representing an image filename.
  def current_image_filename
    # FIXME (cmhobbs) surely ActiveSupport can do something cute like this
    "#{name.downcase.gsub(' ', '')}#{Time.now.year}.png"
  end
end

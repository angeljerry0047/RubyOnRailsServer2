# == Schema Information
#
# Table name: badges
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  badge_type_id :integer
#  year          :integer
#
class Badge < ActiveRecord::Base

  def self.permitted(params)
    badge_whitelist = [:badge_type_id, :user_id, :year]
    params.permit(badge: badge_whitelist)
  end

  belongs_to :user
  belongs_to :badge_type

  scope :awardable, -> { joins(:badge_type).where("badge_types.awardable = true") }

  # Public: Return an iamge filename for the related BadgeType for
  # use with image tag helpers
  #
  # mobile - The Boolean option for a mobile image filename
  #
  # Examples
  #
  #   image_filename
  #   # => 'collaborator2015.png'
  #
  #   image_filename(true)
  #   # => 'collaborator2015mobile.png'
  #
  # Returns a String representing the related BadgeType image filename
  #
  # NOTE (cmhobbs) this expects badge type image assets to follow this
  #      naming convention:
  #
  #      desktop:  downcasebadgetype2015.png
  #      mobile    downcasebadgetype2015mobile.png
  #
  # FIXME (cmhobbs) move this to a presenter
  def image_filename(mobile = false)
    mobile ? mobile_image_filename : desktop_image_filename
  end

  # XXX (cmhobbs) deprecated.  use #image_filename
  def badge_image
    badge_type.image_url + year.to_s + ".png"
  end

  # XXX (cmhobbs) deprecated.  use #image_filename
  def mobile_badge_image
    badge_type.image_url + year.to_s + "mobile.png"
  end

  def small_badge_image
    badge_type.image_url + year.to_s + "small.png"
  end

  private

  def desktop_image_filename
    "#{badge_type.name.downcase.gsub(' ', '')}#{year}.png"
  end

  def mobile_image_filename
    desktop_image_filename.split('.').join('mobile.')
  end

end

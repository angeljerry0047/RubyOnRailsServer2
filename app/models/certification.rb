# == Schema Information
#
# Table name: certifications
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  certification_type_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Certification < ActiveRecord::Base

  def self.permitted(params)
    cerification_whitelist = [:certification_type_id, :user_id]
    params.permit(certification: cerification_whitelist)
  end

  belongs_to :certification_type
  belongs_to :user

  scope :awardable, -> { joins(:certification_type).where("certification_types.awardable = true") }

  # Public: Return an iamge filename for the related CertificationType for
  # use with image tag helpers
  #
  # mobile - The Boolean option for a mobile image filename
  #
  # Examples
  #
  #   image_filename
  #   # => 'associate.png'
  #
  #   image_filename(true)
  #   # => 'associatemobile.png'
  #
  # Returns a String representing the related CertificationType image filename
  #
  # NOTE (cmhobbs) this expects certification type image assets to follow this
  #      naming convention:
  #
  #      desktop:  downcasecertificationtype.png
  #      mobile    downcasecertificationtypemobile.png
  #
  # FIXME (cmhobbs) move this to a presenter
  def image_filename(mobile = false)
    mobile ? mobile_image_filename : desktop_image_filename
  end

  private

  def desktop_image_filename
    "#{certification_type.name.downcase.gsub(' ', '')}certification.png"
  end

  def mobile_image_filename
    desktop_image_filename.split('.').join('mobile.')
  end

end

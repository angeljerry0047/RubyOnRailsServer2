# frozen_string_literal: true

# == Schema Information
#
# Table name: certification_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  awardable  :boolean
#

class CertificationType < ActiveRecord::Base
  def self.permitted(params)
    certification_whitelist = %i[name awardable]
    params.permit(certification: certification_whitelist)
  end

  has_many :certifications

  scope :awardable, -> { where(awardable: true) }

  # Public: Return a String representation of the certification
  # image filename for use in image tag helpers.
  #
  # Examples
  #
  #   CertificationType.first.current_image_filename
  #   # => associate.png
  #
  # Returns a String representing an image filename.
  def current_image_filename
    "#{name.downcase.gsub(' ', '')}certification.png"
  end
end

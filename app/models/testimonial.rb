# == Schema Information
#
# Table name: testimonials
#
#  id             :integer          not null, primary key
#  opportunity_id :integer
#  creator_id     :integer
#  approved       :boolean
#  body           :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Testimonial < ActiveRecord::Base
  def self.permitted(params)
    testimonial_whitelist = [:approved, :body, :creator_id, :opportunity_id]

    params.permit(testimonial: testimonial_whitelist)
  end

  validates_presence_of :body

  belongs_to :opportunity
  belongs_to :creator, :class_name => "User"

  scope :approved, -> { where(:approved => true) }
end

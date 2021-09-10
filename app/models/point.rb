# == Schema Information
#
# Table name: points
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  badge_type_id :integer
#  year          :integer
#

class Point < ActiveRecord::Base
  def self.permitted(params)
    point_whitelist = [:badge_type_id, :user_id, :year]
    params.permit(point: point_whitelist)
  end

  belongs_to :user
  belongs_to :badge_type

  # XXX (cmhobbs) this is terrifying.  quit checking for hard coded data!
  scope :ideator,      -> { where(:badge_type_id => 1) }
  scope :mentor,       -> { where(:badge_type_id => 2) }
  scope :teacher,      -> { where(:badge_type_id => 3) }
  scope :stakeholder,  -> { where(:badge_type_id => 4) }
  scope :collaborator, -> { where(:badge_type_id => 6) }
end

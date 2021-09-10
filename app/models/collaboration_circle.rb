# == Schema Information
#
# Table name: collaboration_circles
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  description     :text
#  start_date      :datetime
#  end_date        :datetime
#  min_attendees   :integer
#  max_attendees   :integer
#  expectations    :text
#  location_option :string(255)
#  location        :text
#  organization_id :integer
#  user_id         :integer
#  meeting_time    :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  facilitator_id  :integer
#

class CollaborationCircle < ActiveRecord::Base
  def self.permitted(params)
    collaboration_circle_whitelist = [
      :description,
      :end_date,
      :expectations,
      :location,
      :location_option,
      :max_attendees,
      :min_attendees,
      :start_date,
      :meeting_time,
      :title,
      :facilitator_id,
      :organization_id
    ]

    params.permit(collaboration_circle: collaboration_circle_whitelist)
  end

  has_and_belongs_to_many   :users
  
  belongs_to :organization
  belongs_to :facilitator, :class_name => "User"

  has_many :comments, :as => :commentable

  acts_as_likeable
  
  def includes_user?(user_id)
    user_ids.include?(user_id)
  end

  def full?
    max_attendees == users.count
  end

  def gets_a_point
    comments.count > 0 and likers(User).count > 2
  end

  def likes
    likers(User).count
  end
  
end

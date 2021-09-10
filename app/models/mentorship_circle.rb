# == Schema Information
#
# Table name: mentorship_circles
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  description     :text
#  start_date      :datetime
#  end_date        :datetime
#  min_mentees     :integer
#  max_mentees     :integer
#  expectations    :text
#  location_option :string(255)
#  location        :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#  mentor_id       :integer
#  user_id         :integer
#  meeting_time    :string(255)
#  mctype          :string(255)
#  numsessions     :integer
#  frequency       :string(255)
#

class MentorshipCircle < ActiveRecord::Base
  def self.permitted(params)
    mentorship_circle_whitelist = [
      :description,
      :end_date,
      :expectations,
      :location,
      :location_option,
      :max_mentees,
      :min_mentees,
      :start_date,
      :meeting_time,
      :title,
      :mentor_id,
      :organization_id,
      :mctype,
      :numsessions,
      :frequency
    ]

    params.permit(mentorship_circle: mentorship_circle_whitelist)
  end

  has_and_belongs_to_many   :users
  
  belongs_to :organization
  belongs_to :mentor, :class_name => "User"

  has_many :comments, :as => :commentable

  acts_as_likeable
  
  def includes_user?(user_id)
    user_ids.include?(user_id)
  end

  def full?
    max_mentees.present? && users.count >= max_mentees
  end

  def gets_a_point
    comments.count > 0 and likers(User).count > 2
  end

  def likes
    likers(User).count
  end
  
end

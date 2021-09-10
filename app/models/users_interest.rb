# == Schema Information
#
# Table name: users_interests
#
#  user_id     :integer
#  interest_id :integer
#

class UsersInterest < ActiveRecord::Base
  belongs_to :user
  belongs_to :interest
end

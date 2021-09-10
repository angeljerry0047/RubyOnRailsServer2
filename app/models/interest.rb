# == Schema Information
#
# Table name: interests
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Interest < ActiveRecord::Base
  def self.permitted(params)
    interest_whitelist = [:name, :parent_id]
    params.permit(interest: interest_whitelist)
  end
  
  validates_uniqueness_of :name
  has_many :users_interests
  has_many :users, :through => :users_interests

  scope :alphabetical, -> { order(:name) }
end

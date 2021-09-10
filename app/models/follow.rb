# == Schema Information
#
# Table name: follows
#
#  id              :integer          not null, primary key
#  follower_type   :string(255)
#  follower_id     :integer
#  followable_type :string(255)
#  followable_id   :integer
#  created_at      :datetime
#

class Follow < Socialization::ActiveRecordStores::Follow
end

# == Schema Information
#
# Table name: invites
#
#  id           :integer          not null, primary key
#  oid          :string(255)
#  first_name   :string(255)
#  last_name    :string(255)
#  provider     :string(255)
#  completed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  email        :string(255)
#

class Invite < ActiveRecord::Base
  def self.permitted(params)
    invite_whitelist = [
      :completed_at,
      :first_name,
      :last_name,
      :oid,
      :provider,
      :user_id,
      :email
    ]

    params.permit(invite: invite_whitelist)
  end
  belongs_to :user

  validates_uniqueness_of :oid, :scope => :user_id
  validates_presence_of   :oid


  after_create :enqueue_invitation

  private

  def enqueue_invitation
    if completed_at.nil?
      InviteWorker.perform_async(self.id)
    else
      Rails.logger.error("Tried to enqueue invite #{self.id} even though it's been done before...")
    end
  end
end

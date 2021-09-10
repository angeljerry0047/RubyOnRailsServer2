# == Schema Information
#
# Table name: single_user_license_purchases
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  charge_id  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# FIXME (cmhobbs+tyreldenison) remove this
class SingleUserLicensePurchase < ActiveRecord::Base
  def self.permitted(params)
    single_user_license_whitelist = [:charge_id, :user_id]
    params.permit(single_user_license_purchase: single_user_license_whitelist)
  end

  belongs_to :user

  validates_presence_of :user_id

  after_create :notify_manager
  
  private

  def notify_manager
    Notifier.send_license_receipt(self).deliver_now!
  end

end

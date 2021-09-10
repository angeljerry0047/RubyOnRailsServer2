# == Schema Information
#
# Table name: user_license_purchases
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  organization_id    :integer
#  licenses_purchased :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  charge_id          :string(255)
#

# FIXME (cmhobbs+tyreldenison) remove this model
class UserLicensePurchase < ActiveRecord::Base
  def self.permitted(params)
    user_license_purchase_whitelist = [
      :charge_id,
      :licenses_purchased,
      :organization_id,
      :user_id
    ]

    params.permit(user_license_purchase: user_license_purchase_whitelist)
  end

  belongs_to :organization
  belongs_to :user

  validates_presence_of :user_id, :organization_id

  after_create :notify_manager
  
  private

  def notify_manager
    Notifier.send_license_receipt(self).deliver_now!
  end

end

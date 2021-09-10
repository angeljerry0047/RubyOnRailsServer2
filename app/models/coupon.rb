# == Schema Information
#
# Table name: coupons
#
#  id              :integer          not null, primary key
#  code            :string(255)
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  limit           :integer          default(0)
#

# FIXME (cmhobbs+tyreldenison) purge this model
class Coupon < ActiveRecord::Base
  def self.permitted(params)
    coupon_whitelist = [:organization_id, :code, :limit]
    params.permit(coupon: coupon_whitelist)
  end

  THRESHOLD = 2

  belongs_to :organization
  attr_readonly :code
  validates_uniqueness_of :code
  has_many :coupon_uses
  
  before_save :notify_low_threshold!
  
  def uses
    coupon_uses
  end

  def remaining
    self.limit - uses.count
  end

  def notify_low_threshold!
    if self.remaining.zero?
      Notifier.need_more_coupon_purchases(organization.manager).deliver
    end
  end
end

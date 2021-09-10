# == Schema Information
#
# Table name: coupon_uses
#
#  id                   :integer          not null, primary key
#  coupon_id            :integer
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  assessment_report_id :integer
#

# FIXME: (cmhobbs+tyreldenison) purge this model
class CouponUse < ActiveRecord::Base
  def self.permitted(params)
    coupon_use_whitelist = %i[coupon_id user_id assessment_report_id]
    params.permit(coupon_use: coupon_use_whitelist)
  end

  validates_presence_of :coupon_id, :user_id
  validates_uniqueness_of :assessment_report_id, scope: :user_id

  belongs_to :assessment_report
  belongs_to :coupon
  belongs_to :user

  validate :coupon_threshold
  after_create :notify_threshold

  private

  def coupon_threshold
    if !coupon || coupon.uses.count > coupon.limit
      errors.add(:base, 'This coupon code has been used too many times. Contact your organization to add more to it')
    end
  end

  def notify_threshold
    if coupon.coupon_uses.length == [coupon.limit - Coupon::THRESHOLD, 1].max
      Notifier.need_more_coupon_purchases(coupon.organization.manager).deliver_now
    end
  end
end

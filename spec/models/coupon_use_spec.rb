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

require 'spec_helper'

describe CouponUse do
  it 'is invalid if it goes over the coupon limit' do
    coupon = FactoryBot.create(:coupon, :limit => rand((10..30)))
    (coupon.limit + 1).times do |i|
      FactoryBot.create(:coupon_use, :coupon_id => coupon.id, :assessment_report_id => i)
    end
    
    over_limit = FactoryBot.build(:coupon_use, :coupon_id => coupon.id, :assessment_report_id => coupon.limit + 20)
    over_limit.should be_invalid
  end
end
